<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\FrontendContent;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class FrontendContentController extends Controller
{
    /**
     * Get list of landing page components with optional filtering.
     */
    public function index(Request $request): JsonResponse
    {
        $query = FrontendContent::query();

        if ($request->filled('component')) {
            $query->where('component', $request->component);
        }

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('status')) {
            $query->where('status', $request->boolean('status'));
        }

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('slug', 'LIKE', '%' . $request->search . '%')
                  ->orWhere('value', 'LIKE', '%' . $request->search . '%');
            });
        }

        $contents = $query->latest()->paginate($request->get('per_page', 15));

        return response()->json([
            'status' => true,
            'data'   => $contents
        ]);
    }

   /**
     * Add a new landing page component item.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'component'     => 'required|in:slider,banner,faq,terms,policy,hero,testimonial,feature,about_us',
            'type'          => 'required|in:image,text,question,multi',
            'slug'          => 'required|string|max:150|unique:frontend_contents,slug',
            'value'         => 'required', // Can be string or JSON
            'status'        => 'nullable|boolean',
            'multi_images'  => 'nullable|array',
            'multi_images.*'=> 'nullable|image|mimes:jpeg,png,jpg,webp,svg|max:10240',
        ]);

        $value = $request->input('value');

        // Handle single image upload
        if ($request->type === 'image' && $request->hasFile('value')) {
            $file = $request->file('value');
            $path = $file->store('frontend', 'public');
            $value = asset('storage/' . $path);
        }
        // Handle multi item image uploads
        elseif ($request->type === 'multi') {
            $items = json_decode($value, true);
            
            if (is_array($items)) {
                foreach ($items as $index => &$item) {
                    // Check if a file was uploaded for this specific multi index
                    if ($request->hasFile("multi_images.{$index}")) {
                        $file = $request->file("multi_images.{$index}");
                        $path = $file->store('frontend', 'public');
                        // Assign the permanent public asset storage URL
                        $item['image'] = asset('storage/app/public/' . $path);
                    }
                }
                unset($item); // Break reference
                $value = json_encode($items);
            }
        }

        $content = FrontendContent::create([
            'component' => $validated['component'],
            'type'      => $validated['type'],
            'slug'      => Str::slug($validated['slug']),
            'value'     => $value,
            'status'    => $request->boolean('status', true),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Frontend component item created successfully.',
            'data'    => $content
        ], 201);
    }

    /**
     * Get single component item details.
     */
    public function show($id): JsonResponse
    {
        $content = FrontendContent::find($id);

        if (!$content) {
            return response()->json(['status' => false, 'message' => 'Frontend content record not found.'], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $content
        ]);
    }

    /**
     * Edit an existing landing page component item.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $content = FrontendContent::find($id);

        if (!$content) {
            return response()->json(['status' => false, 'message' => 'Frontend content record not found.'], 404);
        }

        $validated = $request->validate([
            'component' => 'sometimes|required|in:slider,banner,faq,terms,policy,hero,testimonial,feature,about_us',
            'type'      => 'sometimes|required|in:image,text',
            'slug'      => ['sometimes', 'required', 'string', 'max:150', Rule::unique('frontend_contents', 'slug')->ignore($content->id)],
            'value'     => 'sometimes|required|string',
            'status'    => 'nullable|boolean',
        ]);

        if (isset($validated['slug'])) {
            $validated['slug'] = Str::slug($validated['slug']);
        }

        $content->update($validated);

        return response()->json([
            'status'  => true,
            'message' => 'Frontend component item updated successfully.',
            'data'    => $content
        ]);
    }

    /**
     * Enable or Disable component status.
     */
    public function toggleStatus($id): JsonResponse
    {
        $content = FrontendContent::find($id);

        if (!$content) {
            return response()->json(['status' => false, 'message' => 'Frontend content record not found.'], 404);
        }

        $content->update([
            'status' => !$content->status
        ]);

        $statusLabel = $content->status ? 'enabled' : 'disabled';

        return response()->json([
            'status'  => true,
            'message' => "Component status has been {$statusLabel} successfully.",
            'data'    => $content
        ]);
    }

    /**
     * Delete a frontend component item.
     */
    public function destroy($id): JsonResponse
    {
        $content = FrontendContent::find($id);

        if (!$content) {
            return response()->json(['status' => false, 'message' => 'Frontend content record not found.'], 404);
        }

        $content->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Frontend component item deleted successfully.'
        ]);
    }
}