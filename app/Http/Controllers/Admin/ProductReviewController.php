<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProductReview;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductReviewController extends Controller
{
    /**
     * Display a listing of product reviews with filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = ProductReview::with([
            'user:id,name,email',
            'seller:id,name,email',
            'product:id,name,sku,thumbnail'
        ]);

        // Filter by Rating (Exact or Range)
        if ($request->filled('rating')) {
            $query->where('rating', $request->rating);
        }

        // Filter by Product ID
        if ($request->filled('product_id')) {
            $query->where('product_id', $request->product_id);
        }

        // Filter by Seller ID
        if ($request->filled('seller_id')) {
            $query->where('seller_id', $request->seller_id);
        }

        // Filter by Date Range (created_at)
        if ($request->filled('start_date')) {
            $query->whereDate('created_at', '>=', $request->start_date);
        }

        if ($request->filled('end_date')) {
            $query->whereDate('created_at', '<=', $request->end_date);
        }

        // Search in comment or order_no
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('comment', 'like', "%{$search}%")
                  ->orWhere('order_no', 'like', "%{$search}%");
            });
        }

        // Sorting
        $sortBy = $request->input('sort_by', 'created_at');
        $sortOrder = $request->input('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $perPage = $request->input('per_page', 15);
        $reviews = $query->paginate($perPage);

        return response()->json([
            'status' => true,
            'message' => 'Product reviews retrieved successfully.',
            'data' => $reviews
        ], 200);
    }

    /**
     * Display a single product review.
     */
    public function show($id): JsonResponse
    {
        $review = ProductReview::with([
            'user:id,name,email',
            'seller:id,name,email',
            'product:id,name,sku,thumbnail'
        ])->find($id);

        if (!$review) {
            return response()->json([
                'status' => false,
                'message' => 'Product review not found.'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Product review retrieved successfully.',
            'data' => $review
        ], 200);
    }

    /**
     * Update rating and comment of a review.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $review = ProductReview::find($id);

        if (!$review) {
            return response()->json([
                'status' => false,
                'message' => 'Product review not found.'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'rating' => 'sometimes|required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:2000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error.',
                'errors' => $validator->errors()
            ], 422);
        }

        $review->update($validator->validated());

        return response()->json([
            'status' => true,
            'message' => 'Product review updated successfully.',
            'data' => $review->fresh(['user:id,name,email', 'product:id,name'])
        ], 200);
    }

    /**
     * Remove a product review from storage.
     */
    public function destroy($id): JsonResponse
    {
        $review = ProductReview::find($id);

        if (!$review) {
            return response()->json([
                'status' => false,
                'message' => 'Product review not found.'
            ], 404);
        }

        $review->delete();

        return response()->json([
            'status' => true,
            'message' => 'Product review deleted successfully.'
        ], 200);
    }
}