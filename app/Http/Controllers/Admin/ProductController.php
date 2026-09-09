<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Services\ImageUploadService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class ProductController extends Controller
{
    protected ImageUploadService $imageService;

    public function __construct(ImageUploadService $imageService)
    {
        $this->imageService = $imageService;
    }

    /**
     * Display a listing of products with filtering & pagination.
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id'     => 'nullable|integer|gt:0|exists:categories,id',
            'sub_category_id'     => 'nullable|integer|gt:0|exists:sub_categories,id',
            'brand_id'        => 'nullable|integer|gt:0|exists:brands,id',
            'seller_id'       => 'nullable|integer|gt:0|exists:users,id',
            'status'          => 'nullable|string|in:approved,pending,rejected',
            'published'       => 'nullable|boolean',
            'is_featured'     => 'nullable|boolean',
            'search'          => 'nullable|string|max:255',
            'per_page'        => 'nullable|integer|min:1|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors in query parameters',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $query = Product::with(['category:id,name,slug', 'subCategory:id,name,slug', 'brand:id,name', 'seller:id,name,email']);

        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->filled('sub_category_id')) {
            $query->where('sub_category_id', $request->sub_category_id);
        }

        if ($request->filled('brand_id')) {
            $query->where('brand_id', $request->brand_id);
        }

        if ($request->filled('seller_id')) {
            $query->where('seller_id', $request->seller_id);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('published')) {
            $query->where('published', filter_var($request->published, FILTER_VALIDATE_BOOLEAN));
        }

        if ($request->has('is_featured')) {
            $query->where('is_featured', filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN));
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'LIKE', "%{$search}%")
                  ->orWhere('sku', 'LIKE', "%{$search}%");
            });
        }

        $perPage = $request->input('per_page', 15);
        $products = $query->orderBy('id', 'desc')->paginate($perPage);
        $metrics['pending'] = $query->where('status', 'pending')->count();
        $metrics['approved'] = $query->where('status', 'approved')->count();
        $metrics['rejected'] = $query->where('status', 'rejected')->count();

        return response()->json([
            'status' => true,
            'metrics'   => $metrics,
            'data'   => $products,
        ]);
    }

    /**
     * Store a new product.
    */
    
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            // Relationships
            'seller_id'           => 'nullable|integer|gt:0|exists:users,id',
            'brand_id'            => 'nullable|integer|gt:0|exists:brands,id',
            'category_id'         => 'required|integer|gt:0|exists:categories,id',
            'sub_category_id'     => 'nullable|integer|gt:0|exists:sub_categories,id',

            // Basic Info
            'name'                => 'required|string|max:255',
            'sku'                 => 'required|string|max:100|unique:products,sku',
            'product_type'        => 'nullable|string|in:physical,digital',
            'unit'                => 'nullable|string|max:50',
            'tags'                => 'nullable|array',
            'tags.*'              => 'string',
            'short_description'   => 'nullable|string',
            'description'         => 'nullable|string',

            // Standalone Key-Value Attributes
            'attributes'          => 'nullable|array',
            'attributes.*'        => 'array',
            'attributes.*.*'      => 'integer|gt:0|exists:attribute_values,id',

            // Pricing & Tax
            'unit_price'          => 'required|numeric|min:0',
            'purchase_price'      => 'nullable|numeric|min:0',
            'tax'                 => 'nullable|numeric|min:0',
            'tax_type'            => 'nullable|string|in:percent,flat',
            'discount'            => 'nullable|numeric|min:0',
            'discount_type'       => 'nullable|string|in:percent,flat',

            // Stock & Inventory
            'current_stock'       => 'nullable|integer|min:0',
            'minimum_order_qty'   => 'nullable|integer|min:1',
            'low_stock_threshold' => 'nullable|integer|min:0',
            'stock_status'        => 'nullable|string|in:in_stock,out_of_stock,backorder',

            // Shipping
            'shipping_cost'       => 'nullable|numeric|min:0',
            'multiply_qty'        => 'nullable|boolean',

            // Flags & Status
            'is_featured'         => 'nullable|boolean',
            'is_todays_deal'      => 'nullable|boolean',
            'published'           => 'nullable|boolean',
            'status'              => 'nullable|string|in:approved,pending,rejected',
            'denied_reason'       => 'nullable|string',

            // Files & Images
            'thumbnail'           => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:3072',
            'gallery_images'      => 'nullable|array|max:5',
            'gallery_images.*'    => 'file|image|mimes:jpeg,png,jpg,webp|max:3072',
            'digital_file'        => 'nullable|file|mimes:pdf,zip,rar,mp3,mp4,epub|max:51200',
            'digital_file_type'   => 'nullable|string|max:50',

            // SEO Meta
            'meta_title'          => 'nullable|string|max:255',
            'meta_description'    => 'nullable|string',
            'meta_image'          => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $uploadedPaths = [];

        DB::beginTransaction();
        try {
            // 1. Upload Thumbnail
            $thumbnailPath = null;
            if ($request->hasFile('thumbnail')) {
                $thumbnailPath = $this->imageService->upload(
                    file: $request->file('thumbnail'),
                    folder: 'products/thumbnails',
                    width: 800,
                    height: 800
                );
                $uploadedPaths[] = $thumbnailPath;
            }

            // 2. Upload Gallery Images
            $galleryPaths = [];
            if ($request->hasFile('gallery_images')) {
                foreach ($request->file('gallery_images') as $galleryFile) {
                    $path = $this->imageService->upload(
                        file: $galleryFile,
                        folder: 'products/gallery',
                        width: 1200,
                        height: 1200
                    );
                    $galleryPaths[] = $path;
                    $uploadedPaths[] = $path;
                }
            }

            // 3. Upload Meta Image
            $metaImagePath = null;
            if ($request->hasFile('meta_image')) {
                $metaImagePath = $this->imageService->upload(
                    file: $request->file('meta_image'),
                    folder: 'products/meta',
                    width: 600,
                    height: 315
                );
                $uploadedPaths[] = $metaImagePath;
            }

            // 4. Handle Digital File
            $digitalFilePath = null;
            if ($request->hasFile('digital_file')) {
                $digitalFile = $request->file('digital_file');
                $digitalFilePath = $digitalFile->store('products/digital', 'public');
                $uploadedPaths[] = $digitalFilePath;
            }

            // 5. Create Product
            $product = Product::create([
                'seller_id'           => $request->seller_id,
                'brand_id'            => $request->brand_id,
                'category_id'         => $request->category_id,
                'sub_category_id'     => $request->sub_category_id,
                'name'                => $request->name,
                'slug'                => Str::slug($request->name) . '-' . Str::random(5),
                'sku'                 => $request->sku,
                'product_type'        => $request->product_type ?? 'physical',
                'unit'                => $request->unit,
                'tags'                => $request->tags ?? [],
                'short_description'   => $request->short_description,
                'description'         => $request->description,
                'thumbnail'           => $thumbnailPath,
                'images'              => $galleryPaths,
                'unit_price'          => $request->unit_price,
                'purchase_price'      => $request->purchase_price ?? 0,
                'tax'                 => $request->tax ?? 0,
                'tax_type'            => $request->tax_type ?? 'flat',
                'discount'            => $request->discount ?? 0,
                'discount_type'       => $request->discount_type ?? 'flat',
                'current_stock'       => $request->current_stock ?? 0,
                'minimum_order_qty'   => $request->minimum_order_qty ?? 1,
                'low_stock_threshold' => $request->low_stock_threshold ?? 5,
                'stock_status'        => $request->stock_status ?? 'in_stock',
                'shipping_cost'       => $request->shipping_cost ?? 0,
                'multiply_qty'        => $request->boolean('multiply_qty', false),
                'digital_file'        => $digitalFilePath,
                'digital_file_type'   => $request->digital_file_type,
                'is_featured'         => $request->boolean('is_featured', false),
                'is_todays_deal'      => $request->boolean('is_todays_deal', false),
                'published'           => $request->boolean('published', true),
                'status'              => $request->status ?? 'approved',
                'denied_reason'       => $request->denied_reason,
                'meta_title'          => $request->meta_title,
                'meta_description'    => $request->meta_description,
                'meta_image'          => $metaImagePath,
            ]);
 

            // 6. Save Key-Value Attributes to Product Variations
            if ($request->has('attributes') && is_array($request->attributes)) {
                foreach ($request->attributes as $attributeId => $valueIds) {
                    $product->variations()->create([
                        'attribute_id'        => $attributeId,
                        'attribute_value_ids' => is_array($valueIds) ? $valueIds : [],
                    ]);
                }
            }

            audit_log(
                action: 'product.create',
                description: "Created product '{$product->name}' (ID: {$product->id})",
                oldValues: null,
                newValues: $product->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Product created successfully',
                'data'    => $product->load(['category', 'subCategory', 'brand', 'seller', 'variations']),
            ], 201);

        } catch (\Throwable $e) {
            DB::rollBack();

            foreach ($uploadedPaths as $path) {
                $this->imageService->delete($path);
            }

            return response()->json([
                'status'  => false,
                'message' => 'Failed to create product: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Display single product details.
     */
    public function show($id)
    {
        $product = Product::with(['category', 'subCategory', 'brand', 'seller', 'variations.attribute'])->find($id);

        if (!$product) {
            return response()->json([
                'status'  => false,
                'message' => 'Product not found',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $product,
        ]);
    }

    /**
     * Update an existing product.
     */
    public function update(Request $request, $id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status'  => false,
                'message' => 'Product not found',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'seller_id'           => 'nullable|integer|gt:0|exists:users,id',
            'brand_id'            => 'nullable|integer|gt:0|exists:brands,id',
            'category_id'         => 'nullable|integer|gt:0|exists:categories,id',
            'sub_category_id'     => 'nullable|integer|gt:0|exists:sub_categories,id',

            'name'                => 'sometimes|required|string|max:255',
            'sku'                 => ['sometimes', 'required', 'string', 'max:100', Rule::unique('products', 'sku')->ignore($id)],
            'product_type'        => 'nullable|string|in:physical,digital',
            'unit'                => 'nullable|string|max:50',
            'tags'                => 'nullable|array',
            'tags.*'              => 'string',
            'short_description'   => 'nullable|string',
            'description'         => 'nullable|string',

            // Variations payload: array of objects containing attribute_id & attribute_value_ids
            'variations'                       => 'nullable|array',
            'variations.*.attribute_id'        => 'required_with:variations|integer|gt:0|exists:attributes,id',
            'variations.*.attribute_value_ids' => 'required_with:variations|array',
            'variations.*.attribute_value_ids.*' => 'integer|gt:0|exists:attribute_values,id',

            'unit_price'          => 'nullable|numeric|min:0',
            'purchase_price'      => 'nullable|numeric|min:0',
            'tax'                 => 'nullable|numeric|min:0',
            'tax_type'            => 'nullable|string|in:percent,flat',
            'discount'            => 'nullable|numeric|min:0',
            'discount_type'       => 'nullable|string|in:percent,flat',

            'current_stock'       => 'nullable|integer|min:0',
            'minimum_order_qty'   => 'nullable|integer|min:1',
            'low_stock_threshold' => 'nullable|integer|min:0',
            'stock_status'        => 'nullable|string|in:in_stock,out_of_stock,backorder',

            'shipping_cost'       => 'nullable|numeric|min:0',
            'multiply_qty'        => 'nullable|boolean',

            'is_featured'         => 'nullable|boolean',
            'is_todays_deal'      => 'nullable|boolean',
            'published'           => 'nullable|boolean',
            'status'              => 'nullable|string|in:approved,pending,rejected',
            'denied_reason'       => 'nullable|string',

            'thumbnail'           => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:3072',
            'gallery_images'      => 'nullable|array|max:10',
            'gallery_images.*'    => 'file|image|mimes:jpeg,png,jpg,webp|max:3072',
            'remove_gallery_paths'=> 'nullable|array',
            'remove_gallery_paths.*' => 'string',

            'digital_file'        => 'nullable|file|mimes:pdf,zip,rar,mp3,mp4,epub|max:51200',
            'digital_file_type'   => 'nullable|string|max:50',

            'meta_title'          => 'nullable|string|max:255',
            'meta_description'    => 'nullable|string',
            'meta_image'          => 'nullable|file|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation errors',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $oldState = $product->load('variations')->toArray();
        $newlyUploadedPaths = [];

        DB::beginTransaction();
        try {
            // Update Thumbnail
            if ($request->hasFile('thumbnail')) {
                if ($product->thumbnail) {
                    $this->imageService->delete($product->thumbnail);
                }
                $thumbnailPath = $this->imageService->upload(
                    file: $request->file('thumbnail'),
                    folder: 'products/thumbnails',
                    width: 800,
                    height: 800
                );
                $newlyUploadedPaths[] = $thumbnailPath;
                $product->thumbnail = $thumbnailPath;
            }

            // Update Gallery Images
            $currentGallery = $product->images ?? [];

            // Remove requested gallery paths
            if ($request->filled('remove_gallery_paths')) {
                foreach ($request->remove_gallery_paths as $pathToRemove) {
                    $this->imageService->delete($pathToRemove);
                    $currentGallery = array_values(array_filter($currentGallery, fn($p) => $p !== $pathToRemove));
                }
            }

            // Append new gallery images
            if ($request->hasFile('gallery_images')) {
                foreach ($request->file('gallery_images') as $galleryFile) {
                    $path = $this->imageService->upload(
                        file: $galleryFile,
                        folder: 'products/gallery',
                        width: 1200,
                        height: 1200
                    );
                    $currentGallery[] = $path;
                    $newlyUploadedPaths[] = $path;
                }
            }
            $product->images = $currentGallery;

            // Update Meta Image
            if ($request->hasFile('meta_image')) {
                if ($product->meta_image) {
                    $this->imageService->delete($product->meta_image);
                }
                $metaImagePath = $this->imageService->upload(
                    file: $request->file('meta_image'),
                    folder: 'products/meta',
                    width: 600,
                    height: 315
                );
                $newlyUploadedPaths[] = $metaImagePath;
                $product->meta_image = $metaImagePath;
            }

            // Update Digital File
            if ($request->hasFile('digital_file')) {
                if ($product->digital_file) {
                    $this->imageService->delete($product->digital_file);
                }
                $digitalFile = $request->file('digital_file');
                $product->digital_file = $digitalFile->store('products/digital', 'public');
                $newlyUploadedPaths[] = $product->digital_file;
            }

            // Slug update on name change
            if ($request->filled('name') && $request->name !== $product->name) {
                $product->name = $request->name;
                $product->slug = Str::slug($request->name) . '-' . Str::random(5);
            }

            // Update general fields
            $fields = [
                'seller_id', 'brand_id', 'category_id', 'sub_category_id', 'sku', 'product_type',
                'unit', 'tags', 'short_description', 'description', 'unit_price', 'purchase_price',
                'tax', 'tax_type', 'discount', 'discount_type', 'current_stock', 'minimum_order_qty',
                'low_stock_threshold', 'stock_status', 'shipping_cost', 'digital_file_type', 
                'status', 'denied_reason', 'meta_title', 'meta_description'
            ];

            foreach ($fields as $field) {
                if ($request->has($field)) {
                    $product->$field = $request->$field;
                }
            }

            // Update booleans
            $booleans = ['multiply_qty', 'is_featured', 'is_todays_deal', 'published'];
            foreach ($booleans as $booleanField) {
                if ($request->has($booleanField)) {
                    $product->$booleanField = $request->boolean($booleanField);
                }
            }

            $product->save();

            // Sync Variations
            if ($request->has('variations')) {
                $product->variations()->delete();

                if (is_array($request->variations)) {
                    foreach ($request->variations as $variation) {
                        $product->variations()->create([
                            'attribute_id'        => $variation['attribute_id'],
                            'attribute_value_ids' => $variation['attribute_value_ids'] ?? [],
                        ]);
                    }
                }
            }

            audit_log(
                action: 'product.update',
                description: "Updated product '{$product->name}' (ID: {$product->id})",
                oldValues: $oldState,
                newValues: $product->fresh()->load('variations')->toArray()
            );

            DB::commit();

            return response()->json([
                'status'  => true,
                'message' => 'Product updated successfully',
                'data'    => $product->fresh()->load(['category', 'subCategory', 'brand', 'seller', 'variations']),
            ]);

        } catch (\Throwable $e) {
            DB::rollBack();

            foreach ($newlyUploadedPaths as $path) {
                $this->imageService->delete($path);
            }

            return response()->json([
                'status'  => false,
                'message' => 'Failed to update product: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete product (supports Soft Deletes) and optionally clean media.
     */
    public function destroy($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status'  => false,
                'message' => 'Product not found',
            ], 404);
        }

        $oldProductState = $product->toArray();

        // Perform Soft Delete
        $product->delete();

        audit_log(
            action: 'product.delete',
            description: "Soft deleted product '{$product->name}' (ID: {$id})",
            oldValues: $oldProductState,
            newValues: null
        );

        return response()->json([
            'status'  => true,
            'message' => 'Product deleted successfully',
        ]);
    }

    /**
     * Toggle product publish status and optionally clean media.
     */
    public function updatePublished($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'status'  => false,
                'message' => 'Product not found',
            ], 404);
        }

        $oldProductState = $product->toArray();

        // Toggle the published state (1 becomes 0, 0 becomes 1)
        $product->published = $product->published == 1 ? 0 : 1;
        $product->save();

        $actionText = $product->published ? 'published' : 'unpublished';

        audit_log(
            action: "product.{$actionText}",
            description: ucfirst($actionText) . " product '{$product->name}' (ID: {$id})",
            oldValues: $oldProductState,
            newValues: $product->toArray()
        );

        return response()->json([
            'status'  => true,
            'message' => "Product {$actionText} successfully",
            'published' => $product->published,
        ]);
    }
    
}