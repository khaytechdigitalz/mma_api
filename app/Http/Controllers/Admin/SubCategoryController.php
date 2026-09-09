<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\SubCategory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class SubCategoryController extends Controller
{
    /**
     * List all subcategories (or filter by category_id).
     */
    public function index(Request $request)
{
    // Sanitize query inputs: Convert empty strings ("") or whitespace-only inputs to null
    $inputs = array_map(function ($value) {
        return is_string($value) && trim($value) === '' ? null : $value;
    }, $request->all());

    $validator = Validator::make($inputs, [
        'category_id' => 'nullable|integer|gt:0|exists:categories,id',
        'status'      => 'nullable|in:active,inactive',
        'search'      => 'nullable|string|max:255',
        'per_page'    => 'nullable|integer|min:1|max:100',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'status'  => false,
            'message' => 'Validation errors in query parameters',
            'errors'  => $validator->errors(),
        ], 422);
    }

    $query = SubCategory::with(['category:id,name,slug']);

    // Check directly against sanitized inputs array
    if (!empty($inputs['category_id'])) {
        $query->where('category_id', $inputs['category_id']);
    }

    if (isset($inputs['status'])) {
        $query->where('status', $inputs['status']);
    }

    if (!empty($inputs['search'])) {
        $query->where('name', 'LIKE', "%{$inputs['search']}%");
    }

    $perPage = $inputs['per_page'] ?? 15;
    $subCategories = $query->orderBy('priority', 'asc')->orderBy('id', 'desc')->paginate($perPage);

    return response()->json([
        'status' => true,
        'data'   => $subCategories,
    ]);
}

    /**
     * Store a new subcategory linked to a Category.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|integer|gt:0|exists:categories,id',
            'name'        => 'required|string|max:255',
            'priority'    => 'nullable|integer|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        DB::beginTransaction();
        try {
            $subCategory = SubCategory::create([
                'category_id' => $request->category_id,
                'name'        => $request->name,
                'slug'        => Str::slug($request->name) . '-' . Str::random(4),
                'priority'    => $request->priority ?? 0,
                'status'      => $request->status,
            ]);

            audit_log(
                action: 'subcategory.create',
                description: "Created subcategory '{$subCategory->name}' (ID: {$subCategory->id}) under Category ID {$subCategory->category_id}",
                oldValues: null,
                newValues: $subCategory->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Subcategory created successfully',
                'data'    => $subCategory->load('category'),
            ], 201);

        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to create subcategory: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Show single subcategory details.
     */
    public function show($id)
    {
        $subCategory = SubCategory::with('category')->find($id);

        if (!$subCategory) {
            return response()->json([
                'status'  => false,
                'message' => 'Subcategory not found',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $subCategory,
        ]);
    }

    /**
     * Update an existing subcategory.
     */
    public function update(Request $request, $id)
    {
        $subCategory = SubCategory::find($id);

        if (!$subCategory) {
            return response()->json([
                'status'  => false,
                'message' => 'Subcategory not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'category_id' => 'nullable|integer|gt:0|exists:categories,id',
            'name'        => 'sometimes|required|string|max:255',
            'priority'    => 'nullable|integer|min:0',
            'status'      => 'nullable',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $oldState = $subCategory->toArray();

        DB::beginTransaction();
        try {
            if ($request->filled('category_id')) {
                $subCategory->category_id = $request->category_id;
            }

            if ($request->filled('name') && $request->name !== $subCategory->name) {
                $subCategory->name = $request->name;
                $subCategory->slug = Str::slug($request->name) . '-' . Str::random(4);
            }

            if ($request->has('priority')) {
                $subCategory->priority = $request->priority;
            }

            if ($request->has('status')) {
                $subCategory->status = $request->status;
            }

            $subCategory->save();

            audit_log(
                action: 'subcategory.update',
                description: "Updated subcategory '{$subCategory->name}' (ID: {$id})",
                oldValues: $oldState,
                newValues: $subCategory->fresh()->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Subcategory updated successfully',
                'data'    => $subCategory->fresh()->load('category'),
            ]);

        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to update subcategory: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete a subcategory.
     */
    public function destroy($id)
    {
        $subCategory = SubCategory::find($id);

        if (!$subCategory) {
            return response()->json([
                'status'  => false,
                'message' => 'Subcategory not found',
            ], 404);
        }

        // Check if products exist on this subcategory before deleting
        if (method_exists($subCategory, 'products') && $subCategory->products()->exists()) {
            return response()->json([
                'status'  => false,
                'message' => 'Cannot delete subcategory linked to active products. Reassign products first.',
            ], 422);
        }

        $oldState = $subCategory->toArray();
        $subCategory->delete();

        audit_log(
            action: 'subcategory.delete',
            description: "Deleted subcategory '{$oldState['name']}' (ID: {$id})",
            oldValues: $oldState,
            newValues: null
        );

        return response()->json([
            'status'  => true,
            'message' => 'Subcategory deleted successfully',
        ]);
    }
}