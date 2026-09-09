<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PaymentGateway;

class PaymentGatewayController extends Controller
{
    /**
     * Fetch all payment gateways (prefilled with Paystack, Flutterwave, etc.)
     */
    public function index()
    {
        $gateways = PaymentGateway::all();

        return response()->json([
            'status' => true,
            'data' => $gateways,
        ]);
    }

    /**
     * Store or update payment gateway configuration keys.
     */
    public function update(Request $request, $slug)
    {
        $request->validate([
            'public_key' => 'nullable|string',
            'secret_key' => 'nullable|string',
            'webhook_endpoint' => 'nullable|string',
        ]);

        $gateway = PaymentGateway::where('slug', $slug)->first();

        if (!$gateway) {
            return response()->json([
                'status' => false,
                'message' => 'Payment gateway not found.',
            ], 404);
        }

        $gateway->update([
            'public_key' => $request->input('public_key', $gateway->public_key),
            'secret_key' => $request->input('secret_key', $gateway->secret_key),
            'webhook_endpoint' => $request->input('webhook_endpoint', $gateway->webhook_endpoint),
        ]);

        return response()->json([
            'status' => true,
            'message' => "{$gateway->name} settings updated successfully.",
            'data' => $gateway,
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        // Validate that status is provided and is a boolean/integer (1 or 0)
        $request->validate([
            'status' => 'required|boolean',
        ]);

        // Find the gateway by its primary key ID
        $gateway = PaymentGateway::find($id);

        if (!$gateway) {
            return response()->json([
                'status' => false,
                'message' => 'Payment gateway not found.',
            ], 404);
        }

        // Set is_active to the incoming request status value
        $gateway->is_active = $request->status;
        $gateway->save();

        return response()->json([
            'status' => true,
            'message' => 'Payment gateway status updated successfully.',
            'data' => $gateway,
        ]);
    }   
}