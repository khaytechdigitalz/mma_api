<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\FlashSale;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FlashSaleController extends Controller
{
    /**
 * Get paginated flash sales list with metrics and batch-loaded product details (id, name).
 */
public function index(Request $request): JsonResponse
{
    // 1. Calculate overall metrics using Eloquent Model methods
    $metrics = [
        'total'    => FlashSale::count(),
        'active'   => FlashSale::where('is_active', true)->count(),
        'inactive' => FlashSale::where('is_active', false)->count(),
    ];

    // 2. Build filtered listing query
    $query = FlashSale::query();

    if ($request->filled('search')) {
        $query->where('title', 'LIKE', '%' . $request->search . '%');
    }

    if ($request->has('is_active')) {
        $query->where('is_active', $request->boolean('is_active'));
    }

    $flashSales = $query->latest()->paginate($request->get('per_page', 15));

    // 3. Collect all unique product IDs across current page items (Prevents N+1 queries)
    $allProductIds = collect($flashSales->items())
        ->pluck('product_ids')
        ->flatten()
        ->filter()
        ->unique()
        ->values();

    // 4. Query products in a single call selecting only id, name
    $products = Product::whereIn('id', $allProductIds)
        ->select('id', 'name')
        ->get()
        ->keyBy('id');

    // 5. Map retrieved products back to their respective flash sale item
    $flashSales->getCollection()->transform(function ($sale) use ($products) {
        $ids = is_array($sale->product_ids) ? $sale->product_ids : [];
        $sale->products = collect($ids)->map(fn ($id) => $products->get($id))->filter()->values();
        return $sale;
    });

    return response()->json([
        'status'  => true,
        'metrics' => $metrics,
        'data'    => $flashSales
    ]);
}


    /**
     * Create a new Flash Sale.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'         => 'required|string|max:150',
            'start_date'    => 'required|date',
            'end_date'      => 'required|date|after:start_date',
            'discount_type' => 'required|in:flat,percentage',
            'discount'      => 'required|numeric|min:0.01',
            'product_id'    => 'required|array|min:1',
            'product_id.*'  => 'integer|exists:products,id',
            'is_active'     => 'nullable|boolean',
        ]);

        $flashSale = FlashSale::create([
            'title'         => $validated['title'],
            'start_date'    => $validated['start_date'],
            'end_date'      => $validated['end_date'],
            'discount_type' => $validated['discount_type'],
            'discount'      => $validated['discount'],
            'product_ids'   => $validated['product_id'],
            'is_active'     => $validated['is_active'] ?? true,
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Flash Sale created successfully.',
            'data'    => $flashSale
        ], 201);
    }

    /**
     * Show single Flash Sale details with associated products.
     */
    public function show($id): JsonResponse
    {
        $flashSale = FlashSale::find($id);

        if (!$flashSale) {
            return response()->json(['status' => false, 'message' => 'Flash sale record not found.'], 404);
        }

        $ids = is_array($flashSale->product_ids) ? $flashSale->product_ids : [];
        $flashSale->products = Product::whereIn('id', $ids)->select('id', 'name')->get();

        return response()->json([
            'status' => true,
            'data'   => $flashSale
        ]);
    }

    /**
     * Update an existing Flash Sale.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $flashSale = FlashSale::find($id);

        if (!$flashSale) {
            return response()->json(['status' => false, 'message' => 'Flash sale record not found.'], 404);
        }

        $validated = $request->validate([
            'title'         => 'sometimes|required|string|max:150',
            'start_date'    => 'sometimes|required|date',
            'end_date'      => 'sometimes|required|date|after:start_date',
            'discount_type' => 'sometimes|required|in:flat,percentage',
            'discount'      => 'sometimes|required|numeric|min:0.01',
            'product_id'    => 'nullable|array',
            'product_id.*'  => 'integer|exists:products,id',
            'is_active'     => 'nullable|boolean',
        ]);

        if (array_key_exists('product_id', $validated)) {
            $validated['product_ids'] = $validated['product_id'];
            unset($validated['product_id']);
        }

        $flashSale->update($validated);

        return response()->json([
            'status'  => true,
            'message' => 'Flash sale updated successfully.',
            'data'    => $flashSale
        ]);
    }

    /**
     * Enable or Disable Flash Sale status.
     */
    public function toggleStatus($id): JsonResponse
    {
        $flashSale = FlashSale::find($id);

        if (!$flashSale) {
            return response()->json(['status' => false, 'message' => 'Flash sale record not found.'], 404);
        }

        $flashSale->update([
            'is_active' => !$flashSale->is_active
        ]);

        $statusLabel = $flashSale->is_active ? 'enabled' : 'disabled';

        return response()->json([
            'status'  => true,
            'message' => "Flash sale has been {$statusLabel} successfully.",
            'data'    => $flashSale
        ]);
    }

    /**
     * Delete a Flash Sale.
     */
    public function destroy($id): JsonResponse
    {
        $flashSale = FlashSale::find($id);

        if (!$flashSale) {
            return response()->json(['status' => false, 'message' => 'Flash sale record not found.'], 404);
        }

        $flashSale->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Flash sale deleted successfully.'
        ]);
    }
}