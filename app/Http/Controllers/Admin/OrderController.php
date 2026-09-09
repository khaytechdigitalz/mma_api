<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class OrderController extends Controller
{
    /**
     * View all orders with optional search filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Order::with(['user:id,name,email', 'seller:id,name,email', 'items']);

        // Filter: Order Number
        if ($request->filled('order_no')) {
            $query->where('order_no', 'like', '%' . $request->order_no . '%');
        }

        // Filter: User ID
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter: Seller ID (Direct relationship or inside order items)
        if ($request->filled('seller_id')) {
            $sellerId = $request->seller_id;
            $query->where(function ($q) use ($sellerId) {
                $q->where('seller_id', $sellerId)
                ->orWhereHas('items', function ($itemQuery) use ($sellerId) {
                    $itemQuery->where('seller_id', $sellerId);
                });
            });
        }

        // Filter: Order Status
        if ($request->filled('order_status')) {
            $query->where('order_status', $request->order_status);
        }

        // Filter: Payment Status
        if ($request->filled('payment_status')) {
            $query->where('payment_status', $request->payment_status);
        }

        // Filter: Date From
        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        // Filter: Date To (Includes the full day up to 23:59:59)
        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        $orders = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => $orders,
        ]);
    }
    /**
     * View single order details with item breakdowns & status audit trail.
     */
    public function show(int $id): JsonResponse
    {
        $order = Order::with([
            'seller:id,name,email,phone,avatar',
            'user:id,name,email,phone,avatar',
            'items.product:id,name,sku,thumbnail',
            'statusHistories.changedBy:id,name',
        ])->findOrFail($id);

        return response()->json([
            'status' => true,
            'data'   => $order,
        ]);
    }

    /**
     * Update Overall Order Status and record audit log.
     */
    public function updateOrderStatus(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'order_status' => 'required|in:pending,processing,confirmed,shipped,delivered,cancelled,returned',
            'comment'      => 'nullable|string',
        ]);

        $order = Order::findOrFail($id);
        $oldStatus = $order->order_status;

        DB::transaction(function () use ($order, $request, $oldStatus) {
            $order->update(['order_status' => $request->order_status]);

            // Sync line item delivery statuses if applicable
            if (in_array($request->order_status, ['delivered', 'cancelled', 'shipped', 'processing'])) {
                $order->items()->update(['delivery_status' => $request->order_status]);
            }

            // Audit log entry
            OrderStatusHistory::create([
                'order_id'           => $order->id,
                'status'             => $request->order_status,
                'comment'            => $request->comment ?? "Overall order status updated from '{$oldStatus}' to '{$request->order_status}'",
                'changed_by_user_id' => auth()->id(),
            ]);
        });

        return response()->json([
            'status'  => true,
            'message' => 'Order status updated successfully.',
            'data'    => $order->fresh('statusHistories'),
        ]);
    }

    /**
     * Update Payment Status with mandatory audit log tracking.
     */
    public function updatePaymentStatus(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'payment_status'  => 'required|in:unpaid,paid,partially_paid,refunded',
            'transaction_ref' => 'nullable|string',
            'comment'         => 'nullable|string',
        ]);

        $order = Order::findOrFail($id);
        $oldPaymentStatus = $order->payment_status;

        DB::transaction(function () use ($order, $request, $oldPaymentStatus) {
            $order->update([
                'payment_status'  => $request->payment_status,
                'transaction_ref' => $request->transaction_ref ?? $order->transaction_ref,
            ]);

            // Audit log entry
            OrderStatusHistory::create([
                'order_id'           => $order->id,
                'status'             => $order->order_status,
                'comment'            => $request->comment ?? "Payment status updated from '{$oldPaymentStatus}' to '{$request->payment_status}'",
                'changed_by_user_id' => auth()->id(),
            ]);
        });

        return response()->json([
            'status'  => true,
            'message' => 'Payment status updated successfully.',
            'data'    => $order->fresh('statusHistories'),
        ]);
    }

    /**
     * Update delivery status for an individual Order Item and record audit log.
     */
    public function updateOrderItemStatus(Request $request, int $itemId): JsonResponse
    {
        $request->validate([
            'delivery_status' => 'required|in:pending,processing,shipped,delivered,cancelled',
            'comment'         => 'nullable|string',
        ]);

        $item = OrderItem::with('order')->findOrFail($itemId);
        $oldStatus = $item->delivery_status;

        DB::transaction(function () use ($item, $request, $oldStatus) {
            $item->update(['delivery_status' => $request->delivery_status]);

            // Audit log entry attached to the parent order
            OrderStatusHistory::create([
                'order_id'           => $item->order_id,
                'status'             => $item->order->order_status,
                'comment'            => $request->comment ?? "Item '{$item->product_name}' (SKU: {$item->sku}) status updated from '{$oldStatus}' to '{$request->delivery_status}'",
                'changed_by_user_id' => auth()->id(),
            ]);
        });

        return response()->json([
            'status'  => true,
            'message' => 'Order item status updated successfully.',
            'data'    => $item,
        ]);
    }

    /**
     * Dashboard Summary Metrics
     */
    public function getDashboardWidgets(): JsonResponse
    {
        $metrics = [
            'total_orders'    => Order::count(),
            'pending_payment' => Order::where('payment_status', 'unpaid')->count(),
            'processing'      => Order::where('order_status', 'processing')->count(),
            'shipped'         => Order::where('order_status', 'shipped')->count(),
            'delivered'       => Order::where('order_status', 'delivered')->count(),
            'cancelled'       => Order::where('order_status', 'cancelled')->count(),
            'returned'        => Order::where('order_status', 'returned')->count(),
            'failed'          => Order::where('payment_status', 'unpaid')->where('order_status', 'cancelled')->count(),
        ];

        return response()->json([
            'status' => true,
            'data'   => $metrics,
        ]);
    }

    /**
     * Order Analytics Chart Endpoint
     */
    public function getProfitMarginChart(Request $request): JsonResponse
    {
        $period = $request->get('period', '12_months');
        $chartData = [];

        switch ($period) {
            case '24_hours':
                for ($i = 23; $i >= 0; $i--) {
                    $hour = Carbon::now()->subHours($i);
                    $chartData[] = $this->getMetricsForRange(
                        $hour->copy()->startOfHour(),
                        $hour->copy()->endOfHour(),
                        $hour->format('H:00')
                    );
                }
                break;

            case '7_days':
                for ($i = 6; $i >= 0; $i--) {
                    $day = Carbon::now()->subDays($i);
                    $chartData[] = $this->getMetricsForRange(
                        $day->copy()->startOfDay(),
                        $day->copy()->endOfDay(),
                        $day->format('D')
                    );
                }
                break;

            case '30_days':
                for ($i = 29; $i >= 0; $i--) {
                    $day = Carbon::now()->subDays($i);
                    $chartData[] = $this->getMetricsForRange(
                        $day->copy()->startOfDay(),
                        $day->copy()->endOfDay(),
                        $day->format('M d')
                    );
                }
                break;

            case '12_months':
            default:
                for ($m = 1; $m <= 12; $m++) {
                    $start = Carbon::now()->year(2026)->month($m)->startOfMonth();
                    $end   = Carbon::now()->year(2026)->month($m)->endOfMonth();
                    $chartData[] = $this->getMetricsForRange($start, $end, $start->format('M'));
                }
                break;
        }

        return response()->json([
            'status' => true,
            'period' => $period,
            'data'   => $chartData,
        ]);
    }

    /**
     * Helper to compute earnings & profits per window.
     */
    private function getMetricsForRange(Carbon $start, Carbon $end, string $label): array
    {
        $orders = Order::whereBetween('created_at', [$start, $end])
            ->where('payment_status', 'paid')
            ->get();

        $earnings     = $orders->sum('total_amount');
        $totalProfits = $orders->sum('subtotal') * 0.70;

        return [
            'label'         => $label,
            'earnings'      => round($earnings, 2),
            'total_profits' => round($totalProfits, 2),
            'delivered'     => Order::whereBetween('created_at', [$start, $end])->where('order_status', 'delivered')->count(),
            'cancelled'     => Order::whereBetween('created_at', [$start, $end])->where('order_status', 'cancelled')->count(),
            'returned'      => Order::whereBetween('created_at', [$start, $end])->where('order_status', 'returned')->count(),
        ];
    }
}