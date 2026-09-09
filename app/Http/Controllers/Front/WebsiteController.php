<?php

namespace App\Http\Controllers\Front;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Blog;
use App\Models\Setting;
use App\Models\FrontendContent;
use Illuminate\Http\JsonResponse;

class WebsiteController extends Controller
{

 /**
     * Fetch all current system settings grouped by domain.
     */
    public function index(): JsonResponse
    {
        $settings = Setting::all()->pluck('value', 'key');

        return response()->json([
            'status' => true,
            'data'   => [
                'general' => [
                    'logo'            => $settings['logo'] ?? '',
                    'site_name'       => $settings['site_name'] ?? '',
                    'site_email'      => $settings['site_email'] ?? '',
                    'site_phone'      => $settings['site_phone'] ?? '',
                    'site_currency'   => $settings['site_currency'] ?? 'USD',
                    'currency_symbol' => $settings['currency_symbol'] ?? '$',
                ],
                'maintenance' => [
                    'maintenance_mode'    => filter_var($settings['maintenance_mode'] ?? false, FILTER_VALIDATE_BOOLEAN),
                    'maintenance_message' => $settings['maintenance_message'] ?? '',
                ], 
                'global_seo' => [
                    'meta_title'       => $settings['global_meta_title'] ?? '',
                    'meta_description' => $settings['global_meta_description'] ?? '',
                    'meta_keywords'    => $settings['global_meta_keywords'] ?? '',
                    'meta_image'       => $settings['global_meta_image'] ?? '',
                ],
                'homepage_seo' => [
                    'meta_title'       => $settings['homepage_meta_title'] ?? '',
                    'meta_description' => $settings['homepage_meta_description'] ?? '',
                    'meta_keywords'    => $settings['homepage_meta_keywords'] ?? '',
                ],
            ]
        ]);
    }


    /**
     * Fetch all asset.
     */
    public function asset(Request $request, $id = null)
    {
        try {
            // Use withCount('products') before paginate to include product counts per seller
            $assets = FrontendContent::where('component', $id)
                ->where('status', true)
                ->paginate($request->get('per_page', 15));

            return response()->json([
                'status' => true,
                'message' => 'Assets fetched successfully',
                'data' => $assets
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch assets',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Fetch system currency.
     */
    public function currency()
    {
        // Pass columns as an array to the first() method
        $currency = Setting::where('id', 5)->select(['id', 'key', 'value'])->first();

        // Handle case where the setting record doesn't exist
        if (!$currency) {
            return response()->json([
                'status' => false,
                'message' => 'Currency setting not found.',
                'data' => null
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Currency fetched successfully.',
            'data' => $currency
        ], 200);
    }

        /**
     * Display a listing of the blogs.
     */
    public function blogs(Request $request): JsonResponse
    {
        $query = Blog::query();

        // Optional filtering by status
        if ($request->has('status')) {
            $query->where('status', $request->boolean('status'));
        }

        // Search by title or body
        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('body', 'like', "%{$search}%");
            });
        }

        $blogs = $query->whereStatus(1)->latest()->paginate($request->input('per_page', 15));

        return response()->json([
            'status'  => true,
            'message' => 'Blogs fetched successfully.',
            'data'    => $blogs
        ]);
    }

 

    /**
     * Display the specified blog.
     */
    public function blog($idOrSlug): JsonResponse
    {
        $blog = is_numeric($idOrSlug) 
            ? Blog::findOrFail($idOrSlug) 
            : Blog::where('slug', $idOrSlug)->firstOrFail();

        return response()->json([
            'status'  => true,
            'message' => 'Blog fetched successfully.',
            'data'    => $blog
        ]);
    }



}