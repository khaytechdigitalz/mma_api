<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AuditLogController extends Controller
{
    /**
     * Display a paginated listing of audit logs with filters.
     */
    public function index(Request $request)
    {
        // 1. Validate Input Filters
        $validator = Validator::make($request->all(), [
            'user_id'    => 'nullable|integer|exists:users,id',
            'user_type'  => 'nullable|string|in:admin,vendor,customer,guest',
            'action'     => 'nullable|string|max:100',
            'search'     => 'nullable|string|max:255',
            'start_date' => 'nullable|date_format:Y-m-d',
            'end_date'   => 'nullable|date_format:Y-m-d|after_or_equal:start_date',
            'per_page'   => 'nullable|integer|min:5|max:100',
            'sort_by'    => 'nullable|in:id,created_at,action,user_id',
            'sort_order' => 'nullable|in:asc,desc',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors in filter parameters',
                'errors'  => $validator->errors(),
            ], 422);
        }

        // 2. Build Query
        $query = AuditLog::with([
            'user:id,name,email,type'
        ]);

        // Filter by Specific User ID
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter by User Role/Type
        if ($request->filled('user_type')) {
            $query->where('user_type', $request->user_type);
        }

        // Filter by Exact Action Key (e.g., 'product.create') or Partial Action Match
        if ($request->filled('action')) {
            $query->where('action', 'LIKE', '%' . $request->action . '%');
        }

        // Search Filter (Matches description, IP address, user agent, or user name/email)
        if ($request->filled('search')) {
            $searchTerm = $request->search;
            $query->where(function ($q) use ($searchTerm) {
                $q->where('description', 'LIKE', "%{$searchTerm}%")
                  ->orWhere('ip_address', 'LIKE', "%{$searchTerm}%")
                  ->orWhere('action', 'LIKE', "%{$searchTerm}%")
                  ->orWhereHas('user', function ($userQuery) use ($searchTerm) {
                      $userQuery->where('name', 'LIKE', "%{$searchTerm}%")
                                ->orWhere('email', 'LIKE', "%{$searchTerm}%");
                  });
            });
        }

        // Date Range Filtering
        if ($request->filled('start_date')) {
            $query->whereDate('created_at', '>=', $request->start_date);
        }

        if ($request->filled('end_date')) {
            $query->whereDate('created_at', '<=', $request->end_date);
        }

        // Sorting
        $sortBy = $request->input('sort_by', 'created_at');
        $sortOrder = $request->input('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        // Pagination
        $perPage = $request->input('per_page', 15);
        $logs = $query->paginate($perPage);

        return response()->json([
            'status' => true,
            'data'   => $logs,
        ]);
    }

    /**
     * Display single audit log entry details.
     */
    public function show($id)
    {
        $log = AuditLog::with(['user:id,name,email,type'])->find($id);

        if (!$log) {
            return response()->json([
                'status'  => false,
                'message' => 'Audit log record not found',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $log,
        ]);
    }
}