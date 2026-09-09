<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use App\Models\User;
use App\Models\Shipping;
use App\Models\Cart;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Get aggregated metrics and analytics for the admin dashboard.
     */
    public function dashboard(Request $request)
    {
        // 1. Metric Stat Cards
        $totalSales = Order::where('order_status', 'delivered')->sum('total_amount');
        $totalOrders = Order::count();
        $totalCustomers = User::where('type', 'customer')->count();
        
        $refundRequests = Order::where('order_status', 'refunded')->count();
        $stockProducts = Product::count();
        $abandonedCarts = Cart::where('status', 'is_abandoned')->count();
        $paymentFailures = Order::where('payment_status', 'failed')->count();

        // 2. Order Status Breakdown (Pie Chart Data)
        $orderStatusBreakdown = Order::select('order_status', DB::raw('count(*) as count'))
            ->groupBy('order_status')
            ->pluck('count', 'order_status');

        // 3. Monthly Accommodation/Sales Revenue (Bar Chart Data for Current Year)
        $monthlyRevenue = Order::select(
                DB::raw('MONTH(created_at) as month'),
                DB::raw('SUM(total_amount) as total')
            )
            ->whereYear('created_at', date('Y'))
            ->where('order_status', 'delivered')
            ->groupBy('month')
            ->orderBy('month')
            ->pluck('total', 'month');

        // Format revenue to ensure all 12 months are represented
        $formattedMonthlyRevenue = [];
        for ($m = 1; $m <= 12; $m++) {
            $formattedMonthlyRevenue[] = [
                'month' => date('M', mktime(0, 0, 0, $m, 1)),
                'revenue' => (float) ($monthlyRevenue->get($m) ?? 0),
            ];
        }

        // 4. Top Countries By Sales
        $topCountries = Order::select('shipping_country', DB::raw('SUM(total_amount) as total_sales'))
            ->where('order_status', 'delivered')
            ->groupBy('shipping_country')
            ->orderByDesc('total_sales')
            ->limit(4)
            ->get();


        // 4B. Top State By Sales
        $topStates = Order::select('shipping_state', DB::raw('SUM(total_amount) as total_sales'))
            ->where('order_status', 'delivered')
            ->groupBy('shipping_state')
            ->orderByDesc('total_sales')
            ->limit(4)
            ->get();

        // 5. Order Fulfillment Status (Progress Bars)
        $fulfillmentStatus = [
            'shipped' => Order::where('order_status', 'shipped')->count(),
            'delivered' => Order::where('order_status', 'delivered')->count(),
            'pending' => Order::where('order_status', 'pending')->count(),
            'stuck' => Order::where('order_status', 'stuck')->count(),
            'processing' => Order::where('order_status', 'processing')->count(),
            'cancelled' => Order::where('order_status', 'cancelled')->count(),
        ];

        // 6. Recent Orders Table
        $recentOrders = Order::with('user:id,name,email')
            ->latest()
            ->limit(5)
            ->get(['id', 'user_id', 'total_amount','order_no', 'order_status', 'created_at']);

        // 7. Low Stock / Stock Update Table
        $stockUpdates = Product::with('category:id,name', 'seller:id,name')
            ->latest()
            ->limit(4)
            ->get(['id', 'name', 'category_id', 'seller_id', 'status']);

        return response()->json([
            'status' => true,
            'message' => 'Dashboard analytics loaded successfully.',
            'data' => [
                'metrics' => [
                    'total_sales' => (float) $totalSales,
                    'total_orders' => $totalOrders,
                    'total_customers' => $totalCustomers,
                    'refund_requests' => $refundRequests,
                    'stock_products' => $stockProducts,
                    'abandoned_carts' => $abandonedCarts,
                    'payment_failures' => $paymentFailures,
                ],
                'order_status_chart' => $orderStatusBreakdown,
                'monthly_revenue_chart' => $formattedMonthlyRevenue,
                'top_countries' => $topCountries,
                'top_states' => $topStates,
                'fulfillment_status' => $fulfillmentStatus,
                'recent_orders' => $recentOrders,
                'stock_updates' => $stockUpdates,
            ],
        ]);
    }
}