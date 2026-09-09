<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    /**
     * Get authenticated admin profile.
     */
    public function show(Request $request): JsonResponse
    {
        $user = $request->user()->load(['roles', 'roles.permissions']);

        return response()->json([
            'status' => true,
            'data'   => $user
        ]);
    }

    /**
     * Update authenticated admin profile details.
     */
    public function updateProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'name'  => 'required|string|max:150',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20',
            'avatar' => 'nullable|image|mimes:jpeg,jpg,png,gif|max:3172', 
        ]);

        $oldValues = $user->only(['name', 'email', 'phone']);
            // Handle avatar file upload
        if ($request->hasFile('avatar')) {
            // Delete old avatar if it exists
            if ($user->avatar && Storage::disk('public')->exists($user->avatar)) {
                Storage::disk('public')->delete($user->avatar);
            }

            // Store new image and assign path to validation payload
            $path = $request->file('avatar')->store('avatars', 'public');
            $validated['avatar'] = $path;
        } else {
            // Prevent overwriting existing avatar with null if no new file is passed
            unset($validated['avatar']);
        }
        $user->update($validated);

        AuditLog::create([
            'user_id'     => $user->id,
            'action'      => 'update_own_profile',
            'description' => "User updated their profile details",
            'old_values'  => $oldValues,
            'new_values'  => $validated,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Profile updated successfully.',
            'data'    => $user
        ]);
    }

    /**
     * Change authenticated admin password.
     */
    public function updatePassword(Request $request): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'current_password' => 'required|string',
            'password'         => ['required', 'confirmed', Password::defaults()],
        ]);

        if (!Hash::check($validated['current_password'], $user->password)) {
            return response()->json([
                'status'  => false,
                'message' => 'Current password does not match our records.'
            ], 422);
        }

        $user->update([
            'password' => Hash::make($validated['password']),
        ]);

        AuditLog::create([
            'user_id'     => $user->id,
            'action'      => 'update_own_password',
            'description' => "User successfully changed their password",
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Password updated successfully.'
        ]);
    }
}