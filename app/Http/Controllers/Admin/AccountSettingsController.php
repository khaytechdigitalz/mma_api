<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use PragmaRX\Google2FA\Google2FA;

class AccountSettingsController extends Controller
{
    /**
     * View current user account details.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'status' => true,
            'data' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'type' => $user->type,
                'status' => $user->status,
                'phone' => $user->phone,
                'avatar' => $user->avatar ? asset('storage/app/public/' . $user->avatar) : null,
                'google2fa_enabled' => (bool) $user->google2fa_enabled,
                'created_at' => $user->created_at,
            ]
        ]);
    }

    /**
     * Update user name, phone number, and avatar.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:20'],
            'avatar' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'],
        ]);

        $user->name = $validated['name'];
        $user->phone = $validated['phone'] ?? $user->phone;

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists
            if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
                Storage::disk('public')->delete($user->avatar);
            }

            $path = $request->file('avatar')->store('avatars', 'public');
            $user->avatar = $path;
        }

        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'Profile updated successfully.',
            'data' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
                'avatar' => $user->avatar ? asset('storage/app/public/' . $user->avatar) : null,
            ]
        ]);
    }

    /**
     * Update user password.
     */
    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => ['required', 'current_password'],
            'password' => ['required', 'string', 'min:4', 'confirmed'],
        ]);

        $user = $request->user();
        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'Password updated successfully.',
        ]);
    }

    /**
     * Setup Google 2FA (Generates secret and QR code url/inline data).
     */
    public function setup2fa(Request $request)
    {
        $user = $request->user();
        $google2fa = new Google2FA();

        // Generate secret key if not already present or generate a fresh one for setup
        $secret = $google2fa->generateSecretKey();
        
        // Temporarily store secret (or save it, but keep enabled = false until verified)
        $user->google2fa_secret = $secret;
        $user->save();

        $companyName = config('app.name', 'Khaytech Digitalz');
        $otpauthUrl = $google2fa->getQRCodeUrl(
            $companyName,
            $user->email,
            $secret
        );

        return response()->json([
            'status' => true,
            'data' => [
                'secret' => $secret,
                'qr_code_url' => $otpauthUrl,
            ]
        ]);
    }

    /**
     * Enable Google 2FA by verifying the OTP code.
     */
    public function enable2fa(Request $request)
    {
        $request->validate([
            'code' => ['required', 'string', 'size:6'],
        ]);

        $user = $request->user();

        if (!$user->google2fa_secret) {
            return response()->json([
                'status' => false,
                'message' => 'Please initialize 2FA setup first.',
            ], 400);
        }

        $google2fa = new Google2FA();
        $valid = $google2fa->verifyKey($user->google2fa_secret, $request->code);

        if (!$valid) {
            throw ValidationException::withMessages([
                'code' => ['The 2FA verification code is invalid.'],
            ]);
        }

        $user->google2fa_enabled = true;
        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'Google 2FA has been successfully enabled.',
        ]);
    }

    /**
     * Disable Google 2FA.
     */
     public function disable2fa(Request $request)
    {
        $request->validate([
            'password' => ['required', 'current_password'],
            'code' => ['required', 'string', 'size:6'],
        ]);

        $user = $request->user();

        if (!$user->google2fa_secret) {
            return response()->json([
                'status' => false,
                'message' => 'Please initialize 2FA setup first.',
            ], 400);
        }

        $google2fa = new Google2FA();
        $valid = $google2fa->verifyKey($user->google2fa_secret, $request->code);

        if (!$valid) {
            throw ValidationException::withMessages([
                'code' => ['The 2FA verification code is invalid.'],
            ]);
        }

        $user->google2fa_enabled = true;
        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'Google 2FA has been successfully enabled.',
        ]);
    } 
}