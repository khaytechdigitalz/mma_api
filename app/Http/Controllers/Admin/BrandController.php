<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Brand;
use App\Services\ImageUploadService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Exception;

class BrandController extends Controller
{
    protected ImageUploadService $imageService;

    public function __construct(ImageUploadService $imageService)
    {
        $this->imageService = $imageService;
    }

    /**
     * Display a listing of brands.
     */
    public function index(): JsonResponse
    {
        $brands = Brand::latest()->paginate(15);

        return response()->json([
            'status' => 'success',
            'data'   => $brands
        ]);
    }

    /**
     * Store a newly created brand in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name'        => 'required|string|max:255|unique:brands,name',
            'description' => 'nullable|string',
            'logo'        => 'nullable|image|mimes:jpeg,png,jpg,webp,gif|max:4096',
            'status'   => 'nullable|string',
        ]);

        $logoPath = null;

        // Handle logo upload via ImageUploadService targeting 'brands' folder
        if ($request->hasFile('logo')) {
            try {
                $logoPath = $this->imageService->upload(
                    file: $request->file('logo'),
                    folder: 'brands',
                    width: 400,
                    height: 400
                );
            } catch (Exception $e) {
                return response()->json([
                    'status'  => 'error',
                    'message' => 'Failed to upload brand logo: ' . $e->getMessage()
                ], 422);
            }
        }

        $brand = Brand::create([
            'name'        => $validated['name'],
            'slug'        => Str::slug($validated['name']),
            'description' => $validated['description'] ?? null,
            'logo'        => $logoPath,
            'status'   => $validated['status'],
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Brand created successfully',
            'data'    => $brand
        ], 201);
    }

    /**
     * Display the specified brand.
     */
    public function show(Brand $brand): JsonResponse
    {
        return response()->json([
            'status' => 'success',
            'data'   => $brand
        ]);
    }

    /**
     * Update the specified brand in storage.
     */
    public function update(Request $request, Brand $brand): JsonResponse
    {
        $validated = $request->validate([
            'name'        => 'sometimes|required|string|max:255|unique:brands,id,' . $brand->id,
            'description' => 'nullable|string',
            'logo'        => 'nullable|image|mimes:jpeg,png,jpg,webp,gif|max:4096',
            'status'   => 'nullable',
        ]);

        // Process logo update
        if ($request->hasFile('logo')) {
            try {
                // Delete old logo if existing
                if ($brand->logo) {
                    $this->imageService->delete($brand->logo);
                }

                // Upload new logo to 'brands' folder
                $validated['logo'] = $this->imageService->upload(
                    file: $request->file('logo'),
                    folder: 'brands',
                    width: 400,
                    height: 400
                );
            } catch (Exception $e) {
                return response()->json([
                    'status'  => 'error',
                    'message' => 'Failed to upload brand logo: ' . $e->getMessage()
                ], 422);
            }
        }

        if (isset($validated['name'])) {
            $validated['slug'] = Str::slug($validated['name']);
        }

        $brand->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Brand updated successfully',
            'data'    => $brand
        ]);
    }

    /**
     * Remove the specified brand from storage.
     */
    public function destroy(Brand $brand): JsonResponse
    {
        // Delete image file from storage if present
        if ($brand->logo) {
            $this->imageService->delete($brand->logo);
        }

        $brand->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Brand deleted successfully'
        ]);
    }
}