<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    // List orders with pagination
    public function index(Request $request)
    {
        $customer = $request->user();
        
        $orders = $customer->orders()
            ->with(['items.product'])
            ->latest()
            ->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'message' => 'Orders fetched successfully.',
            'data' => $orders
        ]);
    }

    // View specific order details
    public function show(Request $request, $id)
    {
        $customer = $request->user();

        $order = $customer->orders()
            ->with(['items.product'])
            ->where('id', $id)
            ->first();

        if (!$order) {
            return response()->json([
                'status' => false,
                'message' => 'Order not found.'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Order details fetched successfully.',
            'data' => $order
        ]);
    }

    // Remark on a delivered order
    public function remark(Request $request, $id)
    {
        $request->validate([
            'customer_remark' => 'required|string|max:1000',
        ]);

        $customer = $request->user();

        $order = $customer->orders()
            ->where('id', $id)
            ->where('order_status', 'delivered')
            ->first();

        if (!$order) {
            return response()->json([
                'status' => false,
                'message' => 'Delivered order not found.'
            ], 404);
        }

        $order->update([
            'customer_remark' => $request->customer_remark
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Remark added successfully.',
            'data' => $order
        ]);
    }
}