<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\OrderTransaction;
use App\Models\OrderStatusHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class TransactionController extends Controller
{
    /**
     * View all transactions with optional filters.
    */
    public function index(Request $request): JsonResponse
    {
        $query = OrderTransaction::with(['user:id,name,email', 'order:id,order_no']);

        if ($request->filled('transaction_ref')) {
            $query->where('transaction_ref', 'like', '%' . $request->transaction_ref . '%');
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('payment_gateway')) {
            $query->where('payment_gateway', $request->payment_gateway);
        }

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        $transactions = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => $transactions,
        ]);
    }

    /**
     * View single transaction details.
     */
    public function show(int $id): JsonResponse
    {
        $transaction = OrderTransaction::with([
            'user:id,name,email,phone',
            'order.items',
        ])->findOrFail($id);

        return response()->json([
            'status' => true,
            'data'   => $transaction,
        ]);
    }

    /**
     * Update transaction status and log audit trail.
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'status'  => 'required|in:pending,successful,failed,refunded',
            'comment' => 'nullable|string',
        ]);

        $transaction = OrderTransaction::with('order')->findOrFail($id);
        $oldStatus = $transaction->status;

        DB::transaction(function () use ($transaction, $request, $oldStatus) {
            $transaction->update(['status' => $request->status]);

            // Sync parent order payment status if transaction marked successful or refunded
            if ($transaction->order) {
                if ($request->status === 'successful') {
                    $transaction->order->update(['payment_status' => 'paid']);
                } elseif ($request->status === 'refunded') {
                    $transaction->order->update(['payment_status' => 'refunded']);
                }

                // Append audit log entry
                OrderStatusHistory::create([
                    'order_id'           => $transaction->order_id,
                    'status'             => $transaction->order->order_status,
                    'comment'            => $request->comment ?? "Transaction status for ref '{$transaction->transaction_ref}' updated from '{$oldStatus}' to '{$request->status}'",
                    'changed_by_user_id' => auth()->id(),
                ]);
            }
        });

        return response()->json([
            'status'  => true,
            'message' => 'Transaction status updated successfully.',
            'data'    => $transaction,
        ]);
    }

    /**
     * View status summary widgets.
     */
    public function getDashboardWidgets(): JsonResponse
    {
        $widgets = [
            'total_transactions' => OrderTransaction::count(),
            'total_volume'       => OrderTransaction::where('status', 'successful')->sum('amount'),
            'successful'         => OrderTransaction::where('status', 'successful')->count(),
            'pending'            => OrderTransaction::where('status', 'pending')->count(),
            'failed'             => OrderTransaction::where('status', 'failed')->count(),
            'refunded'           => OrderTransaction::where('status', 'refunded')->count(),
        ];

        return response()->json([
            'status' => true,
            'data'   => $widgets,
        ]);
    }

    /**
     * Chart metrics breakdown across periods.
     */
    public function getTransactionChart(Request $request): JsonResponse
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
     * Helper calculation window.
     */
    private function getMetricsForRange(Carbon $start, Carbon $end, string $label): array
    {
        $query = OrderTransaction::whereBetween('created_at', [$start, $end]);

        return [
            'label'        => $label,
            'total_volume' => round((clone $query)->where('status', 'successful')->sum('amount'), 2),
            'successful'   => (clone $query)->where('status', 'successful')->count(),
            'pending'      => (clone $query)->where('status', 'pending')->count(),
            'failed'       => (clone $query)->where('status', 'failed')->count(),
            'refunded'     => (clone $query)->where('status', 'refunded')->count(),
        ];
    }

     /**
     * Get all successful transactions with seller/buyer details and aggregate tax metrics.
     */
    public function tax(Request $request): JsonResponse
    {
        // 1. Base query for successful transactions with relationships
        $query = OrderTransaction::with([
            'user:id,name,email,phone',
            'seller:id,name,email,phone',
            'order:id,order_no,payment_status',
        ])->where('status', 'successful');

        // Optional Filters
        if ($request->filled('transaction_ref')) {
            $query->where('transaction_ref', $request->transaction_ref);
        }

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('seller_id')) {
            $query->where('seller_id', $request->seller_id);
        }

        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }

        // 2. Compute aggregate metrics for successful transactions matching filters
        $metricsQuery = (clone $query);
        
        $widgets = [
            'total_successful_transaction_count' => $metricsQuery->count(),
            'total_tax_collected_value'           => round((float) $metricsQuery->sum('tax'), 2),
            'total_transaction_amount_value'      => round((float) $metricsQuery->sum('amount'), 2),
        ];

        // 3. Paginate transaction list
        $transactions = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status'  => true,
            'widgets' => $widgets,
            'data'    => $transactions,
        ]);
    }
}