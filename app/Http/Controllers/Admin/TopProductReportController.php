<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\OrderItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TopProductReportController extends Controller
{
    /**
     * Get top 20 products report by sales count and value with overall metrics.
     */
    public function index(Request $request): JsonResponse
    {
        // 1. Base Eloquent Query with Order Filters
        $baseQuery = OrderItem::query()
            ->whereHas('order', function ($query) use ($request) {
                $query->whereIn('order_status', ['completed', 'delivered', 'paid']);

                if ($request->filled('year')) {
                    $query->whereYear('created_at', $request->input('year'));
                }
                if ($request->filled('month')) {
                    $query->whereMonth('created_at', $request->input('month'));
                }
                if ($request->filled('date_from')) {
                    $query->whereDate('created_at', '>=', $request->input('date_from'));
                }
                if ($request->filled('date_to')) {
                    $query->whereDate('created_at', '<=', $request->input('date_to'));
                }
            });

        // 2. Calculated Metrics using Eloquent Model Aggregations
        $totalVolume = (int) (clone $baseQuery)->sum('quantity');
        
        // Sum total line item revenue (quantity * unit_price)
        $totalValue = (float) (clone $baseQuery)->get()->sum(function ($item) {
            return $item->quantity * $item->unit_price;
        });

        $totalUniqueProducts = (int) (clone $baseQuery)->distinct('product_id')->count('product_id');

        $metrics = [
            'total_volume_sold'          => $totalVolume,
            'total_value_sold'           => $totalValue,
            'total_unique_products_sold' => $totalUniqueProducts,
        ];

        // 3. Retrieve Grouped Items via Eloquent Collections
        $groupedItems = (clone $baseQuery)
            ->with(['product:id,name,sku,unit_price,thumbnail'])
            ->get()
            ->groupBy('product_id')
            ->map(function ($items, $productId) {
                $product = $items->first()->product;
                $unitsSold = $items->sum('quantity');
                $revenue = $items->sum(function ($item) {
                    return $item->quantity * $item->unit_price;
                });

                return [
                    'product_id'       => (int) $productId,
                    'total_units_sold' => (int) $unitsSold,
                    'total_revenue'    => (float) $revenue,
                    'product'          => $product,
                ];
            });

        // 4. Sort Collections for Top 20 by Volume & Value
        $topByCount = $groupedItems
           // ->sortByDesc('total_units_sold')
            ->take(20)
            ->values();

        $topByValue = $groupedItems
            ->sortByDesc('total_revenue')
            ->take(20)
            ->values();

        return response()->json([
            'status'  => true,
            'metrics' => $metrics,
            'data'    => [
                'top_by_count' => $topByCount,
                'top_by_value' => $topByValue,
            ],
        ]);
    }
}