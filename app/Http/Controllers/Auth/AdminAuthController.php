<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Helpers\AgentHelper;
use App\Models\UserLogin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use PragmaRX\Google2FA\Google2FA;

class AdminAuthController extends Controller
{
 

   /**
     * Handle Admin login request.
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required|string|min:4',
        ], [
            'email.required'    => 'The email field is required.',
            'email.email'       => 'Please provide a valid email address.',
            'password.required' => 'The password field is required.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'admin')
                    ->first();

        // 1. Check user existence
        if (!$user) {
            return response()->json([
                'status'  => false,
                'message' => 'The provided credentials are incorrect or you do not have admin access.',
            ], 401);
        }

        // 2. Strict status check
        if ($user->status !== 'active') {
            return response()->json([
                'status'  => false,
                'message' => 'Your account is currently inactive or disabled. Please contact support.',
            ], 403);
        }

        // 3. Block login if attempts exceeded 3
        if ($user->login_attempts >= 3) {
            if ($user->status !== 'disabled') {
                $user->update([
                    'status'      => 'disabled',
                    'disabled_at' => now(),
                ]);
            }

            return response()->json([
                'status'  => false,
                'message' => 'Your account is locked due to 3 consecutive failed login attempts. Contact support to restore access.',
            ], 403);
        }

        // 4. Validate password
        if (!Hash::check($request->password, $user->password)) {
            $user->increment('login_attempts');
            $user->refresh();

            if ($user->login_attempts >= 3) {
                $user->update([
                    'status'      => 'disabled',
                    'disabled_at' => now(),
                ]);

                return response()->json([
                    'status'  => false,
                    'message' => 'Your account has been disabled due to 3 consecutive failed login attempts.',
                ], 403);
            }

            $attemptsLeft = 3 - $user->login_attempts;

            return response()->json([
                'status'  => false,
                'message' => "The provided credentials are incorrect. You have {$attemptsLeft} attempt(s) remaining.",
            ], 401);
        }

        // 5. Check if Google 2FA is enabled
       if ((int) $user->google2fa_enabled === 1) {
            $challengeToken = \Str::random(64);

            // Store temporary challenge string in remember_token & reset attempts
            $user->update([
                'remember_token' => $challengeToken,
                'login_attempts' => 0,
            ]);

            return response()->json([
                'status'       => true,
                'requires_2fa' => true,
                'message'      => 'Please provide your Google Authenticator code to complete login.',
                'data'    => [
                    'token'  => $challengeToken,
                ]
            ], 200);
        }

        // 6. Success Path (No 2FA): Extract client metadata dynamically
        $agentData = AgentHelper::parse($request);

        // Save successful login record to users_logins table
        UserLogin::create(array_merge(
            ['user_id' => $user->id],
            $agentData
        ));

        // Reset login attempts counter & update timestamp
        $user->update([
            'login_attempts' => 0,
            'last_login'     => now(),
        ]);

        // Issue token with system-detected device name
        $token = $user->createToken($agentData['device_name'], ['role:admin'])->plainTextToken;

        return response()->json([
            'status'  => true,
            'message' => 'Login successful',
            'data'    => [
                'user'       => $user,
                'token'      => $token,
                'token_type' => 'Bearer',
                'session'    => [
                    'ip_address'  => $agentData['ip_address'],
                    'location'    => "{$agentData['city']}, {$agentData['country']}",
                    'device_name' => $agentData['device_name'],
                ],
            ],
        ]);
    }


    /**
     * Handle Google 2FA verification using the temporary remember_token and issue final token.
     */
    public function verify2fa(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'token'             => 'required|string',
            'one_time_password' => 'required|string',
        ], [
            'token.required'             => 'The 2FA session token is missing.',
            'one_time_password.required' => 'The 2FA authentication code is required.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        // Find user by the temporary remember_token string
        $user = User::where('remember_token', $request->token)
                    ->where('type', 'admin')
                    ->first();
        if (!$user || $user->status !== 'active') {
            return response()->json([
                'status'  => false,
                'message' => 'Invalid or expired 2FA session. Please log in again.'.$user,
            ], 403);
        }

        // Validate the Google 2FA token using pragmaRX/google2fa package
        $google2fa = new Google2FA();
        $valid = $google2fa->verifyKey($user->google2fa_secret, $request->one_time_password);

        if (!$valid) {
            return response()->json([
                'status'  => false,
                'message' => 'The provided 2FA code is invalid. Please try again.',
            ], 422);
        }

        // Clear the temporary remember_token so it cannot be reused and update last login
        $user->update([
            'remember_token' => null,
            'last_login'     => now(),
        ]);

        // 2FA Verified Successfully: Extract metadata & log session
        $agentData = AgentHelper::parse($request);

        UserLogin::create(array_merge(
            ['user_id' => $user->id],
            $agentData
        ));

        // Issue final Sanctum token
        $token = $user->createToken($agentData['device_name'], ['role:admin'])->plainTextToken;

        return response()->json([
            'status'  => true,
            'message' => '2FA verification successful. Login complete.',
            'data'    => [
                'user'       => $user,
                'token'      => $token,
                'token_type' => 'Bearer',
                'session'    => [
                    'ip_address'  => $agentData['ip_address'],
                    'location'    => "{$agentData['city']}, {$agentData['country']}",
                    'device_name' => $agentData['device_name'],
                ],
            ],
        ]);
    }
    /**
     * Handle forgot password request for Admin.
     */
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation errors',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'admin')
                    ->first();

        if (!$user) {
            return response()->json([
                'status' => false,
                'message' => 'The provided email is incorrect or not registered as an admin.',
            ], 404);
        }

        // Rate limit check (2 minutes)
        if ($user->otp_sent_at && $user->otp_sent_at->diffInMinutes(now()) < 2) {
            $secondsRemaining = 120 - $user->otp_sent_at->diffInSeconds(now());

            return response()->json([
                'status' => false,
                'message' => 'Please wait '.round($secondsRemaining).' seconds before requesting another code.',
            ], 429);
        }

        $otp = (string) rand(100000, 999999);

        // Mail notification logic goes here...

        $user->otp = Hash::make($otp);
        $user->otp_sent_at = now();
        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'OTP sent successfully'.$otp,
            // Omit OTP key in production
        ]);
    }

    /**
     * Verify OTP.
     */
    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'otp' => 'required|string|max:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation errors',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'admin')
                    ->first();

        if (!$user || !$user->otp || !Hash::check((string)$request->otp, $user->otp)) {
            return response()->json([
                'status' => false,
                'message' => 'Please provide a valid OTP.',
            ], 422);
        }

        return response()->json([
            'status' => true,
            'message' => 'OTP verified successfully',
        ]);
    }

    /**
     * Reset password using OTP.
     */
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'otp' => 'required|string|max:6',
            'password' => 'required|string|min:5|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation errors',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'admin')
                    ->first();

        if (!$user || !$user->otp || !Hash::check((string)$request->otp, $user->otp)) {
            return response()->json([
                'status' => false,
                'message' => 'Please provide a valid OTP.',
            ], 422);
        }

        $user->otp = null;
        $user->otp_sent_at = null;
        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json([
            'status' => true,
            'message' => 'Password reset successful',
        ]);
    }

    /**
     * Revoke current access token.
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => true,
            'message' => 'Logged out successfully',
        ]);
    }

    /**
     * Get authenticated user details.
     */
    public function me(Request $request)
    {
        return response()->json([
            'status' => true,
            'message' => 'User details retrieved successfully',
            'data' => [
                'user' => $request->user(),
            ],
        ]);
    }
}