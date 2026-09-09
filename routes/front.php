<?php

use App\Http\Controllers\Front\ProductController;
use App\Http\Controllers\Front\CartController;
use App\Http\Controllers\Front\SellerController;
use App\Http\Controllers\Front\WebsiteController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return 'Welcome to MMA API';
})->name('login');

// Public and Protected Front Routes
Route::prefix('customer/front')->group(function () {
    
    // Product listing, search, & filters (category_id, brand_id, seller_id, min_price, max_price, search)
    Route::get('/products', [ProductController::class, 'index']);

    // Single product details (by slug or id) and public reviews fetch
    Route::get('/products/details/{slug}', [ProductController::class, 'show']);
    
    // Special product feeds
    Route::prefix('products')->group(function () {
        Route::get('/featured', [ProductController::class, 'featured']);
        Route::get('/today_deal', [ProductController::class, 'todaysDeal']);
        Route::get('/bestseller', [ProductController::class, 'bestSellers']);
        Route::get('/new-arrival', [ProductController::class, 'newArrivals']);
        Route::get('/{id}/reviews', [ProductController::class, 'getReviews']);
    }); 

    // Categories & Brands
    Route::get('/categories', [ProductController::class, 'categories']);
    Route::get('/brands', [ProductController::class, 'brands']);
    
    Route::prefix('cart')->group(function () {
        Route::get('/', [CartController::class, 'index']);             // View cart details & totals
        Route::post('/add', [CartController::class, 'store']);         // Add item to cart
        Route::put('/update/{id}', [CartController::class, 'update']); // Update cart item quantity
        Route::delete('/item/{id}', [CartController::class, 'destroy']); // Remove single item from cart
        Route::delete('/clear', [CartController::class, 'clear']);     // Clear entire cart
    }); 

    Route::prefix('sellers')->group(function () {
        Route::get('/', [SellerController::class, 'index']);  
        Route::get('/details/{id}', [SellerController::class, 'show']);  
    }); 

    Route::prefix('component')->group(function () {
        Route::get('/{id}', [WebsiteController::class, 'asset']);  
    }); 
    Route::get('/currency', [WebsiteController::class, 'currency']);  
    Route::get('/settings', [WebsiteController::class, 'index']);  
    Route::get('/blogs', [WebsiteController::class, 'blogs']);  
    Route::get('/blogs/{id}', [WebsiteController::class, 'blog']);  

    // Authenticated user routes (Requires Sanctum middleware)
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/products/{id}/reviews', [ProductController::class, 'storeReview']);
    });
});