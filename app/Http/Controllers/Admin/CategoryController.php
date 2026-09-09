<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Validation\Rule;
use App\Services\ImageUploadService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    protected ImageUploadService $imageService;

    public function __construct(ImageUploadService $imageService)
    {
        $this->imageService = $imageService;
    }

    /**
     * Display a listing of categories (with filtering & search).
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'parent_id' => 'nullable|integer',
            'search'    => 'nullable|string|max:255',
            'status'    => 'nullable|boolean',
            'per_page'  => 'nullable|integer|min:1|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors in query parameters',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $query = Category::withCount('products');

        // Filter by parent (0 or null for top-level categories)
        if ($request->has('parent_id')) {
            $query->where('parent_id', $request->parent_id);
        }

        // Active/Inactive Filter
        if ($request->has('status')) {
            $query->where('is_active', filter_var($request->status, FILTER_VALIDATE_BOOLEAN));
        }

        // Search Filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'LIKE', "%{$search}%")
                  ->orWhere('slug', 'LIKE', "%{$search}%");
            });
        }

        $perPage = $request->input('per_page', 15);
        $categories = $query->orderBy('priority', 'asc')->orderBy('name', 'asc')->paginate($perPage);

        return response()->json([
            'status' => true,
            'data'   => $categories,
        ]);
    }

    /**
     * Display single category details.
     */
    public function show($id)
    {
        $category = Category::withCount('products')
            ->where('id', $id)
            ->orWhere('slug', $id)
            ->first();

        if (!$category) {
            return response()->json([
                'status'  => false,
                'message' => 'Category not found',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $category,
        ]);
    }

    /**
     * Store a new category.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'parent_id' => [
                'nullable',
                'integer',
                'min:0',
                Rule::when(fn ($input) => (int) $input->parent_id > 0, [
                    'exists:categories,id',
                ]),
            ],
            'name'             => 'required|string|max:255|unique:categories,name',
            'icon'             => 'nullable|file|image|mimes:jpeg,png,jpg,webp,svg|max:2048',
            'banner'           => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:2048',
            'priority'         => 'nullable|integer|min:0',
            'status'         => 'nullable|boolean',
            'meta_title'       => 'nullable|string|max:255',
            'meta_description' => 'nullable|string',
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
            $iconPath = null;
            $bannerPath = null;

            if ($request->hasFile('icon')) {
                $iconPath = $this->imageService->upload(
                    file: $request->file('icon'),
                    folder: 'categories/icons',
                    width: 200,
                    height: 200
                );
            }

            if ($request->hasFile('banner')) {
                $bannerPath = $this->imageService->upload(
                    file: $request->file('banner'),
                    folder: 'categories/banners',
                    width: 1200,
                    height: 400
                );
            }

            $category = Category::create([
                'name'             => $request->name,
                'slug'             => Str::slug($request->name),
                'icon'             => $iconPath,
                'banner'           => $bannerPath,
                'priority'         => $request->priority ?? 0,
                'status'         => $request->boolean('status', true),
                'meta_title'       => $request->meta_title,
                'meta_description' => $request->meta_description,
            ]);

            audit_log(
                action: 'category.create',
                description: "Created category '{$category->name}' (ID: {$category->id})",
                oldValues: null,
                newValues: $category->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Category created successfully',
                'data'    => $category,
            ], 201);

        } catch (\Throwable $e) {
            DB::rollBack();
            if (isset($iconPath)) $this->imageService->delete($iconPath);
            if (isset($bannerPath)) $this->imageService->delete($bannerPath);

            return response()->json([
                'status'  => false,
                'message' => 'Failed to create category: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update an existing category.
     */
    public function update(Request $request, $id)
    {
        $category = Category::find($id);

        if (!$category) {
            return response()->json([
                'status'  => false,
                'message' => 'Category not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'parent_id'        => 'nullable|exists:categories,id|not_in:' . $id,
            'name'             => 'sometimes|required|string|max:255|unique:categories,name,' . $id,
            'icon'             => 'nullable|file|image|mimes:jpeg,png,jpg,webp,svg|max:2048',
            'banner'           => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:2048',
            'priority'         => 'nullable|integer|min:0',
            'status'           => 'nullable',
            'meta_title'       => 'nullable|string|max:255',
            'meta_description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $oldCategoryState = $category->toArray();

        DB::beginTransaction();
        try {
            if ($request->hasFile('icon')) {
                if ($category->icon) {
                    $this->imageService->delete($category->icon);
                }
                $category->icon = $this->imageService->upload(
                    file: $request->file('icon'),
                    folder: 'categories/icons',
                    width: 200,
                    height: 200
                );
            }

            if ($request->hasFile('banner')) {
                if ($category->banner) {
                    $this->imageService->delete($category->banner);
                }
                $category->banner = $this->imageService->upload(
                    file: $request->file('banner'),
                    folder: 'categories/banners',
                    width: 1200,
                    height: 400
                );
            }

            if ($request->has('name') && $request->name !== $category->name) {
                $category->name = $request->name;
                $category->slug = Str::slug($request->name);
            }

            $fields = ['parent_id', 'priority', 'meta_title', 'meta_description'];
            foreach ($fields as $field) {
                if ($request->has($field)) {
                    $category->$field = $request->$field;
                }
            }

            if ($request->has('status')) {
                $category->status = $request->status;
            }

            $category->save();

            audit_log(
                action: 'category.update',
                description: "Updated category '{$category->name}' (ID: {$category->id})",
                oldValues: $oldCategoryState,
                newValues: $category->fresh()->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Category updated successfully',
                'data'    => $category->fresh(),
            ]);

        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'status'  => false,
                'message' => 'Failed to update category: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete a category.
     */
    public function destroy($id)
    {
        $category = Category::find($id);

        if (!$category) {
            return response()->json([
                'status'  => false,
                'message' => 'Category not found',
            ], 404);
        }

        // Check if category has subcategories or products linked
        $hasChildren = $category->subCategories()->exists();
        $hasProducts = $category->products()->exists();

        if ($hasChildren || $hasProducts) {
            return response()->json([
                'status'  => false,
                'message' => 'Cannot delete category containing linked subcategories or products. Remove or reassign them first.',
            ], 422);
        }

        $oldCategoryState = $category->toArray();
        $categoryName = $category->name;

        if ($category->icon) {
            $this->imageService->delete($category->icon);
        }
        if ($category->banner) {
            $this->imageService->delete($category->banner);
        }

        $category->delete();

        audit_log(
            action: 'category.delete',
            description: "Deleted category '{$categoryName}' (ID: {$id})",
            oldValues: $oldCategoryState,
            newValues: null
        );

        return response()->json([
            'status'  => true,
            'message' => 'Category deleted successfully',
        ]);
    }
}