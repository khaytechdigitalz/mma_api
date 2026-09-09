<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\OrderStatusHistory;
use App\Mail\AbandonedCartReminderMail;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;

class AbandonedCartController extends Controller
{
    /**
     * View all abandoned carts (Inactive for > 24 hours).
     */
    public function index(Request $request): JsonResponse
    {
        $hours = $request->get('hours', 24);

        $query = Cart::where('user_id','!=', null)->with(['user:id,name,email,phone', 'items.product:id,name,sku'])
            ->abandoned($hours);

        // Filter: User ID
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter: Notification status
        if ($request->filled('notified')) {
            if ($request->boolean('notified')) {
                $query->whereNotNull('abandoned_notification_sent_at');
            } else {
                $query->whereNull('abandoned_notification_sent_at');
            }
        }

        $carts = $query->latest('last_activity_at')->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => $carts,
        ]);
    }

    /**
     * View single abandoned cart details.
     */
    public function show(int $id): JsonResponse
    {
        $cart = Cart::where('user_id','!=', null)->with(['user:id,name,email,phone', 'items.product:id,name,sku,unit_price'])
            ->findOrFail($id);

        return response()->json([
            'status' => true,
            'data'   => $cart,
        ]);
    }

    /**
     * Send email notification to a single abandoned cart owner.
     */
    public function sendNotification(Request $request, int $id): JsonResponse
    {
        $cart = Cart::where('user_id','!=', null)->with(['user', 'items.product'])->findOrFail($id);

        if (!$cart->user || !$cart->user->email) {
            return response()->json([
                'status'  => false,
                'message' => 'Cannot send email: Cart does not belong to a registered user with a valid email address.',
            ], 422);
        }

         // SEND EMAIL OPERATION STARTS
        $message = [
            'cart' => $cart,
            'subject' => 'Reset Password',
        ];
        sendEmail($cart->user->email, $message, 'forgot_password');
        // SEND EMAIL OPERATION ENDS


        Mail::to($cart->user->email)->queue(new AbandonedCartReminderMail($cart));

        $cart->update([
            'abandoned_notification_sent_at' => Carbon::now(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Abandoned cart recovery email queued successfully.',
            'data'    => $cart,
        ]);
    }

    /**
     * Bulk send email notifications to all unnotified abandoned carts.
     */
    public function sendBulkNotifications(Request $request): JsonResponse
    {
        $hours = $request->get('hours', 24);

        $abandonedCarts = Cart::where('user_id','!=', null)->with(['user', 'items.product'])
            ->unnotifiedAbandoned($hours)
            ->whereHas('user', function ($q) {
                $q->whereNotNull('email');
            })
            ->get();

        $sentCount = 0;

        foreach ($abandonedCarts as $cart) {
            Mail::to($cart->user->email)->queue(new AbandonedCartReminderMail($cart));

            $cart->update([
                'abandoned_notification_sent_at' => Carbon::now(),
            ]);

            $sentCount++;
        }

        return response()->json([
            'status'     => true,
            'message'    => "Queued recovery emails for {$sentCount} abandoned carts.",
            'sent_count' => $sentCount,
        ]);
    }

    /**
     * Clear items from an abandoned cart or delete it.
     */
    public function destroy(int $id): JsonResponse
    {
        $cart = Cart::findOrFail($id);

        DB::transaction(function () use ($cart) {
            $cart->items()->delete();
            $cart->delete();
        });

        return response()->json([
            'status'  => true,
            'message' => 'Abandoned cart cleared and deleted successfully.',
        ]);
    }
}