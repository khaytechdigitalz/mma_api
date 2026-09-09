<?php

use App\Http\Controllers\Auth\CustomerAuthController;
use App\Http\Controllers\Customer\DashboardController;
use App\Http\Controllers\Customer\OrderController;
use App\Http\Controllers\Customer\ProfileController;
use App\Http\Controllers\Customer\CheckoutController;
use App\Http\Controllers\Customer\SecurityController;
use App\Http\Controllers\Customer\PaymentController;
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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/', function () {
    return 'Welcome to MMA API';
})->name('login');

// Public routes
Route::prefix('customer')->group(function () {
    Route::post('/auth/register', [CustomerAuthController::class, 'register']);
    Route::post('/auth/resend-verification', [CustomerAuthController::class, 'forgotPassword']);
    Route::post('/auth/register/verify/email', [CustomerAuthController::class, 'verifyEmail']);
    Route::post('/auth/login', [CustomerAuthController::class, 'login']);
    Route::post('/auth/forgotpassword', [CustomerAuthController::class, 'forgotPassword']);
    Route::post('/auth/otp/verify', [CustomerAuthController::class, 'verifyOtp']);
    Route::post('/auth/resetpassword', [CustomerAuthController::class, 'resetPassword']);
});

// Protected routes
Route::middleware('auth:sanctum')->prefix('customer')->group(function () {
    // Authentication
    Route::post('/auth/logout', [CustomerAuthController::class, 'logout']);
    /*
    Route::get('/dashboard', [DashboardController::class, 'dashboard']); 
    Route::prefix('profile')->group(function () {
        Route::get('/', [ProfileController::class, 'profile']);
        Route::post('/update', [ProfileController::class, 'updateProfile']);
        Route::post('/change-password', [ProfileController::class, 'changePassword']);
    });
    */

    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index']);

    // Orders
    Route::prefix('orders')->group(function () {
        Route::get('/', [OrderController::class, 'index']);
        Route::get('/{id}', [OrderController::class, 'show']);
        Route::post('/{id}/remark', [OrderController::class, 'remark']);
    });

    // Profile & Addresses
    Route::get('/profile', [ProfileController::class, 'showProfile']);
    Route::post('/profile', [ProfileController::class, 'updateProfile']); // Use POST with _method=PUT if sending multipart/form-data for avatar
    Route::get('/addresses', [ProfileController::class, 'listAddresses']);
    Route::post('/addresses', [ProfileController::class, 'addAddress']);
    Route::delete('/addresses/{id}', [ProfileController::class, 'deleteAddress']);

    // Security & 2FA
    Route::prefix('security')->group(function () {
        Route::post('/password', [SecurityController::class, 'updatePassword']);
        Route::post('/2fa/setup', [SecurityController::class, 'setup2fa']);
        Route::post('/2fa/enable', [SecurityController::class, 'enable2fa']);
        Route::post('/2fa/disable', [SecurityController::class, 'disable2fa']);
    });

    Route::prefix('checkout')->group(function () {
        Route::get('/summary', [CheckoutController::class, 'index']);
        Route::post('/place-order', [CheckoutController::class, 'store']);
    });

    Route::prefix('payment')->group(function () {
        Route::post('/verify-paystack/{id}', [PaymentController::class, 'verifyPaystackPayment']);
    });



});


// External customer frontend routes
require __DIR__ . '/front.php';