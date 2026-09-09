<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\OrderRefund;
use App\Models\OrderTransaction;
use App\Models\OrderStatusHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class RefundController extends Controller
{
    /**
 * View list of refund requests with filters and summary metrics.
 */
public function index(Request $request): JsonResponse
{
    // 1. Fetch total count & amount per status using Eloquent Grouping
    $groupedMetrics = OrderRefund::query()
        ->select('status')
        ->selectRaw('COUNT(*) as count, SUM(refund_amount) as total_value')
        ->groupBy('status')
        ->get()
        ->keyBy('status');

    $pending = $groupedMetrics->get('pending');
    $approved = $groupedMetrics->get('approved');
    $declined = $groupedMetrics->get('declined');

    $totalCount = $groupedMetrics->sum('count');
    $totalValue = $groupedMetrics->sum('total_value');

    $metrics = [
        'pending' => [
            'count' => (int) ($pending->count ?? 0),
            'value' => (float) ($pending->total_value ?? 0),
        ],
        'approved' => [
            'count' => (int) ($approved->count ?? 0),
            'value' => (float) ($approved->total_value ?? 0),
        ],
        'declined' => [
            'count' => (int) ($declined->count ?? 0),
            'value' => (float) ($declined->total_value ?? 0),
        ],
        'total' => [
            'count' => (int) $totalCount,
            'value' => (float) $totalValue,
        ],
    ];

    // 2. Build filtered listing query
    $query = OrderRefund::with([
        'user:id,name,email,phone',
        'seller:id,name,email,phone',
        'order:id,order_no,payment_status',
    ]);

    if ($request->filled('status')) {
        $query->where('status', $request->status);
    }

    if ($request->filled('order_no')) {
        $query->where('order_no', 'like', '%' . $request->order_no . '%');
    }

    if ($request->filled('transaction_ref')) {
        $query->where('transaction_ref', $request->transaction_ref);
    }

    if ($request->filled('user_id')) {
        $query->where('user_id', $request->user_id);
    }

    if ($request->filled('seller_id')) {
        $query->where('seller_id', $request->seller_id);
    }

    $refunds = $query->latest()->paginate($request->get('per_page', 15));

    // 3. Return response with metrics and paginated records
    return response()->json([
        'status'  => true,
        'metrics' => $metrics,
        'data'    => $refunds,
    ]);
}

    /**
     * View full details of a single refund request.
     */
    public function show(int $id): JsonResponse
    {
        $refund = OrderRefund::with([
            'user:id,name,email,phone',
            'seller:id,name,email,phone',
            'order.items.product:id,name,sku',
            'processedBy:id,name,email',
        ])->findOrFail($id);

        return response()->json([
            'status' => true,
            'data'   => $refund,
        ]);
    }

    /**
     * Approve a refund request, update order audit log, and send email notification.
     */
    public function approve(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'admin_notes' => 'nullable|string',
        ]);

        $refund = OrderRefund::with(['user', 'seller', 'order'])->findOrFail($id);

        if ($refund->status !== 'pending') {
            return response()->json([
                'status'  => false,
                'message' => "This refund request has already been {$refund->status}.",
            ], 422);
        }

        DB::transaction(function () use ($refund, $request) {
            $adminNotes = $request->admin_notes ?? 'Refund request approved by administrator.';

            // 1. Update refund record status
            $refund->update([
                'status'               => 'approved',
                'admin_notes'          => $adminNotes,
                'processed_by_user_id' => auth()->id(),
                'processed_at'         => Carbon::now(),
            ]);

            // 2. Update parent order payment status
            if ($refund->order) {
                $refund->order->update(['payment_status' => 'refunded']);

                // Audit Log: Order History Trail
                OrderStatusHistory::create([
                    'order_id'           => $refund->order_id,
                    'status'             => $refund->order->order_status,
                    'comment'            => "ACTION: Refund Approved | Refund No: {$refund->refund_no} | Amount: {$refund->refund_amount} | Admin Note: {$adminNotes}",
                    'changed_by_user_id' => auth()->id(),
                ]);
            }

            // 3. Update original transaction status if matching reference exists
            OrderTransaction::where('transaction_ref', $refund->transaction_ref)
                ->update(['status' => 'refunded']);
        });

        // SEND EMAIL OPERATION STARTS
        if ($refund->user && $refund->user->email) {
            $message = [
                'name'   => $refund->user->name,
                'refund_no'   => $refund->refund_no,
                'order_no'    => $refund->order_no,
                'amount'      => number_format($refund->refund_amount, 2),
                'admin_notes' => $refund->admin_notes,
                'subject'     => 'Refund Request Approved - ' . $refund->refund_no,
            ];
            sendEmail($refund->user->email, $message, 'refund_approved');
        }
        // SEND EMAIL OPERATION ENDS

        return response()->json([
            'status'  => true,
            'message' => 'Refund request approved successfully, audit log recorded, and buyer notified.',
            'data'    => $refund,
        ]);
    }

    /**
     * Decline a refund request, update order audit log, and send email notification.
     */
    public function decline(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'admin_notes' => 'required|string',
        ]);

        $refund = OrderRefund::with(['user', 'seller', 'order'])->findOrFail($id);

        if ($refund->status !== 'pending') {
            return response()->json([
                'status'  => false,
                'message' => "This refund request has already been {$refund->status}.",
            ], 422);
        }

        DB::transaction(function () use ($refund, $request) {
            // 1. Update refund record status
            $refund->update([
                'status'               => 'declined',
                'admin_notes'          => $request->admin_notes,
                'processed_by_user_id' => auth()->id(),
                'processed_at'         => Carbon::now(),
            ]);

            // 2. Audit Log: Order History Trail
            if ($refund->order) {
                OrderStatusHistory::create([
                    'order_id'           => $refund->order_id,
                    'status'             => $refund->order->order_status,
                    'comment'            => "ACTION: Refund Declined | Refund No: {$refund->refund_no} | Reason: {$request->admin_notes}",
                    'changed_by_user_id' => auth()->id(),
                ]);
            }
        });

        // SEND EMAIL OPERATION STARTS
        if ($refund->user && $refund->user->email) {
            $message = [
                'name'   => $refund->user->name,
                'refund_no'   => $refund->refund_no,
                'order_no'    => $refund->order_no,
                'amount'      => number_format($refund->refund_amount, 2),
                'admin_notes' => $refund->admin_notes,
                'subject'     => 'Refund Request Update - ' . $refund->refund_no,
            ];
            sendEmail($refund->user->email, $message, 'refund_declined');
        }
        // SEND EMAIL OPERATION ENDS

        return response()->json([
            'status'  => true,
            'message' => 'Refund request declined, audit log recorded, and buyer notified.',
            'data'    => $refund,
        ]);
    }
}