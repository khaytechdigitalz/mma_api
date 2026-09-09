<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $customer = $request->user();

        // Counts and Aggregates
        $totalOrders = $customer->orders()->count();
        $pendingOrders = $customer->orders()->where('order_status', 'pending')->count();
        $savedAddressesCount = $customer->addresses()->count();
        $totalSpent = $customer->orders()->where('payment_status', 'paid')->sum('total_amount');

        // Last 5 orders with their items
        $lastOrders = $customer->orders()
            ->with('items.product')
            ->latest()
            ->take(5)
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Dashboard data fetched successfully.',
            'data' => [
                'total_orders' => $totalOrders,
                'pending_orders' => $pendingOrders,
                'saved_addresses_count' => $savedAddressesCount,
                'total_spent' => (float) $totalSpent,
                'last_orders' => $lastOrders,
            ]
        ]);
    }
}