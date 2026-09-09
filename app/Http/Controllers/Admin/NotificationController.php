<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{

    /**
         * Display a listing of all notifications based on user role (including read ones).
         */
        public function index(Request $request)
        {
            $user = $request->user();
            $query = Notification::latest();

            // If user is not admin or staff, restrict to their own notifications
            if (!in_array($user->type, ['admin', 'staff'])) {
                $query->where('user_id', $user->id);
            }

            $notifications = $query->paginate(15);

            return response()->json([
                'status' => true,
                'data' => $notifications,
            ]);
        }

    /**
     * Display a listing of notifications based on user role.
     * Non-admins see only their unread notifications.
     * Admins/staff see unread system notifications awaiting admin review.
     */
    public function new(Request $request)
    {
        $user = $request->user();
        $query = Notification::latest();

        // If user is not admin or staff, restrict to their own unread notifications
        if (!in_array($user->type, ['admin', 'staff'])) {
            $query->where('user_id', $user->id)
                  ->where('user_read', false);
        } else {
            // Admins/staff see notifications where admin_read is false
            $query->where('admin_read', false);
        }

        $notifications = $query->paginate(15);

        return response()->json([
            'status' => true,
            'data' => $notifications,
        ]);
    }


    
    /**
     * Display the specified notification details and mark admin_read as true.
     */
    public function show(Request $request, $id)
    {
        $user = $request->user();

        $query = Notification::where('id', $id);

        // Enforce ownership check if not admin or staff
        if (!in_array($user->type, ['admin', 'staff'])) {
            $query->where('user_id', $user->id);
        }

        $notification = $query->firstOrFail();

        // Mark admin_read as true if it hasn't been set yet
        if (!$notification->admin_read) {
            $notification->update(['admin_read' => true]);
        }

        return response()->json([
            'status' => true,
            'data' => $notification,
        ]);
    }
}