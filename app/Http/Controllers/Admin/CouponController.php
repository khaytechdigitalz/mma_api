<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Coupon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
   use Illuminate\Support\Carbon;

class CouponController extends Controller
{

/**
 * Get paginated coupon list with optional search/status filters and summary metrics.
 */
public function index(Request $request): JsonResponse
{
    $now = Carbon::now();

    // 1. Calculate overall metrics using Eloquent query builder methods
    $metrics = [
        'total'    => Coupon::count(),
        'active'   => Coupon::where('is_active', true)
                            ->where(function ($q) use ($now) {
                                $q->whereNull('end_date')
                                  ->orWhere('end_date', '>=', $now);
                            })
                            ->count(),
        'inactive' => Coupon::where('is_active', false)->count(),
        'expired'  => Coupon::whereNotNull('end_date')
                            ->where('end_date', '<', $now)
                            ->count(),
    ];

    // 2. Build filtered listing query
    $query = Coupon::query();

    if ($request->filled('search')) {
        $query->where(function ($q) use ($request) {
            $q->where('name', 'LIKE', '%' . $request->search . '%')
              ->orWhere('code', 'LIKE', '%' . $request->search . '%');
        });
    }

    if ($request->has('is_active')) {
        $query->where('is_active', $request->boolean('is_active'));
    }

    // 3. Paginate filtered results
    $coupons = $query->latest()->paginate($request->get('per_page', 15));

    return response()->json([
        'status'  => true,
        'metrics' => $metrics,
        'data'    => $coupons
    ]);
}
    /**
     * Create a new coupon.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:150',
            'code'          => 'required|string|max:50|unique:coupons,code',
            'discount_type' => 'required|in:flat,percentage',
            'discount'      => 'required|numeric|min:0.01',
            'start_date'    => 'required|date',
            'end_date'      => 'required|date|after_or_equal:start_date',
            'product_id'    => 'nullable|array',
            'product_id.*'  => 'integer|exists:products,id',
            'is_active'     => 'nullable|boolean'
        ]);

        $coupon = Coupon::create([
            'name'          => $validated['name'],
            'code'          => strtoupper($validated['code']),
            'discount_type' => $validated['discount_type'],
            'discount'      => $validated['discount'],
            'start_date'    => $validated['start_date'],
            'end_date'      => $validated['end_date'],
            'product_ids'   => $validated['product_id'] ?? [],
            'is_active'     => $validated['is_active'] ?? true,
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Coupon created successfully.',
            'data'    => $coupon
        ], 201);
    }

    /**
     * Get single coupon details.
     */
    public function show($id): JsonResponse
    {
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['status' => false, 'message' => 'Coupon not found.'], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $coupon
        ]);
    }

    /**
     * Update an existing coupon.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['status' => false, 'message' => 'Coupon not found.'], 404);
        }

        $validated = $request->validate([
            'name'          => 'sometimes|required|string|max:150',
            'code'          => ['sometimes', 'required', 'string', 'max:50', Rule::unique('coupons', 'code')->ignore($coupon->id)],
            'discount_type' => 'sometimes|required|in:flat,percentage',
            'discount'      => 'sometimes|required|numeric|min:0.01',
            'start_date'    => 'sometimes|required|date',
            'end_date'      => 'sometimes|required|date|after_or_equal:start_date',
            'product_id'    => 'nullable|array',
            'product_id.*'  => 'integer|exists:products,id',
            'is_active'     => 'nullable|boolean'
        ]);

        if (isset($validated['code'])) {
            $validated['code'] = strtoupper($validated['code']);
        }

        if (array_key_exists('product_id', $validated)) {
            $validated['product_ids'] = $validated['product_id'];
            unset($validated['product_id']);
        }

        $coupon->update($validated);

        return response()->json([
            'status'  => true,
            'message' => 'Coupon updated successfully.',
            'data'    => $coupon
        ]);
    }

    /**
     * Enable or Disable coupon status.
     */
    public function toggleStatus($id): JsonResponse
    {
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['status' => false, 'message' => 'Coupon not found.'], 404);
        }

        $coupon->update([
            'is_active' => !$coupon->is_active
        ]);

        $statusLabel = $coupon->is_active ? 'enabled' : 'disabled';

        return response()->json([
            'status'  => true,
            'message' => "Coupon has been {$statusLabel} successfully.",
            'data'    => $coupon
        ]);
    }

    /**
     * Delete a coupon.
     */
    public function destroy($id): JsonResponse
    {
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['status' => false, 'message' => 'Coupon not found.'], 404);
        }

        $coupon->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Coupon deleted successfully.'
        ]);
    }
}