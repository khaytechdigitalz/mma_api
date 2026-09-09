<?php

namespace App\Http\Controllers\Customer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\CartItem;
use App\Models\Cart;
use App\Models\Product;
use App\Models\UserAddress;
use App\Models\PaymentGateway;

class CheckoutController extends Controller
{
    /**
     * Get checkout summary (cart items, shipping options, user info, default address, and active payment gateways)
     */
    public function index(Request $request)
    {
        $user = $request->user();
        // Fetch the user's active cart
        $cart = Cart::where('user_id', $user->id)->first();

        if (!$cart) {
            return response()->json([
                'status' => false,
                'message' => 'Your cart is empty.',
            ], 400);
        }

        // Fetch cart items using the CartItem model with product relation
        $cartItems = CartItem::with('product:id,name,slug,unit_price,thumbnail')
            ->where('cart_id', $cart->id)
            ->get();

        if ($cartItems->isEmpty()) {
            return response()->json([
                'status' => false,
                'message' => 'Your cart is empty.',
            ], 400);
        }

        $subtotal = $cartItems->sum(function ($item) {
            return $item->unit_price * $item->quantity;
        });

        $shippingFee = 0.00; // Adjust logic as needed (e.g., based on location)
        $total = $subtotal + $shippingFee;

        // Update the Cart model's subtotal and grand_total
        $cart->update([
            'subtotal' => $subtotal,
            'grand_total' => $total,
        ]);

        // Fetch saved user addresses and identify the default one
        $addresses = UserAddress::where('user_id', $user->id)->get();
        $defaultAddress = $addresses->where('is_default', 1)->first() ?? $addresses->first();

        // Fetch active payment gateways (only id and name)
        $paymentGateways = PaymentGateway::where('is_active', 1)
            ->select('id', 'name')
            ->get();

        return response()->json([
            'status' => true,
            'data' => [
                'user' => [
                    'name' => $user->name,
                    'email' => $user->email,
                    'phone' => $user->phone ?? null,
                ],
                'cart_items' => $cartItems,
                'subtotal' => $subtotal,
                'shipping_fee' => $shippingFee,
                'total' => $total,
                'default_address' => $defaultAddress,
                'addresses' => $addresses,
                'payment_gateways' => $paymentGateways,
            ]
        ], 200);
    }

    /**
     * Store/Process the checkout order using the default address or a selected one
     */
    public function store(Request $request)
    {
       $validator = Validator::make($request->all(), [
            'address_id' => 'nullable|exists:user_addresses,id',
            'payment_gateway_id' => 'required|exists:payment_gateways,id',
            'phone' => 'required|string|max:20',
            'shipping_fee' => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        $gateway = null;

        // Verify that the selected payment gateway is active
        if ($request->payment_gateway_id == 0) {
            $gatewayName = 'in-store'; 
        } else {
            $gateway = PaymentGateway::where('id', $request->payment_gateway_id)
                ->where('is_active', 1)
                ->first();

            if (!$gateway) {
                return response()->json([
                    'status' => false,
                    'message' => 'Selected payment method is inactive or invalid.',
                ], 400);
            }
            $gatewayName = $gateway->slug;
        }
 
        // Fetch user address: use requested address_id if provided, otherwise default to the user's default address
        if ($request->filled('address_id')) {
            $userAddress = UserAddress::where('id', $request->address_id)
                ->where('user_id', $user->id)
                ->first();

            if (!$userAddress) {
                return response()->json([
                    'status' => false,
                    'message' => 'Selected address is invalid or does not belong to you.',
                ], 403);
            }
        } else {
            $userAddress = UserAddress::where('user_id', $user->id)
                ->where('is_default', 1)
                ->first() ?? UserAddress::where('user_id', $user->id)->first();

            if (!$userAddress) {
                return response()->json([
                    'status' => false,
                    'message' => 'No delivery address found. Please add an address before checkout.',
                ], 400);
            }
        }

        $cart = Cart::with('product')
            ->where('user_id', $user->id)
            ->latest()
            ->first();
        
        $cartItems = CartItem::with('product:id,name,slug,unit_price,thumbnail')
            ->where('cart_id', $cart->id)
            ->get();

        if ($cartItems->isEmpty()) {
            return response()->json([
                'status' => false,
                'message' => 'Cannot checkout with an empty cart.',
            ], 400);
        }

        DB::beginTransaction();

        try {
            $subtotal = $cartItems->sum(fn($item) => $item->unit_price * $item->quantity);
            $shippingFee = $request->input('shipping_fee', 0.00);
            $taxAmount = $subtotal * 0.05; // 5% tax
            $grandTotal = $subtotal + $shippingFee + $taxAmount;

            // Optional: update user phone if it wasn't set previously
            if (empty($user->phone)) {
                $user->phone = $request->phone;
                $user->save();
            }

            $orderNo = 'ORD-' . strtoupper(uniqid());
            $transactionRef = 'TRX-' . strtoupper(uniqid());

            // Create the main order record capturing customer info, address snapshot, and gateway info
            $order = Order::create([
                'user_id' => $user->id,
                'subtotal' => $subtotal,
                'shipping_fee' => $shippingFee,
                'tax_amount' => $taxAmount ?? 0.00,
                'total_amount' => $grandTotal,
                'customer_name' => $user->name,
                'email' => $user->email,
                'phone' => $request->phone,
                'shipping_address' => $userAddress->address,
                'shipping_city' => $userAddress->city,
                'shipping_state' => $userAddress->state,
                'shipping_zip' => $userAddress->zip,
                'shipping_country' => $userAddress->country,
                'payment_method' => $gatewayName,
                'payment_status' => 'pending',
                'order_status' => 'pending',
                'order_no' => $orderNo,
                'transaction_ref' => $transactionRef
            ]);

            // Create order details items from cart
            foreach ($cartItems as $cartItem) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $cartItem->product_id,
                    'quantity' => $cartItem->quantity,
                    'unit_price' => $cartItem->unit_price,
                    'total_price' => $cartItem->total_price,
                    'variation' => $cartItem->variation ?? null,
                ]);

                // Deduct stock quantity safely
                $product = Product::find($cartItem->product_id);
                if ($product && $product->current_stock >= $cartItem->quantity) {
                    $product->decrement('current_stock', $cartItem->quantity);
                }
            }

            // Clear the user's cart after successful order creation
            Cart::where('user_id', $user->id)->delete();

            $authorizationUrl = null;
            $shouldRedirect = false;

            // Check if gateway is Paystack using slug or if secret key is present
            if ($gateway && (strtolower($gatewayName) === 'paystack' || !empty($gateway->secret_key))) {
                $authorizationUrl = $this->initializePaystackPayment($gateway, $user, $grandTotal, $transactionRef, $orderNo, $order->id);
                if ($authorizationUrl) {
                    $shouldRedirect = true;
                }
            }

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Order placed successfully!',
                'data' => [
                    'order_id' => $order->id,
                    'order_ref' => $order->order_no,
                    'grand_total' => $grandTotal,
                    'redirect' => $shouldRedirect,
                    'authorization_url' => $authorizationUrl,
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => 'Checkout failed. Please try again. '. $e->getMessage(),
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Private helper function to initialize Paystack Standard transaction
     */
    private function initializePaystackPayment($gateway, $user, float $grandTotal,  string $transactionRef, string $orderNo, int $orderId): ?string
    {
        $secretKey = $gateway->secret_key ?? config('services.paystack.secret_key');

        if (!$secretKey) {
            return null;
        }

        // Paystack expects the amount in kobo (multiply by 100)
        $amountInKobo = (int) round($grandTotal * 100);

        $response = Http::withToken($secretKey)
            ->post(config('services.paystack.payment_url') . '/transaction/initialize', [
                'email' => $user->email,
                'amount' => $amountInKobo,
                'reference' => $transactionRef,
                'callback_url' => config('services.paystack.callback_url').'/'.rawurlencode($orderNo),
                'metadata' => [
                    'order_id' => $orderId,
                    'cancel_action' => config('services.paystack.callback_url').'/'.rawurlencode($orderNo),
                ]
            ]);

        if ($response->successful() && $response->json('status')) {
            return $response->json('data.authorization_url');
        }

        throw new \Exception('Failed to initialize Paystack payment: ' . ($response->json('message') ?? 'Unknown error'));
    }

}