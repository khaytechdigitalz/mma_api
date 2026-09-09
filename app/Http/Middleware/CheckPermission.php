<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPermission
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  string  $permission  The permission slug required to access the route
     */
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        $user = $request->user();

        // 1. Ensure user is authenticated
        if (!$user) {
            return response()->json([
                'status'  => false,
                'message' => 'Unauthenticated.'
            ], 401);
        }

        // 2. Super Admin Bypass (Full system access)
        if ($user->type === 'admin') {
            return $next($request);
        }

        // 3. Check for Staff User authorization
        if ($user->type === 'staff') {
            // Check if user is active
            if ($user->status !== 'active') {
                return response()->json([
                    'status'  => false,
                    'message' => 'Your staff account is currently inactive or disabled.'
                ], 403);
            }

            // Verify if staff user has the requested permission slug
            if ($user->hasPermission($permission)) {
                return $next($request);
            }

            return response()->json([
                'status'  => false,
                'message' => "Access denied. You lack the required permission: '{$permission}'."
            ], 403);
        }

        // 4. Default Deny for non-admin/staff user types
        return response()->json([
            'status'  => false,
            'message' => 'Unauthorized area.'
        ], 403);
    }
}