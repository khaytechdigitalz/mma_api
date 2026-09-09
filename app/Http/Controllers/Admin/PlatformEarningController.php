<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\OrderTransaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class PlatformEarningController extends Controller
{
    /**
     * Get platform earnings metrics, charts, and filtered transactions.
     */
    public function index(Request $request): JsonResponse
    {
        // Base query strictly for successful transactions
        $baseQuery = OrderTransaction::where('status', 'successful');

        // Apply dynamic filters to main listing & widget totals
        $filteredQuery = (clone $baseQuery);
        $this->applyFilters($filteredQuery, $request);

        // 1. Dynamic Widget Counts (Reflects Active Filters)
        $widgets = [
            'total_platform_earnings' => round((float) (clone $filteredQuery)->sum(DB::raw('fee + tax')), 2),
            'total_fees_collected'    => round((float) (clone $filteredQuery)->sum('fee'), 2),
            'total_taxes_collected'   => round((float) (clone $filteredQuery)->sum('tax'), 2),
            'total_gross_volume'      => round((float) (clone $filteredQuery)->sum('total_amount'), 2),
            'total_transactions'      => (clone $filteredQuery)->count(),
        ];

        // 2. Transaction Charts (Today, Last 7 Days, This Month, This Year)
        $charts = [
            'today'        => $this->getTodayEarnings($baseQuery),
            'last_7_days'  => $this->getLast7DaysEarnings($baseQuery),
            'this_month'   => $this->getThisMonthEarnings($baseQuery),
            'this_year'    => $this->getThisYearEarnings($baseQuery),
        ];

        // 3. Filtered Transaction Table List
        $transactions = $filteredQuery->with([
            'user:id,name,email,phone',
            'seller:id,name,email,phone',
            'order:id,order_no,payment_status'
        ])
        ->latest()
        ->paginate($request->get('per_page', 15));

        return response()->json([
            'status'  => true,
            'widgets' => $widgets,
            'charts'  => $charts,
            'data'    => $transactions,
        ]);
    }

    /**
     * Apply request query parameters to filter transactions.
     */
    private function applyFilters($query, Request $request): void
    {
        if ($request->filled('transaction_ref')) {
            $query->where('transaction_ref', 'LIKE', '%' . $request->transaction_ref . '%');
        }

        if ($request->filled('seller_id')) {
            $query->where('seller_id', $request->seller_id);
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
    }

    /**
     * Hourly breakdown for Today
     */
    private function getTodayEarnings($query): array
    {
        return (clone $query)
            ->whereDate('created_at', Carbon::today())
            ->selectRaw('HOUR(created_at) as label, SUM(fee + tax) as total_earning')
            ->groupBy('label')
            ->orderBy('label', 'ASC')
            ->pluck('total_earning', 'label')
            ->toArray();
    }

    /**
     * Daily breakdown for Last 7 Days
     */
    private function getLast7DaysEarnings($query): array
    {
        return (clone $query)
            ->where('created_at', '>=', Carbon::now()->subDays(6)->startOfDay())
            ->selectRaw('DATE(created_at) as label, SUM(fee + tax) as total_earning')
            ->groupBy('label')
            ->orderBy('label', 'ASC')
            ->pluck('total_earning', 'label')
            ->toArray();
    }

    /**
     * Daily breakdown for This Month
     */
    private function getThisMonthEarnings($query): array
    {
        return (clone $query)
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->selectRaw('DATE(created_at) as label, SUM(fee + tax) as total_earning')
            ->groupBy('label')
            ->orderBy('label', 'ASC')
            ->pluck('total_earning', 'label')
            ->toArray();
    }

    /**
     * Monthly breakdown for This Year
     */
    private function getThisYearEarnings($query): array
    {
        return (clone $query)
            ->whereYear('created_at', Carbon::now()->year)
            ->selectRaw('MONTHNAME(created_at) as label, MONTH(created_at) as month_num, SUM(fee + tax) as total_earning')
            ->groupBy('label', 'month_num')
            ->orderBy('month_num', 'ASC')
            ->pluck('total_earning', 'label')
            ->toArray();
    }
}