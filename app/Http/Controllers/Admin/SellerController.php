<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Order;
use App\Models\OrderRefund;
use App\Models\OrderSettlement;
use App\Models\Product;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SellerController extends Controller
{
    /**
     * List all sellers with storefront info, product counts, and status filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = User::sellers()->with(['storefront', 'wallet']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('name', 'LIKE', '%' . $request->search . '%')
                  ->orWhere('email', 'LIKE', '%' . $request->search . '%')
                  ->orWhereHas('storefront', function ($sq) use ($request) {
                      $sq->where('name', 'LIKE', '%' . $request->search . '%');
                  });
            });
        }

        $sellers = $query->withCount(['products', 'sellerOrders'])
                        ->latest()
                        ->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => $sellers
        ]);
    }

    /**
     * Aggregated metrics for sellers ecosystem dashboard.
     */
    public function statistics(): JsonResponse
    {
        $statusCounts = User::sellers()
            ->selectRaw("
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
                COUNT(CASE WHEN status = 'disabled' THEN 1 END) as disabled,
                COUNT(CASE WHEN status = 'blocked' THEN 1 END) as blocked,
                COUNT(*) as total
            ")
            ->first();

        return response()->json([
            'status' => true,
            'data'   => [
                'status_counts' => $statusCounts,
            ]
        ]);
    }

    /**
     * View detailed profile of a seller including orders count & gross values.
     */
    public function show($id): JsonResponse
    {
        $seller = User::sellers()
            ->with(['storefront', 'wallet'])
            ->find($id);

        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        // Orders summary using Eloquent Builder
        $ordersQuery = $seller->sellerOrders();
        $completedOrdersQuery = $seller->sellerOrders()->where('order_status', 'completed');

        $orderMetrics = [
            'total_orders_count'     => $ordersQuery->count(),
            'total_orders_value'     => (float) ($ordersQuery->sum('total_amount') ?? 0),
            'completed_orders_count' => $completedOrdersQuery->count(),
            'completed_orders_value' => (float) ($completedOrdersQuery->sum('total_amount') ?? 0),
        ];

        // Refunds summary using Eloquent Builder
        $refundsQuery = $seller->sellerRefunds();

        $refundMetrics = [
            'total_refunds_count' => $refundsQuery->count(),
            'total_refunds_value' => (float) ($refundsQuery->sum('refund_amount') ?? 0),
        ];

        return response()->json([
            'status' => true,
            'data'   => [
                'seller'  => $seller,
                'metrics' => [
                    'orders'  => $orderMetrics,
                    'refunds' => $refundMetrics,
                ],
            ],
        ]);
    }

    /**
     * View seller's products list.
     */
    public function products(Request $request, $id): JsonResponse
    {
        $seller = User::sellers()->find($id);
        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        $products = Product::where('seller_id', $seller->id)
            ->latest()
            ->paginate($request->get('per_page', 15));

        return response()->json(['status' => true, 'data' => $products]);
    }

    /**
     * View seller's orders list.
     */
    public function orders(Request $request, $id): JsonResponse
    {
        $seller = User::sellers()->find($id);
        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        $orders = Order::where('seller_id', $seller->id)
            ->latest()->with('user')
            ->paginate($request->get('per_page', 15));

        return response()->json(['status' => true, 'data' => $orders]);
    }

    /**
     * View seller's order refunds.
     */
    public function refunds(Request $request, $id): JsonResponse
    {
        $seller = User::sellers()->find($id);
        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        $refunds = OrderRefund::where('seller_id', $seller->id)
            ->latest()
            ->paginate($request->get('per_page', 15));

        return response()->json(['status' => true, 'data' => $refunds]);
    }

   /**
     * View seller's order settlements history.
     */
    public function settlements(Request $request, $id): JsonResponse
    {
        $seller = User::sellers()->find($id);
        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        $query = OrderSettlement::where('seller_id', $seller->id);

        // Calculate aggregated metrics using Model Eloquent methods
        $summary = [
            'total_gross_amount'   => (float) (clone $query)->sum('gross_amount'),
            'total_platform_fee'   => (float) (clone $query)->sum('platform_fee'),
            'total_net_settlement' => (float) (clone $query)->sum('net_settlement'),
        ];

        // Retrieve paginated records
        $settlements = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status'  => true,
            'summary' => $summary,
            'data'    => $settlements,
        ]);
    }

    /**
     * Toggle status (Enable / Disable / Block / Active) with Audit Log.
     */
    public function updateStatus(Request $request, $id): JsonResponse
    {
        $seller = User::sellers()->find($id);
        if (!$seller) {
            return response()->json(['status' => false, 'message' => 'Seller not found.'], 404);
        }

        $validated = $request->validate([
            'status' => 'required|in:active,disabled,blocked,pending',
            'reason' => 'nullable|string|max:255',
        ]);

        $oldStatus = $seller->status;
        $seller->update(['status' => $validated['status']]);

        // If storefront exists, synchronize storefront availability status
        if ($seller->storefront) {
            $sfStatus = $validated['status'] === 'active' ? 'active' : 'suspended';
            $seller->storefront->update(['status' => $sfStatus]);
        }

        // Audit Log
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_seller_status',
            'description' => "Updated seller status (#{$seller->id} - {$seller->name}) from {$oldStatus} to {$validated['status']}. Reason: " . ($validated['reason'] ?? 'N/A'),
            'old_values'  => ['status' => $oldStatus],
            'new_values'  => ['status' => $validated['status']],
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => "Seller account status changed to {$validated['status']} successfully.",
            'data'    => $seller
        ]);
    }
}