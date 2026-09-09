<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Models\Category;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\ProductReview;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class ProductController extends Controller
{
    /**
     * 1. GET /api/products
     * Paginated list of products with filters: category_id, brand_id, seller_id, 
     * min_price, max_price, search query, and general sorting.
     */
    public function index(Request $request)
    {
        $query = Product::with(['category:id,name', 'brand:id,name']);

        // Search query by product name
        if ($request->filled('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        // Filter by category
        if ($request->filled('category_id')) {
            $categoryIdOrSlug = $request->category_id;
            
            $query->where(function ($q) use ($categoryIdOrSlug) {
                $q->where('id', $categoryIdOrSlug)
                ->orWhere('slug', $categoryIdOrSlug);
            });
        }

        // Filter by brand
        if ($request->filled('brand_id')) {
            $query->where('brand_id', $request->brand_id);
        }

        // Filter by seller
        if ($request->filled('seller_id')) {
            $query->where('seller_id', $request->seller_id);
        }

        // Price range filters (min_price to max_price)
        if ($request->filled('min_price')) {
            $query->where('purchase_price', '>=', $request->min_price);
        }
        if ($request->filled('max_price')) {
            $query->where('purchase_price', '<=', $request->max_price);
        }

        // Pagination (default to 15 items per page)
        $perPage = $request->get('per_page', 15);
        $products = $query->latest()->paginate($perPage);

        return response()->json([
            'status' => true,
            'message' => 'Products fetched successfully.',
            'data' => $products
        ], 200);
    }

    public function show($slug)
    {
        $product = Product::with([
                'category:id,name', 
                'brand:id,name', 
                'reviews:id,product_id,user_id,rating,comment', 
                'reviews.user:id,name'
            ])
            ->where('slug', $slug)
            ->orWhere('id', $slug) 
            ->first();

        if (!$product) {
            return response()->json([
                'status' => false,
                'message' => 'Product not found.'
            ], 404);
        }

        // Fetch 5 random related products from the same category (excluding the current product)
        $relatedProducts = Product::where('category_id', $product->category_id)
            ->where('id', '!=', $product->id)
            ->inRandomOrder()
            ->limit(5)
            ->get(['id', 'name', 'slug', 'purchase_price', 'thumbnail']);

        // Calculate rating breakdown (1 to 5 stars)
        $rawCounts = ProductReview::where('product_id', $product->id)
            ->selectRaw('rating, count(*) as count')
            ->groupBy('rating')
            ->pluck('count', 'rating');

        $ratingCounts = [];
        for ($i = 1; $i <= 5; $i++) {
            $ratingCounts[$i] = $rawCounts->get($i, 0);
        }

        $totalReviews = $product->reviews->count();
        $averageRating = $totalReviews > 0 ? round($product->reviews->avg('rating'), 1) : 0;

        $ratingSummary = [
            'total_reviews' => $totalReviews,
            'average_rating' => $averageRating,
            'rating_counts' => $ratingCounts,
        ];

        return response()->json([
            'status' => true,
            'message' => 'Product details fetched successfully.',
            'data' => [
                'product' => $product,
                'rating_summary' => $ratingSummary,
                'related_products' => $relatedProducts
            ]
        ], 200);
    }
    /**
     * 3. GET /api/product/featured
     * Fetch all products where is_featured = 1.
     */
    public function featured()
    {
        $products = Product::with(['category:id,name', 'brand:id,name'])
            ->where('is_featured', 1)
            ->latest()
            ->get(['id', 'name', 'short_description', 'slug', 'purchase_price', 'thumbnail', 'category_id']);

        return response()->json([
            'status' => true,
            'message' => 'Featured products fetched successfully.',
            'data' => $products
        ], 200);
    }

    /**
     * 3B. GET /api/product/new-arrival
     * Fetch the latest 8 products where is_new_arrival = 1.
     */
    public function newArrivals()
    {
        $products = Product::with(['category:id,name', 'brand:id,name'])
            ->where('published', 1)
            ->latest()
            ->limit(8)
            ->get(['id', 'name', 'short_description', 'slug', 'purchase_price', 'thumbnail', 'category_id', 'brand_id']);

        return response()->json([
            'status' => true,
            'message' => 'New arrival products fetched successfully.',
            'data' => $products
        ], 200);
    }

    /**
     * 4. GET /api/product/today_deal
     * Fetch all products where is_todays_deal = 1.
     */
    public function todaysDeal()
    {
        $products = Product::with(['category:id,name', 'brand:id,name'])
            ->where('is_todays_deal', 1)
            ->latest()
            ->get(['id', 'name', 'short_description', 'slug', 'purchase_price', 'thumbnail', 'category_id']);

        return response()->json([
            'status' => true,
            'message' => "Today's deal products fetched successfully.",
            'data' => $products
        ], 200);
    }

   /**
     * 5. GET /api/product/bestseller
     * Fetch products with the highest count of sales this week from OrderItem, grouped by category.
     */
    public function bestSellers()
    {
        $startOfWeek = Carbon::now()->startOfWeek();
        $endOfWeek = Carbon::now()->endOfWeek();

        // Get top product IDs ordered by sales count this current week
        $topProductIds = OrderItem::select('product_id')
            ->whereBetween('created_at', [$startOfWeek, $endOfWeek])
            ->groupBy('product_id')
            ->selectRaw('count(product_id) as total_sales')
            ->orderByDesc('total_sales')
            ->limit(15) // Increased limit slightly to ensure a good spread across categories
            ->pluck('product_id');

        if ($topProductIds->isEmpty()) {
            // Fallback to overall featured/latest if no sales records exist yet for the week
            $products = Product::with(['category:id,name', 'brand:id,name'])->inRandomOrder()->limit(15)->get(['id', 'name', 'slug', 'purchase_price', 'thumbnail', 'category_id']);
        } else {
            // Preserve ordering of top sales IDs
            $products = Product::with(['category:id,name', 'brand:id,name'])
                ->whereIn('id', $topProductIds)
                ->get(['id', 'name', 'slug', 'purchase_price', 'thumbnail', 'category_id'])
                ->sortBy(function($model) use ($topProductIds) {
                    return $topProductIds->search($model->id);
                })
                ->values();
        }

        // Group products by category_id and format with category details
        $groupedProducts = $products->groupBy('category_id')->map(function ($categoryProducts) {
            $category = $categoryProducts->first()->category;
            
            return [
                'category_id' => $category ? $category->id : null,
                'category_name' => $category ? $category->name : 'Uncategorized',
                'products' => $categoryProducts->values(),
            ];
        })->values();

        return response()->json([
            'status' => true,
            'message' => 'Bestselling products grouped by category fetched successfully.',
            'data' => $groupedProducts
        ], 200);
    }

    /**
     * 6. GET /api/categories
     * Fetch all product categories.
     */
   public function categories()
    {
        $categories = Category::with('subCategories:id,category_id,name')->get();
        return response()->json([
            'status' => true,
            'message' => 'Categories fetched successfully.',
            'data' => $categories
        ], 200);
    }
    /**
     * 7. GET /api/brands
     * Fetch all product brands.
     */
    public function brands()
    {
        $brands = Brand::all();

        return response()->json([
            'status' => true,
            'message' => 'Brands fetched successfully.',
            'data' => $brands
        ], 200);
    }

    /**
     * 8. GET /api/products/{id}/reviews
     * Fetch customer reviews for a specific product.
     */
    public function getReviews($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status' => false,
                'message' => 'Product not found.'
            ], 404);
        }

        $reviews = ProductReview::with('user:id,name')->where('product_id', $id)->latest()->get();

        return response()->json([
            'status' => true,
            'message' => 'Product reviews fetched successfully.',
            'data' => $reviews
        ], 200);
    }

    /**
     * 9. POST /api/products/{id}/reviews
     * Submit a review/rating for a specific product.
     */
    public function storeReview(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status' => false,
                'message' => 'Product not found.'
            ], 404);
        }

        // Assuming Sanctum middleware is applied and user is authenticated
        $userId = $request->user()->id;

        // Check if user already reviewed this product to avoid duplicates (optional update or block)
        $review = Review::updateOrCreate(
            ['product_id' => $id, 'user_id' => $userId],
            [
                'rating' => $request->rating,
                'comment' => $request->comment,
            ]
        );

        return response()->json([
            'status' => true,
            'message' => 'Review submitted successfully.',
            'data' => $review
        ], 201);
    }
}