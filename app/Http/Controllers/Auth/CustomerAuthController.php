<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Helpers\AgentHelper;
use App\Models\UserLogin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class CustomerAuthController extends Controller
{
    /**
     * Handle buyer registration request and trigger email verification.
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email',
            'password' => 'required|string|min:6|confirmed',
            'phone'    => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $otp = (string) rand(100000, 999999);

        // Create user with 'pending' status until email is verified
        $user = User::create([
            'name'        => $request->name,
            'email'       => $request->email,
            'password'    => Hash::make($request->password),
            'phone'       => $request->phone,
            'type'        => 'buyer',
            'status'      => 'pending', 
            'otp'         => Hash::make($otp),
            'otp_sent_at' => now(),
        ]);

        // TODO: Dispatch actual email notification containing $otp here...

        return response()->json([
            'status'  => true,
            'message' => 'Registration successful. Please verify your email address using the OTP sent.',
            'data'    => [
                'email'       => $user->email,
                'otp_preview' => $otp, // Remove in production environment
            ],
        ], 201);
    }

    /**
     * Verify buyer email address via OTP.
     */
    public function verifyEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'otp'   => 'required|string|max:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'buyer')
                    ->first();

        if (!$user || !$user->otp || !Hash::check((string)$request->otp, $user->otp)) {
            return response()->json([
                'status'  => false,
                'message' => 'Invalid or expired verification code.',
            ], 422);
        }

        // Activate user and clear verification OTP
        $user->update([
            'status'             => 'active',
            'email_verified_at'  => now(),
            'otp'                => null,
            'otp_sent_at'        => null,
        ]);

        $agentData = AgentHelper::parse($request);

        UserLogin::create(array_merge(
            ['user_id' => $user->id],
            $agentData
        ));

       // $token = $user->createToken($agentData['device_name'], ['role:buyer'])->plainTextToken;

        return response()->json([
            'status'  => true,
            'message' => 'Email verified successfully. You are can now login to account.',
            'data'    => [
                'user'       => $user,
             //   'token'      => $token,
             //   'token_type' => 'Bearer',
            ],
        ]);
    }

    /**
     * Resend Email Verification OTP.
     */
    public function resendVerificationEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('type', 'buyer')
                    ->first();

        if (!$user) {
            return response()->json([
                'status'  => false,
                'message' => 'Account not found.',
            ], 404);
        }

        if ($user->status === 'active') {
            return response()->json([
                'status'  => false,
                'message' => 'This email is already verified. Please login.',
            ], 400);
        }

        // Rate limit check (2 minutes)
        if ($user->otp_sent_at && $user->otp_sent_at->diffInMinutes(now()) < 2) {
            $secondsRemaining = 120 - $user->otp_sent_at->diffInSeconds(now());

            return response()->json([
                'status'  => false,
                'message' => 'Please wait '.round($secondsRemaining).' seconds before requesting another code.',
            ], 429);
        }

        $otp = (string) rand(100000, 999999);

        // TODO: Dispatch email notification here...

        $user->update([
            'otp'         => Hash::make($otp),
            'otp_sent_at' => now(),
        ]);

        return response()->json([
            'status'      => true,
            'message'     => 'Verification code resent successfully.',
            'otp_preview' => $otp, // Remove in production
        ]);
    }

    /**
     * Handle buyer login request.
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
                    ->where('type', 'buyer')
                    ->first();

        // 1. Check user existence
        if (!$user) {
            return response()->json([
                'status'  => false,
                'message' => 'The provided credentials are incorrect or you do not have buyer access.',
            ], 401);
        }

        // 2. Strict status check (Blocks login if pending verification or disabled)
        if ($user->status === 'pending') {
            return response()->json([
                'status'  => false,
                'message' => 'Please verify your email address before logging in.',
            ], 403);
        }

        if ($user->status !== 'active') {
            return response()->json([
                'status'  => false,
                'message' => 'Your account is currently disabled. Please contact support.',
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

        // 5. Success Path
        $agentData = AgentHelper::parse($request);

        UserLogin::create(array_merge(
            ['user_id' => $user->id],
            $agentData
        ));

        $user->update([
            'login_attempts' => 0,
            'last_login'     => now(),
        ]);

        $token = $user->createToken($agentData['device_name'], ['role:buyer'])->plainTextToken;

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
     * Handle forgot password request for buyer.
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
                    ->where('type', 'buyer')
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
            'message' => 'OTP sent successfully',
            'temp' => $otp,
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
                    ->where('type', 'buyer')
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
                    ->where('type', 'buyer')
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
     * Get authenticated buyer profile details.
     */
    public function profile(Request $request)
    {
        return response()->json([
            'status'  => true,
            'message' => 'Customer profile retrieved successfully',
            'data'    => [
                'user' => $request->user(),
            ],
        ]);
    }

    /**
     * Update authenticated buyer profile details.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name'  => 'sometimes|required|string|max:255',
            'phone' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user->update($request->only(['name', 'phone']));

        return response()->json([
            'status'  => true,
            'message' => 'Profile updated successfully',
            'data'    => [
                'user' => $user,
            ],
        ]);
    }

    /**
     * Revoke current access token (Logout).
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Logged out successfully',
        ]);
    }
}