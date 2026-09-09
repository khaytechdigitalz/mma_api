<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Permission;
use App\Models\Role;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class RolePermissionController extends Controller
{
    /**
     * List all roles with permission counts.
     */
    public function indexRoles(): JsonResponse
    {
        $roles = Role::withCount(['permissions', 'users'])->get();

        return response()->json([
            'status' => true,
            'data'   => $roles
        ]);
    }

    /**
     * List all permissions grouped by domain/module.
     */
    public function indexPermissions(): JsonResponse
    {
        $permissions = Permission::all()->groupBy('group');

        return response()->json([
            'status' => true,
            'data'   => $permissions
        ]);
    }

    /**
     * Create a new custom role with assigned permissions.
     */
    public function storeRole(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:100|unique:roles,name',
            'description'   => 'nullable|string|max:255',
            'permissions'   => 'required|array',
            'permissions.*' => 'exists:permissions,id',
        ]);

        $role = Role::create([
            'name'        => $validated['name'],
            'slug'        => Str::slug($validated['name']),
            'description' => $validated['description'] ?? null,
        ]);

        $role->permissions()->sync($validated['permissions']);

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'create_role',
            'description' => "Created new system role: {$role->name}",
            'new_values'  => $role->load('permissions')->toArray(),
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Role created successfully.',
            'data'    => $role->load('permissions')
        ], 210);
    }

    /**
     * Display role details along with its permissions and currently assigned users.
     */
    public function showRole($id): JsonResponse
    {
        $role = Role::with(['permissions', 'users'])->find($id);

        if (!$role) {
            return response()->json([
                'status'  => false,
                'message' => 'Role not found.'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $role
        ]);
    }

    /**
     * Update an existing role and its permissions.
     */
    public function updateRole(Request $request, $id): JsonResponse
    {
        $role = Role::find($id);
        if (!$role) {
            return response()->json(['status' => false, 'message' => 'Role not found.'], 404);
        }

        $validated = $request->validate([
            'name'          => 'required|string|max:100|unique:roles,name,' . $role->id,
            'description'   => 'nullable|string|max:255',
            'permissions'   => 'required|array',
            'permissions.*' => 'exists:permissions,id',
        ]);

        $role->update([
            'name'        => $validated['name'],
            'slug'        => Str::slug($validated['name']),
            'description' => $validated['description'] ?? null,
        ]);

        $role->permissions()->sync($validated['permissions']);

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_role',
            'description' => "Updated role permissions for: {$role->name}",
            'new_values'  => $role->load('permissions')->toArray(),
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Role updated successfully.',
            'data'    => $role->load('permissions')
        ]);
    }

    /**
     * Remove the specified role from storage.
     */
    public function destroyRole(Request $request, $id): JsonResponse
    {
        $role = Role::find($id);

        if (!$role) {
            return response()->json([
                'status'  => false,
                'message' => 'Role not found.'
            ], 404);
        }

        $roleName = $role->name;
        $role->delete();

        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'delete_role',
            'description' => "Deleted system role: {$roleName}",
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Role deleted successfully.'
        ]);
    }
}