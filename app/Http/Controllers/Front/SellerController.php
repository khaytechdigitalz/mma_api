<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User; // Adjust model if your sellers use a specific model or role

class SellerController extends Controller
{
    /**
     * Fetch all sellers.
     */
    public function index(Request $request)
    {
        try {
            // Use withCount('products') before paginate to include product counts per seller
            $sellers = User::where('type', 'seller')
                ->with('storefront')
                ->withCount('products as total_products') // Automatically appends total_products to each seller item
                ->paginate($request->get('per_page', 15));

            return response()->json([
                'status' => true,
                'message' => 'Sellers fetched successfully',
                'data' => $sellers
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch sellers',
                'error' => $e->getMessage()
            ], 500);
        }
    }

   /**
     * View seller details by ID.
     */
    public function show($id)
    {
        try {
            // Fetch seller along with counts and aggregated star breakdown
            $seller = User::with([
                    'products:id,seller_id,name,slug,short_description,unit_price,purchase_price,thumbnail,created_at', 
                    'storefront'
                ])
                ->withCount([
                    'products as total_products_count',
                    'sellerreviews as total_reviews_count'
                ])
                ->with([
                    'sellerreviews' => function ($query) {
                        $query->select('id', 'seller_id', 'rating');
                    }
                ])
                ->where('type', 'seller')
                ->findOrFail($id);

            // Use 'sellerreviews' instead of 'reviews' to match the relationship name
            $reviews = $seller->sellerreviews ?? collect();
            
            // Compute star count breakdown (1 to 5 stars) and average rating
            $starCounts = [
                1 => 0,
                2 => 0,
                3 => 0,
                4 => 0,
                5 => 0,
            ];

            foreach ($reviews as $review) {
                $rating = (int) $review->rating;
                if (isset($starCounts[$rating])) {
                    $starCounts[$rating]++;
                }
            }

            $averageRating = $reviews->count() > 0 ? round($reviews->avg('rating'), 1) : 0;

            // Transform the data array to inject computed metrics explicitly
            $sellerData = $seller->toArray();
            $sellerData['total_products'] = $seller->total_products_count;
            $sellerData['total_reviews'] = $seller->total_reviews_count;
            $sellerData['average_rating'] = $averageRating;
            $sellerData['star_breakdown'] = $starCounts;

            // Remove the raw full sellerreviews collection from the final response array
            unset($sellerData['sellerreviews']);

            return response()->json([
                'status' => true,
                'message' => 'Seller details fetched successfully',
                'data' => $sellerData
            ], 200);
            
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Seller not found',
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch seller details',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}