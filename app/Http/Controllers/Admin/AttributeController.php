<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Attribute;
use App\Models\AttributeValue;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class AttributeController extends Controller
{
    /**
     * List all attributes with optional search and values.
     */
    public function index(Request $request)
    {
        $inputs = array_map(function ($value) {
            return is_string($value) && trim($value) === '' ? null : $value;
        }, $request->all());

        $validator = Validator::make($inputs, [
            'search'    => 'nullable|string|max:255',
            'type'      => 'nullable|string|in:select,radio,text,color',
            'per_page'  => 'nullable|integer|min:1|max:100',
            'with_vals' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors in query parameters',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $query = Attribute::query();

        if (filter_var($inputs['with_vals'] ?? true, FILTER_VALIDATE_BOOLEAN)) {
            $query->with(['values' => function ($q) {
                $q->orderBy('id', 'asc');
            }]);
        }

        if (!empty($inputs['search'])) {
            $query->where('name', 'LIKE', "%{$inputs['search']}%");
        }

        if (!empty($inputs['type'])) {
            $query->where('type', $inputs['type']);
        }

        $perPage = $inputs['per_page'] ?? 15;
        $attributes = $query->orderBy('id', 'desc')->paginate($perPage);

        return response()->json([
            'status' => true,
            'data'   => $attributes,
        ]);
    }

    /**
     * Store a new attribute with optional initial values.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'           => 'required|string|max:255|unique:attributes,name',
            'type'           => 'nullable|string|in:select,radio,text,color,checkbox',
            'values'         => 'nullable|array',
            'values.*.value' => 'required_with:values|string|max:255',
            'values.*.code'  => 'nullable|string|max:50',  
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
            $attribute = Attribute::create([
                'name'          => $request->name,
                'slug'          => Str::slug($request->name),
                'type'          => $request->type ?? 'select',
            ]);

            // Save initial values if provided
            if ($request->filled('values')) {
                foreach ($request->values as $index => $val) {
                    $attribute->values()->create([
                        'value'      => $val['value'],
                        'slug'       => Str::slug($val['value']),
                        'code'       => $val['code'] ?? null,
                        'sort_order' => $val['sort_order'] ?? $index,
                    ]);
                }
            }

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Attribute created successfully',
                'data'    => $attribute->load('values'),
            ], 201);

        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to create attribute: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Show single attribute and its values.
     */
    public function show($id)
    {
        $attribute = Attribute::with('values')->find($id);

        if (!$attribute) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute not found',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $attribute,
        ]);
    }

   /**
     * Update an attribute.
     */
    public function update(Request $request, $id)
    {
        $attribute = Attribute::find($id);

        if (!$attribute) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name'             => ['sometimes', 'required', 'string', 'max:255', Rule::unique('attributes', 'name')->ignore($id)],
            'type'             => 'nullable|string|in:select,radio,text,color,checkbox',
            'values'           => 'nullable|array',
            'values.*.value'   => 'required|string|max:255',
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
            if ($request->filled('name') && $request->name !== $attribute->name) {
                $attribute->name = $request->name;
                $attribute->slug = Str::slug($request->name);
            }

            if ($request->filled('type')) {
                $attribute->type = $request->type;
            }

            $attribute->save();

            // Sync or update attribute values if provided
            if ($request->has('values')) {
                $incomingValues = collect($request->input('values'))->pluck('value')->filter()->unique();

                // Get existing values for this attribute
                $existingValues = $attribute->values;

                // Values to delete (present in DB but not in the incoming request)
                $incomingValuesArray = $incomingValues->toArray();
                $existingValues->each(function ($item) use ($incomingValuesArray) {
                    if (!in_array($item->value, $incomingValuesArray)) {
                        $item->delete();
                    }
                });

                // Values to add or keep
                foreach ($incomingValues as $val) {
                    $attribute->values()->firstOrCreate(['value' => $val]);
                }
            }

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Attribute updated successfully',
                'data'    => $attribute->load('values'),
            ]);

        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to update attribute: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete an attribute and its associated values.
     */
    public function destroy($id)
    {
        $attribute = Attribute::find($id);

        if (!$attribute) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute not found',
            ], 404);
        }

        // Check if attached to active products before deletion
        if (method_exists($attribute, 'products') && $attribute->products()->exists()) {
            return response()->json([
                'status'  => false,
                'message' => 'Cannot delete attribute assigned to existing products.',
            ], 422);
        }

        DB::beginTransaction();
        try {
            $attribute->values()->delete();
            $attribute->delete();

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Attribute and its values deleted successfully',
            ]);
        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to delete attribute: ' . $e->getMessage(),
            ], 500);
        }
    }

    // ==========================================
    // ATTRIBUTE VALUES ENDPOINTS
    // ==========================================

    /**
     * Add a value to an existing attribute.
     */
    public function storeValue(Request $request, $attributeId)
    {
        $attribute = Attribute::find($attributeId);

        if (!$attribute) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'value'      => 'required|string|max:255',
            'code'       => 'nullable|string|max:50',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $value = $attribute->values()->create([
            'value'      => $request->value,
            'slug'       => Str::slug($request->value),
            'code'       => $request->code ?? null,
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Attribute value added successfully',
            'data'    => $value,
        ], 201);
    }

    /**
     * Update an attribute value.
     */
    public function updateValue(Request $request, $attributeId, $valueId)
    {
        $value = AttributeValue::where('attribute_id', $attributeId)->find($valueId);

        if (!$value) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute value not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'value'      => 'sometimes|required|string|max:255',
            'code'       => 'nullable|string|max:50',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        if ($request->filled('value') && $request->value !== $value->value) {
            $value->value = $request->value;
        }

        if ($request->has('code')) {
            $value->code = $request->code;
        }
 
        $value->save();

        return response()->json([
            'status'  => true,
            'message' => 'Attribute value updated successfully',
            'data'    => $value,
        ]);
    }

    /**
     * Delete an attribute value.
     */
    public function destroyValue($attributeId, $valueId)
    {
        $value = AttributeValue::where('attribute_id', $attributeId)->find($valueId);

        if (!$value) {
            return response()->json([
                'status'  => false,
                'message' => 'Attribute value not found',
            ], 404);
        }

        $value->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Attribute value deleted successfully',
        ]);
    }
}