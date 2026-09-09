<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Order;
use App\Models\OrderTransaction;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Notifications\CustomerMail;

class CustomerController extends Controller
{
    /**
     * Get paginated buyers list with optional search and status filter.
     */
    public function index(Request $request): JsonResponse
{
    $query = User::buyers();

    if ($request->filled('status')) {
        $query->where('status', $request->status);
    }

    if ($request->filled('search')) {
        $query->where(function ($q) use ($request) {
            $q->where('name', 'LIKE', '%' . $request->search . '%')
              ->orWhere('email', 'LIKE', '%' . $request->search . '%')
              ->orWhere('phone', 'LIKE', '%' . $request->search . '%');
        });
    }

    if ($request->filled('date_from')) {
        $query->whereDate('created_at', '>=', $request->date_from);
    }

    if ($request->filled('date_to')) {
        $query->whereDate('created_at', '<=', $request->date_to);
    }

    $customers = $query->withCount('orders')
                       ->latest()
                       ->paginate($request->get('per_page', 15));

    return response()->json([
        'status' => true,
        'data'   => $customers
    ]);
}

    /**
     * Aggregate customer status statistics and registration metrics for charts.
     */
    public function statistics(): JsonResponse
    {
        // 1. Status Counts (Pending, Active, Blocked, Disabled)
        $statusCounts = User::buyers()
            ->selectRaw("
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
                COUNT(CASE WHEN status = 'blocked' THEN 1 END) as blocked,
                COUNT(CASE WHEN status = 'disabled' THEN 1 END) as disabled,
                COUNT(*) as total
            ")
            ->first();

        // 2. Registrations Metrics (Today, This Week, This Month, This Year)
        $now = now();
        $registrations = [
            'today'     => User::buyers()->whereDate('created_at', $now->toDateString())->count(),
            'this_week'  => User::buyers()->whereBetween('created_at', [$now->copy()->startOfWeek(), $now->copy()->endOfWeek()])->count(),
            'this_month' => User::buyers()->whereMonth('created_at', $now->month)->whereYear('created_at', $now->year)->count(),
            'this_year'  => User::buyers()->whereYear('created_at', $now->year)->count(),
        ];

        // 3. Monthly Registration Chart Data (Current Year - 12 Months)
        $monthlyChartData = User::buyers()
            ->whereYear('created_at', $now->year)
            ->selectRaw('MONTH(created_at) as month, COUNT(*) as count')
            ->groupBy('month')
            ->pluck('count', 'month')
            ->toArray();

        // Fill missing months with 0
        $chart = [];
        for ($m = 1; $m <= 12; $m++) {
            $monthName = date('M', mktime(0, 0, 0, $m, 1));
            $chart[] = [
                'month' => $monthName,
                'count' => $monthlyChartData[$m] ?? 0
            ];
        }

        return response()->json([
            'status' => true,
            'data'   => [
                'status_counts' => $statusCounts,
                'registrations' => $registrations,
                'chart_data'    => $chart,
            ]
        ]);
    }

    /**
     * View detailed buyer profile along with paginated order history.
     */
    public function show(Request $request, $id): JsonResponse
    {
        $customer = User::buyers()->find($id);

        if (!$customer) {
            return response()->json(['status' => false, 'message' => 'Customer not found.'], 404);
        }

        // Fetch Orders for this buyer
        $orders = Order::where('user_id', $customer->id)
            ->latest()
            ->paginate($request->get('orders_per_page', 10));

        // Quick aggregate metrics for buyer
       $summary = [
            'total_orders'      => Order::where('user_id', $customer->id)->count(),
            'delivered_orders'  => Order::where('user_id', $customer->id)->where('order_status', 'delivered')->count(),
            'pending_orders'    => Order::where('user_id', $customer->id)->where('order_status', 'pending')->count(),
            'processing_orders' => Order::where('user_id', $customer->id)->where('order_status', 'processing')->count(),
            'confirmed_orders'  => Order::where('user_id', $customer->id)->where('order_status', 'confirmed')->count(),
            'shipped_orders'    => Order::where('user_id', $customer->id)->where('order_status', 'shipped')->count(),
            'cancelled_orders'  => Order::where('user_id', $customer->id)->where('order_status', 'cancelled')->count(),
            'returned_orders'   => Order::where('user_id', $customer->id)->where('order_status', 'returned')->count(),
            'total_spent_value' => Order::where('user_id', $customer->id)->whereNotIn('order_status', ['delivered', 'cancelled', 'returned'])->sum('total_amount'),
        ];  

        return response()->json([
            'status' => true,
            'data'   => [
                'customer' => $customer,
                'summary'  => $summary,
                'orders'   => $orders,
            ]
        ]);
    }

    /**
     * View all transactions associated with a buyer.
     */
    public function transactions(Request $request, $id): JsonResponse
    {
        $customer = User::buyers()->find($id);

        if (!$customer) {
            return response()->json(['status' => false, 'message' => 'Customer not found.'], 404);
        }

        $query = OrderTransaction::where('user_id', $customer->id);
 

        if ($request->filled('status')) {
            $query->where('status', $request->status); // e.g., success, pending, failed
        }

        $transactions = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => [
                'customer_id'  => $customer->id,
                'transactions' => $transactions,
            ]
        ]);
    }

    /**
     * Update customer status (pending, active, blocked, disabled) with Audit Logging.
     */
    public function updateStatus(Request $request, $id): JsonResponse
    {
        $customer = User::buyers()->find($id);

        if (!$customer) {
            return response()->json(['status' => false, 'message' => 'Customer not found.'], 404);
        }

        $validated = $request->validate([
            'status' => 'required|in:pending,active,blocked,disabled',
            'reason' => 'nullable|string|max:255',
        ]);

        $oldStatus = $customer->status;
        $customer->update(['status' => $validated['status']]);

        // Audit Log
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_customer_status',
            'description' => "Changed customer (#{$customer->id} - {$customer->name}) status from {$oldStatus} to {$validated['status']}. Reason: " . ($validated['reason'] ?? 'N/A'),
            'old_values'  => ['status' => $oldStatus],
            'new_values'  => ['status' => $validated['status']],
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => "Customer status updated to {$validated['status']} successfully.",
            'data'    => $customer
        ]);
    }

    /**
     * Send an email notification to a specific customer with Audit Logging.
     */
    public function sendMail(Request $request, $id): JsonResponse
    {
        $customer = User::buyers()->find($id);

        if (!$customer) {
            return response()->json(['status' => false, 'message' => 'Customer not found.'], 404);
        }

        $validated = $request->validate([
            'subject' => 'required|string|max:255',
            'message' => 'required|string',
        ]);

        try {
            // Dispatch the Notification via the customer model instance
            $customer->notify(new CustomerMail(
                $validated['subject'],
                $validated['message']
            ));

            // Audit Log
            AuditLog::create([
                'user_id'     => $request->user()?->id,
                'action'      => 'send_customer_email',
                'description' => "Sent notification email to customer (#{$customer->id} - {$customer->name}). Subject: {$validated['subject']}",
                'ip_address'  => $request->ip(),
                'user_agent'  => $request->userAgent(),
            ]);

            return response()->json([
                'status'  => true,
                'message' => 'Email sent successfully to ' . $customer->email,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status'  => false,
                'message' => 'Failed to send email. Please check notification configuration.',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Soft delete/remove a buyer profile.
     */
    public function destroy(Request $request, $id): JsonResponse
    {
        $customer = User::buyers()->find($id);

        if (!$customer) {
            return response()->json(['status' => false, 'message' => 'Customer not found.'], 404);
        }

        $customerData = $customer->toArray();
        $customer->delete();

        // Audit Log
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'delete_customer',
            'description' => "Deleted customer account (#{$customerData['id']} - {$customerData['email']}).",
            'old_values'  => $customerData,
            'new_values'  => null,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Customer record removed successfully.'
        ]);
    }
}