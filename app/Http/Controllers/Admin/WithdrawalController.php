<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Withdrawal;
use App\Models\OrderTransaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class WithdrawalController extends Controller
{
    /**
     * Dashboard view: Widgets, Charts, and Filterable Table
     */
    public function index(Request $request): JsonResponse
    {
        // 1. Dynamic Widgets (Filtered according to search parameters)
        $withdrawalQuery = Withdrawal::query();
        $this->applyFilters($withdrawalQuery, $request);

        $widgets = [
            'total_successful_transaction_amount' => round((float) OrderTransaction::where('status', 'successful')->sum('total_amount'), 2),
            'pending_withdrawals'                 => round((float) (clone $withdrawalQuery)->where('status', 'pending')->sum('amount'), 2),
            'successful_withdrawals'              => round((float) (clone $withdrawalQuery)->where('status', 'approved')->sum('amount'), 2),
            'cancelled_withdrawals'               => round((float) (clone $withdrawalQuery)->where('status', 'declined')->sum('amount'), 2),
        ];

        // 2. Charts (Only counts approved payout volumes)
        $approvedQuery = Withdrawal::where('status', 'approved');
        $charts = [
            'today'     => $this->getTodayWithdrawals($approvedQuery),
            'this_week' => $this->getThisWeekWithdrawals($approvedQuery),
            'this_month' => $this->getThisMonthWithdrawals($approvedQuery),
            'this_year' => $this->getThisYearWithdrawals($approvedQuery),
        ];

        // 3. Paginated Request List
        $withdrawals = $withdrawalQuery->with([
            'user:id,name,email,phone',
            'bankDetail:id,user_id,bank_code,bank_name,account_number,account_name',
            'processedBy:id,name'
        ])
        ->latest()
        ->paginate($request->get('per_page', 15));

        return response()->json([
            'status'  => true,
            'widgets' => $widgets,
            'charts'  => $charts,
            'data'    => $withdrawals,
        ]);
    }

    /**
     * Get specific withdrawal detail
     */
    public function show($id): JsonResponse
    {
        $withdrawal = Withdrawal::with([
            'user:id,name,email,phone',
            'bankDetail',
            'processedBy:id,name'
        ])->find($id);

        if (!$withdrawal) {
            return response()->json(['status' => false, 'message' => 'Withdrawal record not found.'], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $withdrawal
        ]);
    }

    /**
     * Approve payout request
     */
    public function approve(Request $request, $id): JsonResponse
    {
        $request->validate(['admin_notes' => 'nullable|string|max:500']);

        $withdrawal = Withdrawal::find($id);

        if (!$withdrawal) {
            return response()->json(['status' => false, 'message' => 'Withdrawal request not found.'], 404);
        }

        if ($withdrawal->status !== 'pending') {
            return response()->json(['status' => false, 'message' => "Withdrawal has already been processed as {$withdrawal->status}."], 422);
        }

        $withdrawal->update([
            'status'               => 'approved',
            'admin_notes'          => $request->admin_notes ?? 'Withdrawal approved and processed.',
            'processed_by_user_id' => Auth::id() ?? 1,
            'processed_at'         => now(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Withdrawal request approved successfully.',
            'data'    => $withdrawal
        ]);
    }

    /**
     * Decline payout request
     */
    public function decline(Request $request, $id): JsonResponse
    {
        $request->validate([
            'admin_notes' => 'required|string|max:500'
        ]);

        $withdrawal = Withdrawal::find($id);

        if (!$withdrawal) {
            return response()->json(['status' => false, 'message' => 'Withdrawal request not found.'], 404);
        }

        if ($withdrawal->status !== 'pending') {
            return response()->json(['status' => false, 'message' => "Withdrawal has already been processed as {$withdrawal->status}."], 422);
        }

        $withdrawal->update([
            'status'               => 'declined',
            'admin_notes'          => $request->admin_notes,
            'processed_by_user_id' => Auth::id() ?? 1,
            'processed_at'         => now(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Withdrawal request declined successfully.',
            'data'    => $withdrawal
        ]);
    }

    private function applyFilters($query, Request $request): void
    {
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('search')) {
            $query->where('reference', 'LIKE', '%' . $request->search . '%');
        }

        if ($request->filled('date_from')) {
            $query->whereDate('created_at', '>=', $request->date_from);
        }

        if ($request->filled('date_to')) {
            $query->whereDate('created_at', '<=', $request->date_to);
        }
    }

    private function getTodayWithdrawals($query): array
    {
        return (clone $query)->whereDate('created_at', Carbon::today())
            ->selectRaw('HOUR(created_at) as label, SUM(amount) as total')
            ->groupBy('label')->pluck('total', 'label')->toArray();
    }

    private function getThisWeekWithdrawals($query): array
    {
        return (clone $query)->whereBetween('created_at', [Carbon::now()->startOfWeek(), Carbon::now()->endOfWeek()])
            ->selectRaw('DAYNAME(created_at) as label, DAYOFWEEK(created_at) as day_num, SUM(amount) as total')
            ->groupBy('label', 'day_num')->orderBy('day_num', 'ASC')->pluck('total', 'label')->toArray();
    }

    private function getThisMonthWithdrawals($query): array
    {
        return (clone $query)->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->selectRaw('DATE(created_at) as label, SUM(amount) as total')
            ->groupBy('label')->pluck('total', 'label')->toArray();
    }

    private function getThisYearWithdrawals($query): array
    {
        return (clone $query)->whereYear('created_at', Carbon::now()->year)
            ->selectRaw('MONTHNAME(created_at) as label, MONTH(created_at) as month_num, SUM(amount) as total')
            ->groupBy('label', 'month_num')->orderBy('month_num', 'ASC')->pluck('total', 'label')->toArray();
    }
}