<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CartController extends Controller
{
    /**
     * Resolve cart using Authenticated User ID or Frontend Guest Token Header.
     */
    private function resolveCart(Request $request)
    {
        $user = $request->user('sanctum') ?? $request->user();
        $guestToken = $request->header('X-Guest-Token');

        // 1. If user is logged in, find or bind their cart
        if ($user) {
            $cart = Cart::where('user_id', $user->id)->first();

            // If a guest token was active, check if there's a guest cart to merge
            if ($guestToken) {
                $guestCart = Cart::where('guest_token', $guestToken)
                    ->whereNull('user_id')
                    ->first();

                if ($guestCart) {
                    if (!$cart) {
                        // Just assign the guest cart to the user
                        $guestCart->update(['user_id' => $user->id, 'guest_token' => null]);
                        $cart = $guestCart;
                    } else {
                        // Merge guest cart items into the user's existing cart
                        foreach ($guestCart->items as $item) {
                            $existingItem = $cart->items()->where('product_id', $item->product_id)->first();
                            if ($existingItem) {
                                $newQty = $existingItem->quantity + $item->quantity;
                                $existingItem->update([
                                    'quantity' => $newQty,
                                    'total_price' => $existingItem->unit_price * $newQty
                                ]);
                                $item->delete(); // Remove the old guest item after merging
                            } else {
                                $item->update(['cart_id' => $cart->id]);
                            }
                        }
                        $guestCart->delete();
                    }
                }
            }

            // If user still has no cart, create one
            if (!$cart) {
                $cart = Cart::create(['user_id' => $user->id]);
            }

            return $cart;
        }

        // 2. Guest User Flow (Using X-Guest-Token header)
        if (!$guestToken) {
            // Fallback safety if header is missing
            return null;
        }

        $cart = Cart::where('guest_token', $guestToken)->whereNull('user_id')->first();

        if (!$cart) {
            $cart = Cart::create([
                'guest_token' => $guestToken,
                'user_id' => null,
            ]);
        }

        return $cart;
    }

    /**
     * 1. GET /api/cart
     */
    public function index(Request $request)
    {
        $cart = $this->resolveCart($request);

        if (!$cart || $cart->items->isEmpty()) {
            return response()->json([
                'status' => true,
                'message' => 'Cart is empty.',
                'data' => [
                    'cart_id' => $cart?->id,
                    'items' => [],
                    'subtotal' => 0,
                    'total_items' => 0
                ]
            ], 200);
        }

        $cart->load([
            'items.product:id,name,slug,unit_price,discount,thumbnail,current_stock'
        ]);

        $subtotal = 0;
        foreach ($cart->items as $item) {
            if (!$item->product) continue;
            $subtotal += $item->unit_price * $item->quantity;
        }

        return response()->json([
            'status' => true,
            'message' => 'Cart fetched successfully.',
            'data' => [
                'cart_id' => $cart->id,
                'items' => $cart->items,
                'subtotal' => round($subtotal, 2),
                'total_items' => $cart->items->sum('quantity')
            ]
        ], 200);
    }

    /**
     * 2. POST /api/cart/add
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $product = Product::find($request->product_id);
        $stock = $product->current_stock ?? 0;

        if ($stock < $request->quantity) {
            return response()->json([
                'status' => false,
                'message' => 'Requested quantity exceeds available stock.',
                'available_stock' => $stock
            ], 400);
        }

        $cart = $this->resolveCart($request);
        if (!$cart) {
            return response()->json([
                'status' => false,
                'message' => 'Unable to resolve cart. Missing guest token.'
            ], 400);
        }

        // Attach user_id if the user is logged in and it hasn't been set yet
        if ($request->user() && empty($cart->user_id)) {
            $cart->update(['user_id' => $request->user()->id]);
        }

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('product_id', $product->id)
            ->first();

        $unitPrice = $product->unit_price;

        if ($cartItem) {
            $newQuantity = $cartItem->quantity + $request->quantity;
            
            if ($stock < $newQuantity) {
                return response()->json([
                    'status' => false,
                    'message' => 'Total quantity in cart exceeds available stock.',
                    'available_stock' => $stock
                ], 400);
            }

            $cartItem->update([
                'quantity' => $newQuantity,
                'unit_price' => $unitPrice,
                'total_price' => $unitPrice * $newQuantity
            ]);
        } else {
            $cartItem = CartItem::create([
                'cart_id' => $cart->id,
                'product_id' => $product->id,
                'unit_price' => $unitPrice,
                'total_price' => $unitPrice * $request->quantity,
                'quantity' => $request->quantity,
            ]);
        }

        return response()->json([
            'status' => true,
            'message' => 'Product added to cart successfully.',
            'data' => $cartItem->load('product:id,name,slug,unit_price,thumbnail')
        ], 201);
    }

    /**
     * 3. PUT /api/cart/update/{id}
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $cartItem = CartItem::with('product')->find($id);

        if (!$cartItem) {
            return response()->json([
                'status' => false,
                'message' => 'Cart item not found.'
            ], 404);
        }

        $stock = $cartItem->product->current_stock ?? 0;

        if ($stock < $request->quantity) {
            return response()->json([
                'status' => false,
                'message' => 'Requested quantity exceeds available stock.',
                'available_stock' => $stock
            ], 400);
        }

        $cartItem->update([
            'quantity' => $request->quantity,
            'total_price' => $cartItem->unit_price * $request->quantity
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Cart updated successfully.',
            'data' => $cartItem->load('product:id,name,slug,unit_price,thumbnail')
        ], 200);
    }

    /**
     * 4. DELETE /api/cart/item/{id}
     */
    public function destroy($id)
    {
        $cartItem = CartItem::find($id);

        if (!$cartItem) {
            return response()->json([
                'status' => false,
                'message' => 'Cart item not found.'
            ], 404);
        }

        $cartItem->delete();

        return response()->json([
            'status' => true,
            'message' => 'Item removed from cart successfully.'
        ], 200);
    }

    /**
     * 5. DELETE /api/cart/clear
     */
    public function clear(Request $request)
    {
        $cart = $this->resolveCart($request);

        if ($cart) {
            $cart->items()->delete();
        }

        return response()->json([
            'status' => true,
            'message' => 'Cart cleared successfully.'
        ], 200);
    }
}