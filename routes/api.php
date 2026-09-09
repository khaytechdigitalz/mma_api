<?php

use App\Http\Controllers\Auth\AdminAuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\AuditLogController;
use App\Http\Controllers\Admin\AttributeController;
use App\Http\Controllers\Admin\RefundController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\AbandonedCartController;
use App\Http\Controllers\Admin\PlatformEarningController;
use App\Http\Controllers\Admin\SubCategoryController;
use App\Http\Controllers\Admin\ProductReviewController;
use App\Http\Controllers\Admin\TransactionController;
use App\Http\Controllers\Admin\CouponController;
use App\Http\Controllers\Admin\FrontendContentController;
use App\Http\Controllers\Admin\FlashSaleController;
use App\Http\Controllers\Admin\BrandController;
use App\Http\Controllers\Admin\AccountSettingsController;
use App\Http\Controllers\Admin\BlogController;
use App\Http\Controllers\Admin\WithdrawalController;
use App\Http\Controllers\Admin\TopProductReportController;
use App\Http\Controllers\Admin\TicketController;
use App\Http\Controllers\Admin\NotificationController;
use App\Http\Controllers\Admin\CustomerController;
use App\Http\Controllers\Admin\SalesReportController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\SellerController;
use App\Http\Controllers\Admin\RolePermissionController;
use App\Http\Controllers\Admin\AdminUserController;
use App\Http\Controllers\Admin\ProfileController;
use App\Http\Controllers\Admin\PaymentGatewayController;
use App\Http\Controllers\AI\AiProductController;

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
Route::prefix('admin')->group(function () {
    Route::post('/auth/login', [AdminAuthController::class, 'login']);
    Route::post('/auth/login_twofa', [AdminAuthController::class, 'verify2fa']);
    Route::post('/auth/forgotpassword', [AdminAuthController::class, 'forgotPassword']);
    Route::post('/auth/otp/verify', [AdminAuthController::class, 'verifyOtp']);
    Route::post('/auth/resetpassword', [AdminAuthController::class, 'resetPassword']);
});

// Protected routes
Route::middleware('auth:sanctum')->prefix('admin')->group(function () {
    // Authentication
    Route::post('/auth/logout', [AdminAuthController::class, 'logout']);
    
    Route::middleware(['permission:dashboard.view'])->group(function () {
        Route::get('/dashboard', [DashboardController::class, 'dashboard']); 
    });

   // Categories Routes
    Route::prefix('categories')->group(function () {
        Route::middleware(['permission:categories.view'])->group(function () {
            Route::get('/', [CategoryController::class, 'index']);
            Route::get('/{id}', [CategoryController::class, 'show']);
        });
        Route::middleware(['permission:categories.create'])->group(function () {
            Route::post('/', [CategoryController::class, 'store']);
        });
        Route::middleware(['permission:categories.edit'])->group(function () {
            Route::post('/{id}', [CategoryController::class, 'update']);
        });
        Route::middleware(['permission:categories.delete'])->group(function () {
            Route::delete('/{id}', [CategoryController::class, 'destroy']);
        });
    });

    // Sub Categories Routes
    Route::prefix('subcategories')->group(function () {
        Route::middleware(['permission:subcategories.view'])->group(function () {
            Route::get('/', [SubCategoryController::class, 'index']);   
            Route::get('/{id}', [SubCategoryController::class, 'show']);  
        });
        Route::middleware(['permission:subcategories.create'])->group(function () {
            Route::post('/', [SubCategoryController::class, 'store']);   
        });
        Route::middleware(['permission:subcategories.edit'])->group(function () {
            Route::put('/{id}', [SubCategoryController::class, 'update']); 
        });
        Route::middleware(['permission:subcategories.delete'])->group(function () {
            Route::delete('/{id}', [SubCategoryController::class, 'destroy']);
        });
    });

    // Brands Routes
    Route::prefix('brands')->group(function () {
        Route::middleware(['permission:brands.view'])->group(function () {
            Route::get('/', [BrandController::class, 'index']);
            Route::get('/{brand}', [BrandController::class, 'show']);
        });
        Route::middleware(['permission:brands.create'])->group(function () {
            Route::post('/', [BrandController::class, 'store']);
        });
        Route::middleware(['permission:brands.edit'])->group(function () {
            Route::post('/{brand}', [BrandController::class, 'update']);
        });
        Route::middleware(['permission:brands.delete'])->group(function () {
            Route::delete('/{brand}', [BrandController::class, 'destroy']);
        });
    });

    // Master Attributes CRUD
    Route::middleware(['permission:attributes.view'])->group(function () {
        Route::get('attributes', [AttributeController::class, 'index']);
        Route::get('attributes/{attribute}', [AttributeController::class, 'show']);
    });
    Route::middleware(['permission:attributes.create'])->group(function () {
        Route::post('attributes', [AttributeController::class, 'store']);
    });
    Route::middleware(['permission:attributes.edit'])->group(function () {
        Route::put('attributes/{attribute}', [AttributeController::class, 'update']);
        Route::patch('attributes/{attribute}', [AttributeController::class, 'update']);
    });
    Route::middleware(['permission:attributes.delete'])->group(function () {
        Route::delete('attributes/{attribute}', [AttributeController::class, 'destroy']);
    });
    
    // Nested Attribute Values CRUD
    Route::prefix('attributes/{attribute}')->group(function () {
        Route::middleware(['permission:attributes.create'])->group(function () {
            Route::post('values', [AttributeController::class, 'storeValue']);
        });
        Route::middleware(['permission:attributes.edit'])->group(function () {
            Route::put('values/{value}', [AttributeController::class, 'updateValue']);
        });
        Route::middleware(['permission:attributes.delete'])->group(function () {
            Route::delete('values/{value}', [AttributeController::class, 'destroyValue']);
        });
    });

    // Products Routes
    Route::prefix('products')->group(function () {
        Route::middleware(['permission:products.view'])->group(function () {
            Route::get('/', [ProductController::class, 'index']);
            Route::get('/{id}', [ProductController::class, 'show']);
        });
        Route::middleware(['permission:products.create'])->group(function () {
            Route::post('/', [ProductController::class, 'store']);
        });
        Route::middleware(['permission:products.edit'])->group(function () {
            Route::post('/{id}', [ProductController::class, 'update']);
            Route::patch('/{id}/status', [ProductController::class, 'updateStatus']);
            Route::patch('/{id}/published', [ProductController::class, 'updatePublished']);
            Route::patch('/{id}/unpublish', [ProductController::class, 'updatePublished']);
        });
        Route::middleware(['permission:products.delete'])->group(function () {
            Route::delete('/{id}', [ProductController::class, 'destroy']);
        });
    });

    //AI Controller
    Route::prefix('ai')->group(function () {
        Route::post('/generate-description', [AiProductController::class, 'generateProductDescription']);
        Route::post('/generate-grok-description', [AiProductController::class, 'generateDescriptionGrok']);
    });

    Route::prefix('product-reviews')->group(function () {
        // Product Review Routes
        Route::get('/', [ProductReviewController::class, 'index']);
        Route::get('/{id}', [ProductReviewController::class, 'show']);
        Route::put('/{id}', [ProductReviewController::class, 'update']);
        Route::delete('/{id}', [ProductReviewController::class, 'destroy']);
    });

    // Orders Routes
    Route::prefix('orders')->group(function () {
        // Orders Management
        Route::middleware(['permission:orders.view'])->group(function () {
            Route::get('/', [OrderController::class, 'index']);
            Route::get('/dashboard-widgets', [OrderController::class, 'getDashboardWidgets']);
            Route::get('/profit-chart', [OrderController::class, 'getProfitMarginChart']);
            Route::get('/{id}', [OrderController::class, 'show']);
        });
        // Order Status & Payment Updates
        Route::middleware(['permission:orders.manage'])->group(function () {
            Route::post('/{id}/update-status', [OrderController::class, 'updateOrderStatus']);
            Route::post('/{id}/update-payment-status', [OrderController::class, 'updatePaymentStatus']);
            Route::post('/order-items/{id}/update-status', [OrderController::class, 'updateOrderItemStatus']);
        });
    });

    // Abandoned Cart Routes
    Route::prefix('abandoned-carts')->group(function () {
        // Abandoned Carts Management
        Route::middleware(['permission:abandoned_carts.view'])->group(function () {
            Route::get('/', [AbandonedCartController::class, 'index']);
            Route::get('/{id}', [AbandonedCartController::class, 'show']);
        });
        Route::middleware(['permission:abandoned_carts.delete'])->group(function () {
            Route::delete('/{id}', [AbandonedCartController::class, 'destroy']);
        });
        // Recovery Notifications
        Route::middleware(['permission:abandoned_carts.notify'])->group(function () {
            Route::post('/{id}/send-notification', [AbandonedCartController::class, 'sendNotification']);
            Route::post('/send-bulk-notifications', [AbandonedCartController::class, 'sendBulkNotifications']);
        });
    });

    // Transaction Routes
    Route::prefix('transactions')->group(function () {
        // Transaction Management & Reporting
        Route::middleware(['permission:transactions.view'])->group(function () {
            Route::get('/', [TransactionController::class, 'index']);
            Route::get('/dashboard-widgets', [TransactionController::class, 'getDashboardWidgets']);
            Route::get('/chart-metrics', [TransactionController::class, 'getTransactionChart']);
            Route::get('/{id}', [TransactionController::class, 'show']);
            Route::get('/tax/all', [TransactionController::class, 'tax']);
        });
        Route::middleware(['permission:transactions.manage'])->group(function () {
            Route::post('/{id}/update-status', [TransactionController::class, 'update']);
        });
    });

    // Refund Management
    Route::prefix('refunds')->group(function () {
        Route::middleware(['permission:refunds.view'])->group(function () {
            Route::get('/', [RefundController::class, 'index']);
            Route::get('/{id}', [RefundController::class, 'show']);
        });
        Route::middleware(['permission:refunds.manage'])->group(function () {
            Route::post('/{id}/approve', [RefundController::class, 'approve']);
            Route::post('/{id}/decline', [RefundController::class, 'decline']);
        });
    });

    // Platform Earnings Routes
    Route::middleware(['permission:platform_earnings.view'])->group(function () {
        Route::get('/platform-earnings', [PlatformEarningController::class, 'index']);
    });

    // Platform Reporting Routes
     Route::middleware(['permission:platform_reporting.view'])->group(function () {
        Route::get('/sales-report', [SalesReportController::class, 'index']);
        Route::get('/top-product-report', [TopProductReportController::class, 'index']);
    });


    // Withdrawal Management Endpoints
    Route::prefix('withdrawals')->group(function () {
        Route::middleware(['permission:withdrawals.view'])->group(function () {
            Route::get('/', [WithdrawalController::class, 'index']);
            Route::get('/{id}', [WithdrawalController::class, 'show']);
        });
        Route::middleware(['permission:withdrawals.manage'])->group(function () {
            Route::post('/{id}/approve', [WithdrawalController::class, 'approve']);
            Route::post('/{id}/decline', [WithdrawalController::class, 'decline']);
        });
    });

    // Coupon Management Routes
    Route::prefix('coupons')->group(function () {
        Route::middleware(['permission:coupons.view'])->group(function () {
            Route::get('/', [CouponController::class, 'index']);
            Route::get('/{id}', [CouponController::class, 'show']);
        });
        Route::middleware(['permission:coupons.create'])->group(function () {
            Route::post('/', [CouponController::class, 'store']);
        });
        Route::middleware(['permission:coupons.edit'])->group(function () {
            Route::put('/{id}', [CouponController::class, 'update']);
            Route::patch('/{id}/toggle-status', [CouponController::class, 'toggleStatus']);
        });
        Route::middleware(['permission:coupons.delete'])->group(function () {
            Route::delete('/{id}', [CouponController::class, 'destroy']);
        });
    });

    // Flash Sale Routes
    Route::prefix('flash-sales')->group(function () {
        Route::middleware(['permission:flash_sales.view'])->group(function () {
            Route::get('/', [FlashSaleController::class, 'index']);
            Route::get('/{id}', [FlashSaleController::class, 'show']);
        });
        Route::middleware(['permission:flash_sales.create'])->group(function () {
            Route::post('/', [FlashSaleController::class, 'store']);
        });
        Route::middleware(['permission:flash_sales.edit'])->group(function () {
            Route::put('/{id}', [FlashSaleController::class, 'update']);
            Route::patch('/{id}/toggle-status', [FlashSaleController::class, 'toggleStatus']);
        });
        Route::middleware(['permission:flash_sales.delete'])->group(function () {
            Route::delete('/{id}', [FlashSaleController::class, 'destroy']);
        });
    });

    // Frontend Landing Page Management Routes
    Route::prefix('frontend-contents')->group(function () {
        Route::middleware(['permission:frontend_contents.view'])->group(function () {
            Route::get('/', [FrontendContentController::class, 'index']);
            Route::get('/{id}', [FrontendContentController::class, 'show']);
        });
        Route::middleware(['permission:frontend_contents.create'])->group(function () {
            Route::post('/', [FrontendContentController::class, 'store']);
        });
        Route::middleware(['permission:frontend_contents.edit'])->group(function () {
            Route::put('/{id}', [FrontendContentController::class, 'update']);
            Route::patch('/{id}/toggle-status', [FrontendContentController::class, 'toggleStatus']);
        });
        Route::middleware(['permission:frontend_contents.delete'])->group(function () {
            Route::delete('/{id}', [FrontendContentController::class, 'destroy']);
        });
    });

    Route::prefix('blogs')->group(function () {
        Route::middleware(['permission:frontend_contents.view'])->group(function () {
            Route::get('/', [BlogController::class, 'index']);
            Route::get('/{id}', [BlogController::class, 'show']);
        });
        Route::middleware(['permission:frontend_contents.create'])->group(function () {
            Route::post('/', [BlogController::class, 'store']);
        });
        Route::middleware(['permission:frontend_contents.edit'])->group(function () {
            Route::put('/{id}', [BlogController::class, 'update']);
            Route::patch('/{id}/toggle-status', [BlogController::class, 'toggleStatus']);
        });
        Route::middleware(['permission:frontend_contents.delete'])->group(function () {
            Route::delete('/{id}', [BlogController::class, 'destroy']);
        });
    });

    // Support Ticket Routes
    Route::prefix('tickets')->group(function () {
        Route::middleware(['permission:tickets.view'])->group(function () {
            Route::get('/', [TicketController::class, 'index']);
            Route::get('/{id}', [TicketController::class, 'show']);
        });
        Route::middleware(['permission:tickets.reply'])->group(function () {
            Route::post('/{id}/reply', [TicketController::class, 'reply']);
            Route::patch('/{id}/close', [TicketController::class, 'close']);
        });
    });

    // Settings Management Routes
    Route::prefix('settings')->group(function () {
        Route::middleware(['permission:settings.view'])->group(function () {
            Route::get('/', [SettingController::class, 'index']);
            Route::patch('/notification/{id}', [SettingController::class, 'updateNotification']);
        });
        Route::middleware(['permission:settings.manage'])->group(function () {
            Route::post('/general', [SettingController::class, 'updateGeneralInfo']);
            Route::post('/maintenance', [SettingController::class, 'updateMaintenanceMode']);
            Route::post('/seo/global', [SettingController::class, 'updateGlobalSeo']);
            Route::post('/seo/homepage', [SettingController::class, 'updateHomepageSeo']);
        });
    });

    // Customer / Buyer Management Routes
    Route::prefix('customers')->group(function () {
        Route::middleware(['permission:customers.view'])->group(function () {
            Route::get('/', [CustomerController::class, 'index']);
            Route::get('/statistics', [CustomerController::class, 'statistics']);
            Route::get('/{id}', [CustomerController::class, 'show']);
            Route::get('/{id}/transactions', [CustomerController::class, 'transactions']);
        });
        Route::middleware(['permission:customers.manage'])->group(function () {
            Route::patch('/{id}/status', [CustomerController::class, 'updateStatus']);
            Route::post('/{id}/sendmail', [CustomerController::class, 'sendMail']);
        });
        Route::middleware(['permission:customers.delete'])->group(function () {
            Route::delete('/{id}', [CustomerController::class, 'destroy']);
        });
    });

    // Seller Management Routes
    Route::prefix('sellers')->group(function () {
        Route::middleware(['permission:sellers.view'])->group(function () {
            Route::get('/', [SellerController::class, 'index']);
            Route::get('/statistics', [SellerController::class, 'statistics']);
            Route::get('/{id}', [SellerController::class, 'show']);
            Route::get('/{id}/products', [SellerController::class, 'products']);
            Route::get('/{id}/orders', [SellerController::class, 'orders']);
            Route::get('/{id}/refunds', [SellerController::class, 'refunds']);
            Route::get('/{id}/settlements', [SellerController::class, 'settlements']);
        });
        Route::middleware(['permission:sellers.manage'])->group(function () {
            Route::patch('/{id}/status', [SellerController::class, 'updateStatus']);
            Route::post('/{id}/update', [SellerController::class, 'update']);
            Route::patch('/{id}/storefront-status', [SellerController::class, 'updateStorefrontStatus']);
            Route::patch('/{id}/block', [SellerController::class, 'toggleBlockSeller']);
            Route::patch('/{id}/bank-accounts/{bankId}/status', [SellerController::class, 'toggleBankAccountStatus']);
        });
    });
 

   // Roles & Permissions Routes
    Route::prefix('roles')->group(function () {
        Route::middleware(['permission:roles.view'])->group(function () {
            Route::get('/', [RolePermissionController::class, 'indexRoles']);
            Route::get('/permissions', [RolePermissionController::class, 'indexPermissions']);
            Route::get('/{id}', [RolePermissionController::class, 'showRole']);
        });
        Route::middleware(['permission:roles.manage'])->group(function () {
            Route::post('/', [RolePermissionController::class, 'storeRole']);
            Route::put('/{id}', [RolePermissionController::class, 'updateRole']);
            Route::delete('/{id}', [RolePermissionController::class, 'destroyRole']);
        });
    });


    // Authenticated Self Profile (Accessible by any authenticated staff/admin)
    Route::prefix('profile')->group(function () {
        Route::get('/', [ProfileController::class, 'show']);
        Route::put('/', [ProfileController::class, 'updateProfile']);
        Route::put('/password', [ProfileController::class, 'updatePassword']);
    });
    

    // Staff User Management
    Route::prefix('staff')->group(function () {
        Route::middleware(['permission:staff.view'])->group(function () {
            Route::get('/', [AdminUserController::class, 'index']);
            Route::get('/{id}', [AdminUserController::class, 'StaffProfile']);
        });
        Route::middleware(['permission:staff.manage'])->group(function () {
            Route::post('/invite', [AdminUserController::class, 'invite']);
            Route::put('/{id}', [AdminUserController::class, 'updateStaffProfile']);
            Route::put('/{id}/password', [AdminUserController::class, 'updateStaffPassword']);
            Route::patch('/{id}/status', [AdminUserController::class, 'toggleStatus']);
            Route::patch('/{id}/role', [AdminUserController::class, 'changeRole']);
        });
        Route::middleware(['permission:staff.delete'])->group(function () {
            Route::delete('/{id}', [AdminUserController::class, 'destroy']);
        });
    });

    // Payment Gateways
    Route::prefix('payment-gateways')->group(function () {
        Route::get('/', [PaymentGatewayController::class, 'index']);
        Route::post('/{slug}', [PaymentGatewayController::class, 'update']);
        Route::patch('/status/{id}', [PaymentGatewayController::class, 'updateStatus']);
    });
    // Audit Logs Routes
    Route::prefix('audit-logs')->group(function () {
        Route::middleware(['permission:audit_logs.view'])->group(function () {
            Route::get('/', [AuditLogController::class, 'index']);
            Route::get('/{id}', [AuditLogController::class, 'show']);
        });
    });

    // Account Settings Routes
    Route::prefix('account')->middleware(['auth:sanctum'])->group(function () {
        Route::get('/', [AccountSettingsController::class, 'show']);
        Route::post('/profile', [AccountSettingsController::class, 'updateProfile']);
        Route::put('/password', [AccountSettingsController::class, 'updatePassword']);
        
        // 2FA Management Routes
        Route::post('/2fa/setup', [AccountSettingsController::class, 'setup2fa']);
        Route::post('/2fa/enable', [AccountSettingsController::class, 'enable2fa']);
        Route::post('/2fa/disable', [AccountSettingsController::class, 'disable2fa']);
    });

 
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::get('/new', [NotificationController::class, 'new']);
        Route::get('/details/{id}', [NotificationController::class, 'show']);
    });
});
