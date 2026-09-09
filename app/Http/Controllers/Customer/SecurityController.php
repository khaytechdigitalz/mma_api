<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use PragmaRX\Google2FA\Google2FA;

class SecurityController extends Controller
{
    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $customer = $request->user();

        if (!Hash::check($request->current_password, $customer->password)) {
            return response()->json([
                'status' => false,
                'message' => 'Current password does not match.'
            ], 422);
        }

        $customer->password = Hash::make($request->password);
        $customer->save();

        return response()->json([
            'status' => true,
            'message' => 'Password updated successfully.'
        ]);
    }

    public function setup2fa(Request $request)
    {
        $customer = $request->user();
        $google2fa = new Google2FA();

        if (!$customer->google2fa_secret) {
            $customer->google2fa_secret = $google2fa->generateSecretKey();
            $customer->save();
        }

        $inlineUrl = $google2fa->getQRCodeUrl(
            config('app.name'),
            $customer->email,
            $customer->google2fa_secret
        );

        return response()->json([
            'status' => true,
            'message' => '2FA secret generated successfully.',
            'data' => [
                'secret' => $customer->google2fa_secret,
                'qr_code_url' => $inlineUrl,
            ]
        ]);
    }

    public function enable2fa(Request $request)
    {
        $request->validate([
            'otp' => 'required|string|size:6',
        ]);

        $customer = $request->user();
        $google2fa = new Google2FA();

        $valid = $google2fa->verifyKey($customer->google2fa_secret, $request->otp);

        if (!$valid) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid verification code.'
            ], 422);
        }

        $customer->google2fa_enabled = true;
        $customer->save();

        return response()->json([
            'status' => true,
            'message' => 'Google 2FA enabled successfully.'
        ]);
    }

    public function disable2fa(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string',
        ]);

        $customer = $request->user();

        if (!Hash::check($request->current_password, $customer->password)) {
            return response()->json([
                'status' => false,
                'message' => 'Password verification failed.'
            ], 422);
        }

        $customer->google2fa_enabled = false;
        $customer->google2fa_secret = null;
        $customer->save();

        return response()->json([
            'status' => true,
            'message' => 'Google 2FA disabled successfully.'
        ]);
    }
}