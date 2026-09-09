<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderSettlement;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Carbon\Carbon;

class SalesReportController extends Controller
{
    /**
     * Get broad sales, settlement metrics, top products, top sellers, and monthly chart data
     * with optional filtering by year, month, or date range (date_from & date_to).
     */
    public function index(Request $request): JsonResponse
    {
        $year     = $request->input('year');
        $month    = $request->input('month');
        $dateFrom = $request->input('date_from');
        $dateTo   = $request->input('date_to');

        // Helper closure to apply consistent date filters across queries
        $applyDateFilter = function ($query) use ($year, $month, $dateFrom, $dateTo) {
            if ($dateFrom && $dateTo) {
                $query->whereBetween('created_at', [
                    Carbon::parse($dateFrom)->startOfDay(),
                    Carbon::parse($dateTo)->endOfDay()
                ]);
            } elseif ($dateFrom) {
                $query->where('created_at', '>=', Carbon::parse($dateFrom)->startOfDay());
            } elseif ($dateTo) {
                $query->where('created_at', '<=', Carbon::parse($dateTo)->endOfDay());
            } else {
                if ($year) {
                    $query->whereYear('created_at', (int) $year);
                }
                if ($month) {
                    $query->whereMonth('created_at', (int) $month);
                }
            }
        };

        // Fetch filtered settled order IDs
        $settledOrderQuery = OrderSettlement::query();
        $applyDateFilter($settledOrderQuery);
        $settledOrderIds = $settledOrderQuery->pluck('order_id');

        // 1. Overall Financial Summary from OrderSettlement
        $summaryQuery = OrderSettlement::query();
        $applyDateFilter($summaryQuery);

        $totalSales          = (float) $summaryQuery->sum('gross_amount');
        $totalCharge         = (float) $summaryQuery->sum('platform_fee');
        $totalNetSettlement = (float) $summaryQuery->sum('net_settlement');

        // Total Tax from Orders matching settled orders
        $totalTax = (float) Order::whereIn('id', $settledOrderIds)->sum('tax_amount');

        // 2. Top Product by Sales Count (Highest total quantity sold)
        $topByCount = OrderItem::whereIn('order_id', $settledOrderIds)
            ->select('product_id')
            ->selectRaw('SUM(quantity) as total_units_sold')
            ->groupBy('product_id')
            ->orderByDesc('total_units_sold')
            ->with('product:id,name,sku,unit_price,thumbnail')
            ->first();

        // 3. Top Product by Sales Value (Highest total revenue generated)
        $topByValue = OrderItem::whereIn('order_id', $settledOrderIds)
            ->select('product_id')
            ->selectRaw('SUM(unit_price * quantity) as total_revenue')
            ->groupBy('product_id')
            ->orderByDesc('total_revenue')
            ->with('product:id,name,sku,unit_price,thumbnail')
            ->first();

        // 4. Top 5 Selling Products (Combined quantity & revenue)
        $top5SellingProducts = OrderItem::whereIn('order_id', $settledOrderIds)
            ->select('product_id')
            ->selectRaw('SUM(quantity) as total_units_sold, SUM(unit_price * quantity) as total_revenue')
            ->groupBy('product_id')
            ->orderByDesc('total_units_sold')
            ->limit(5)
            ->with('product:id,name,sku,unit_price,thumbnail')
            ->get();

        // 5. Top 5 Sellers by Order Count
        $topSellersByCountQuery = OrderSettlement::query();
        $applyDateFilter($topSellersByCountQuery);
        $topSellersByCountData = $topSellersByCountQuery->select('seller_id')
            ->selectRaw('COUNT(id) as total_orders, SUM(gross_amount) as total_sold_value')
            ->groupBy('seller_id')
            ->orderByDesc('total_orders')
            ->limit(5)
            ->get();

        $sellerIdsCount  = $topSellersByCountData->pluck('seller_id');
        $sellersForCount = User::whereIn('id', $sellerIdsCount)->get()->keyBy('id');

        $topSellersByCount = $topSellersByCountData->map(function ($item) use ($sellersForCount) {
            $item->seller = $sellersForCount->get($item->seller_id);
            return $item;
        });

        // 6. Top 5 Sellers by Sales Value
        $topSellersByValueQuery = OrderSettlement::query();
        $applyDateFilter($topSellersByValueQuery);
        $topSellersByValueData = $topSellersByValueQuery->select('seller_id')
            ->selectRaw('COUNT(id) as total_orders, SUM(gross_amount) as total_sold_value')
            ->groupBy('seller_id')
            ->orderByDesc('total_sold_value')
            ->limit(5)
            ->get();

        $sellerIdsValue  = $topSellersByValueData->pluck('seller_id');
        $sellersForValue = User::whereIn('id', $sellerIdsValue)->get()->keyBy('id');

        $topSellersByValue = $topSellersByValueData->map(function ($item) use ($sellersForValue) {
            $item->seller = $sellersForValue->get($item->seller_id);
            return $item;
        });

        // 7. Monthly Settlement Chart (January to December)
        // If a explicit year isn't passed, fall back to current year for the chart layout
        $targetYear = $year ? (int) $year : Carbon::now()->year;

        $months = [
            1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April',
            5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August',
            9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December'
        ];

        $chartData = collect($months)->map(function ($monthName, $monthNumber) use ($targetYear, $dateFrom, $dateTo) {
            $monthlySettlement = OrderSettlement::whereYear('created_at', $targetYear)
                ->whereMonth('created_at', $monthNumber);

            if ($dateFrom && $dateTo) {
                $monthlySettlement->whereBetween('created_at', [
                    Carbon::parse($dateFrom)->startOfDay(),
                    Carbon::parse($dateTo)->endOfDay()
                ]);
            }

            return [
                'month'        => $monthName,
                //'month_num'    => $monthNumber,
                'total_sales'  => round((float) $monthlySettlement->sum('gross_amount'), 2),
                'total_charge' => round((float) $monthlySettlement->sum('platform_fee'), 2),
                'net_earnings' => round((float) $monthlySettlement->sum('net_settlement'), 2),
            ];
        })->values();

        return response()->json([
            'status' => true,
            'data'   => [
                'filters' => [
                    'year'      => $year ? (int) $year : null,
                    'month'     => $month ? (int) $month : null,
                    'date_from' => $dateFrom,
                    'date_to'   => $dateTo,
                ],
                'summary' => [
                    'total_sales'          => round($totalSales, 2),
                    'total_tax'            => round($totalTax, 2),
                    'total_charge'         => round($totalCharge, 2),
                    'total_net_settlement' => round($totalNetSettlement, 2),
                ],
                'top_product_by_count'   => $topByCount,
                'top_product_by_value'   => $topByValue,
                'top_5_selling_products' => $top5SellingProducts,
                'top_sellers' => [
                    'by_order_count' => $topSellersByCount,
                    'by_sales_value' => $topSellersByValue,
                ],
                'monthly_chart'          => $chartData,
            ]
        ]);
    }
}