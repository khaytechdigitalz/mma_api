<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Role;
use App\Models\User;
use App\Models\UserInvitation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules\Password;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use App\Notifications\StaffInvitationNotification;

class AdminUserController extends Controller
{
    /**
     * List administrative staff users from the users table.
     */
    public function index(Request $request): JsonResponse
    {
        $admins = User::where('type','staff')
            ->with(['roles', 'roles.permissions'])
            ->latest()
            ->paginate($request->get('per_page', 15));

        return response()->json(['status' => true, 'data' => $admins]);
    }

    /**
     * Get administrative staff user details from the users table.
     */
    public function StaffProfile(Request $request, $id): JsonResponse
    {
        $admins = User::where('type','staff')
            ->whereId($id)
            ->with(['roles', 'roles.permissions'])
            ->latest()->first();

        return response()->json(['status' => true, 'data' => $admins]);
    }
 

/**
 * Invite a new staff user.
 */
public function invite(Request $request): JsonResponse
{
    $validated = $request->validate([
        'name'    => 'required|string|max:150',
        'email'   => 'required|email|unique:users,email|unique:user_invitations,email',
        'phone'   => 'required|string|max:20',
        'role_id' => 'required|exists:roles,id',
    ]);

    // Generate random secure password & invitation token
    $plainPassword = Str::random(12);
    $token = Str::random(40);

    // Capture the returned array from the transaction into $data
    $data = DB::transaction(function () use ($validated, $request, $plainPassword, $token) {
        // 1. Create invitation record
        $invitation = UserInvitation::create([
            'name'       => $validated['name'],
            'email'      => $validated['email'],
            'phone'      => $validated['phone'],
            'role_id'    => $validated['role_id'],
            'token'      => $token,
            'status'     => 'pending',
            'invited_by' => $request->user()?->id,
            'expires_at' => now()->addDays(7),
        ]);

        // 2. Insert into users table
        $user = User::create([
            'name'     => $validated['name'],
            'email'    => $validated['email'],
            'phone'    => $validated['phone'],
            'created_by' => $request->user()?->id,
            'password' => Hash::make($plainPassword),
            'type'     => 'staff',
            'status'   => 'pending',
        ]);

        // 3. Attach role to staff user
        if (method_exists($user, 'roles')) {
            $user->roles()->sync([$validated['role_id']]);
        }

        // 4. Log Audit Trail
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'invite_admin_user',
            'description' => "Created staff account #{$user->id} ({$validated['email']}) and issued role ID {$validated['role_id']}",
            'new_values'  => [
                'user'       => $user->only(['id', 'name', 'email', 'phone', 'type', 'status']),
                'invitation' => $invitation->toArray(),
            ],
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return ['user' => $user, 'invitation' => $invitation];
    });

    // $data is now available in this scope
    $data['user']->notify(new StaffInvitationNotification([
        'name'     => $validated['name'],
        'email'    => $validated['email'],
        'password' => $plainPassword,
        'token'    => $token,
    ]));

    return response()->json([
        'status'  => true,
        'message' => 'Staff user created and invitation email sent successfully.',
        'data'    => $data['user']
    ], 201);
}

    /**
 * Update a staff member's profile details.
 */
public function updateStaffProfile(Request $request, $id): JsonResponse
{
    $staff = User::where('type', 'staff')->find($id);
    if (!$staff) {
        return response()->json(['status' => false, 'message' => 'Staff user not found.'], 404);
    }

    $validated = $request->validate([
        'name'   => 'required|string|max:150',
        'email'  => 'required|email|unique:users,email,' . $staff->id,
        'phone'  => 'nullable|string|max:20',
        'avatar' => 'nullable|image|mimes:jpeg,jpg,png,gif|max:3172', // Max 3.1 MB matching UI
    ]);

    $oldValues = $staff->only(['name', 'email', 'phone', 'avatar']);

    // Handle avatar file upload
    if ($request->hasFile('avatar')) {
        // Delete old avatar if it exists
        if ($staff->avatar && Storage::disk('public')->exists($staff->avatar)) {
            Storage::disk('public')->delete($staff->avatar);
        }

        // Store new image and assign path to validation payload
        $path = $request->file('avatar')->store('avatars', 'public');
        $validated['avatar'] = $path;
    } else {
        // Prevent overwriting existing avatar with null if no new file is passed
        unset($validated['avatar']);
    }

    $staff->update($validated);

    AuditLog::create([
        'user_id'     => $request->user()?->id,
        'action'      => 'update_staff_profile',
        'description' => "Updated profile details for staff member #{$staff->id} ({$staff->email})",
        'old_values'  => $oldValues,
        'new_values'  => $staff->only(['name', 'email', 'phone', 'avatar']),
        'ip_address'  => $request->ip(),
        'user_agent'  => $request->userAgent(),
    ]);

    return response()->json([
        'status'  => true,
        'message' => 'Staff profile updated successfully.',
        'data'    => $staff->fresh()
    ]);
}

    /**
     * Administrative override to update a staff member's password.
     */
    public function updateStaffPassword(Request $request, $id): JsonResponse
    {
        $staff = User::where('type', 'staff')->find($id);
        if (!$staff) {
            return response()->json(['status' => false, 'message' => 'Staff user not found.'], 404);
        }

        $validated = $request->validate([
            'password' => ['required', Password::defaults()],
        ]);

        $staff->update([
            'password' => Hash::make($validated['password']),
        ]);

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_staff_password',
            'description' => "Admin reset password for staff member #{$staff->id} ({$staff->email})",
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Staff password updated successfully.'
        ]);
    }

    /**
     * Toggle status of an existing staff member in the users table.
     */
    public function toggleStatus(Request $request, $id): JsonResponse
    {
        $staff = User::where('type', 'staff')->find($id);
        if (!$staff) {
            return response()->json(['status' => false, 'message' => 'Staff user not found.'], 404);
        }

        // Prevent admin from disabling their own account
        if ($staff->id === $request->user()->id) {
            return response()->json(['status' => false, 'message' => 'You cannot disable your own account.'], 400);
        }

        $validated = $request->validate([
            'status' => 'required|in:active,disabled',
        ]);

        $oldStatus = $staff->status;
        $staff->update(['status' => $validated['status']]);

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'toggle_staff_status',
            'description' => "Changed status of staff member #{$staff->id} ({$staff->email}) to {$validated['status']}",
            'old_values'  => ['status' => $oldStatus],
            'new_values'  => ['status' => $validated['status']],
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => "Staff account status changed to {$validated['status']}.",
            'data'    => $staff
        ]);
    }

    /**
     * Change role of an existing staff member in the users table.
     */
    public function changeRole(Request $request, $id): JsonResponse
    {
        $staff = User::where('type','staff')->find($id);
        if (!$staff) {
            return response()->json(['status' => false, 'message' => 'Staff user not found.'], 404);
        }

        $validated = $request->validate([
            'role_id' => 'required|exists:roles,id',
        ]);

        $staff->roles()->sync([$validated['role_id']]);

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'change_staff_role',
            'description' => "Assigned role ID {$validated['role_id']} to staff member #{$staff->id} ({$staff->email})",
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Staff user role updated successfully.',
            'data'    => $staff->load('roles')
        ]);
    }

    /**
     * Delete a staff user from the system.
     */
    public function destroy(Request $request, $id): JsonResponse
    {
        $staff = User::where('type','staff')->find($id);
        if (!$staff) {
            return response()->json(['status' => false, 'message' => 'Staff user not found.'], 404);
        }

        // Prevent self-deletion
        if ($staff->id === $request->user()->id) {
            return response()->json(['status' => false, 'message' => 'You cannot delete your own account.'], 400);
        }

        $staffEmail = $staff->email;
        $staffId    = $staff->id;

        // Detach roles before deletion
        $staff->roles()->detach();
        $staff->delete();

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'delete_staff_user',
            'description' => "Deleted staff user #{$staffId} ({$staffEmail})",
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Staff user deleted successfully.'
        ]);
    }
}