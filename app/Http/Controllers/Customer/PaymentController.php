<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use App\Models\Order;
use App\Models\OrderTransaction;
use App\Models\PaymentGateway;
use App\Notifications\OrderSuccessfulNotification;

class PaymentController extends Controller
{
    /**
     * Verify Paystack transaction callback/redirect endpoint with fintech-grade safety.
     */
    public function verifyPaystackPayment(Request $request, $id)
    {
        // 1. Extract and sanitize reference from query parameters or request body
        $reference = $request->query('reference') ?? $request->input('reference');

        if (!$reference) {
            return response()->json([
                'status' => false,
                'message' => 'Transaction reference not provided.'
            ], 400);
        }

        // 2. Retrieve active Paystack gateway configuration
        $gateway = PaymentGateway::where('slug', 'paystack')->where('is_active', 1)->first();
        $secretKey = $gateway->secret_key ?? config('services.paystack.secret_key');

        if (!$secretKey) {
            Log::error('Paystack configuration error: Secret key missing.');
            return response()->json([
                'status' => false,
                'message' => 'Payment gateway configuration error.'
            ], 500);
        }

        // 3. Verify transaction securely with Paystack API using the transaction reference
        try {
            $response = Http::withToken($secretKey)
                ->timeout(30)
                ->get(config('services.paystack.payment_url') . "/transaction/verify/" . rawurlencode($reference));

            if (!$response->successful() || !$response->json('status')) {
                Log::warning('Paystack API verification failed response', ['response' => $response->body(), 'reference' => $reference]);
                return response()->json([
                    'status' => false,
                    'message' => 'Unable to verify transaction with payment gateway.'
                ], 400);
            }

            $paymentData = $response->json('data');

            if (($paymentData['status'] ?? null) !== 'success') {
                return response()->json([
                    'status' => false,
                    'message' => 'Transaction was not successful on the gateway.'
                ], 400);
            }

        } catch (\Exception $e) {
            Log::error('Paystack API connection exception: ' . $e->getMessage(), ['reference' => $reference]);
            return response()->json([
                'status' => false,
                'message' => 'Payment gateway connection error. Please try again.'
            ], 500);
        }

        // 4. Wrap database operations inside a strict transaction with row-locking for idempotency
        try {
            return DB::transaction(function () use ($id, $reference, $paymentData, $gateway) {
                // Lock the order row to prevent race conditions between webhooks and frontend redirects
                $order = Order::where('order_no', $id)->lockForUpdate()->first();

                if (!$order) {
                    return response()->json([
                        'status' => false,
                        'message' => 'Order reference not found.'
                    ], 404);
                }

                // Fintech Rule: Ensure the Paystack transaction reference explicitly matches the internal order number
                $gatewayReference = $paymentData['reference'] ?? $reference;
                if ($gatewayReference !== $order->transaction_ref) {
                    Log::error('Security alert: Paystack transaction reference does not match order number', [
                        'order_no' => $order->order_no,
                        'gateway_reference' => $gatewayReference
                    ]);

                    return response()->json([
                        'status' => false,
                        'message' => 'Transaction reference mismatch security check failed.'
                    ], 400);
                }

                // Idempotency check: If already paid, return early success safely
                if ($order->payment_status === 'paid') {
                    return response()->json([
                        'status' => true,
                        'message' => 'Payment already verified successfully.',
                        'data' => $order->only(['id', 'order_no', 'grand_total',  'payment_status', 'order_status', 'transaction_ref'])
                    ], 200);
                }

                // Strict Amount and Currency Verification (Paystack amounts are in kobo)
                $expectedAmountInKobo = (int) round($order->grand_total * 100);
                $gatewayAmount = (int) ($paymentData['amount'] ?? 0);
                $gatewayCurrency = $paymentData['currency'] ?? 'NGN';

                if ($gatewayAmount < $expectedAmountInKobo) {
                    Log::error('Payment amount mismatch detected', [
                        'order_no' => $id,
                        'expected' => $expectedAmountInKobo,
                        'received' => $gatewayAmount,
                    ]);

                    $order->update(['payment_status' => 'failed']);

                    return response()->json([
                        'status' => false,
                        'message' => 'Payment amount mismatch detected. Security alert logged.'
                    ], 400);
                }

                // Update Order Status
                $order->update([
                    'payment_status' => 'paid',
                    'order_status' => 'processing',
                ]);

                // Record Immutable Financial Transaction Log
                $transaction = new OrderTransaction();
                $transaction->order_id = $order->id;
                $transaction->user_id = $order->user_id;
                $transaction->transaction_ref = $gatewayReference;
                $transaction->amount = ($paymentData['requested_amount'] ?? $gatewayAmount) / 100; 
                $transaction->fee = ($paymentData['fees'] ?? 0) / 100; 
                $transaction->total_amount = $gatewayAmount / 100; 
                $transaction->currency = $gatewayCurrency;
                $transaction->status = $paymentData['status'];
                $transaction->payment_gateway = $gateway->name ?? 'Paystack';
                $transaction->gateway_response = $paymentData['gateway_response'] ?? null;
                $transaction->save();

                // Dispatch Email Notification safely
                try {
                    if ($order->user) {
                        $order->user->notify(new OrderSuccessfulNotification($order));
                    }
                } catch (\Exception $mailEx) {
                    Log::error('Failed to send order success email: ' . $mailEx->getMessage(), ['order_id' => $order->id]);
                }

                return response()->json([
                    'status' => true,
                    'message' => 'Payment verified successfully and order updated.',
                    'data' => $order->only(['id', 'order_no', 'grand_total',  'payment_status', 'order_status', 'transaction_ref']),
                    //'paymentData' => $paymentData
                ], 200);
            });

        } catch (\Exception $e) {
            Log::error('Order verification database transaction failed: ' . $e->getMessage(), ['order_no' => $id]);
            return response()->json([
                'status' => false,
                'message' => 'An error occurred while processing your order payment.'
            ], 500);
        }
    }
}