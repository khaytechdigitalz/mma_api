<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Blog;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class BlogController extends Controller
{
    /**
     * Display a listing of the blogs.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Blog::query();

        // Optional filtering by status
        if ($request->has('status')) {
            $query->where('status', $request->boolean('status'));
        }

        // Search by title or body
        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('body', 'like', "%{$search}%");
            });
        }

        $blogs = $query->latest()->paginate($request->input('per_page', 15));

        return response()->json([
            'status'  => true,
            'message' => 'Blogs fetched successfully.',
            'data'    => $blogs
        ]);
    }

    /**
     * Store a newly created blog in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title'  => 'required|string|max:255',
            'body'   => 'required|string',
            'image'  => 'nullable|image|mimes:jpeg,png,jpg,webp,svg|max:10240',
            'status' => 'nullable|boolean',
        ]);

        $imagePath = null;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('blogs', 'public');
            $imagePath = asset('storage/app/public/' . $path);
        }

        $blog = Blog::create([
            'title'  => $validated['title'],
            'body'   => $validated['body'],
            'image'  => $imagePath,
            'status' => $request->boolean('status', true),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Blog created successfully.',
            'data'    => $blog
        ], 201);
    }

    /**
     * Display the specified blog.
     */
    public function show($idOrSlug): JsonResponse
    {
        $blog = is_numeric($idOrSlug) 
            ? Blog::findOrFail($idOrSlug) 
            : Blog::where('slug', $idOrSlug)->firstOrFail();

        return response()->json([
            'status'  => true,
            'message' => 'Blog fetched successfully.',
            'data'    => $blog
        ]);
    }

    /**
     * Update the specified blog in storage.
     */
    public function update(Request $request, $id): JsonResponse
    {
        $blog = Blog::findOrFail($id);

        $validated = $request->validate([
            'title'  => 'sometimes|required|string|max:255',
            'body'   => 'sometimes|required|string',
            'image'  => 'nullable|image|mimes:jpeg,png,jpg,webp,svg|max:10240',
            'status' => 'nullable|boolean',
        ]);

        $data = [];
        if (isset($validated['title'])) {
            $data['title'] = $validated['title'];
            $data['slug'] = Str::slug($validated['title']);
        }
        if (isset($validated['body'])) {
            $data['body'] = $validated['body'];
        }
        if ($request->has('status')) {
            $data['status'] = $request->boolean('status');
        }

        // Handle new image replacement
        if ($request->hasFile('image')) {
            // Delete old image file if it exists locally
            if ($blog->image) {
                $oldPath = str_replace(asset('storage/'), '', $blog->image);
                Storage::disk('public')->delete($oldPath);
            }

            $path = $request->file('image')->store('blogs', 'public');
            $data['image'] = asset('storage/' . $path);
        }

        $blog->update($data);

        return response()->json([
            'status'  => true,
            'message' => 'Blog updated successfully.',
            'data'    => $blog
        ]);
    }


     /**
     * Enable or Disable component status.
     */
    public function toggleStatus($id): JsonResponse
    {
        $content = Blog::find($id);

        if (!$content) {
            return response()->json(['status' => false, 'message' => 'Blog content record not found.'], 404);
        }

        $content->update([
            'status' => !$content->status
        ]);

        $statusLabel = $content->status ? 'enabled' : 'disabled';

        return response()->json([
            'status'  => true,
            'message' => "Blog status has been {$statusLabel} successfully.",
            'data'    => $content
        ]);
    }

    /**
     * Remove the specified blog from storage.
     */
    public function destroy($id): JsonResponse
    {
        $blog = Blog::findOrFail($id);

        // Delete associated image file
        if ($blog->image) {
            $oldPath = str_replace(asset('storage/'), '', $blog->image);
            Storage::disk('public')->delete($oldPath);
        }

        $blog->delete();

        return response()->json([
            'status'  => true,
            'message' => 'Blog deleted successfully.'
        ]);
    }
}