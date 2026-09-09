<?php

namespace App\Http\Controllers\Ai;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Gemini\Laravel\Facades\Gemini;
use Illuminate\Support\Facades\Http;

class AiProductController extends Controller
{
    public function generateProductDescription(Request $request)
    {
        $request->validate([
            'product_name' => 'required|string|max:255',
            'description_type' => 'required|string|max:255',
        ]);

        try {
            if($request->description_type == 'short')
            {
                $prompt = "You are an expert e-commerce copywriter. Write a short product description (max 2-3 lines) based on this product name: {$request->product_name}";
            }
            else
            {
                $prompt = "You are an expert e-commerce copywriter. Write a catchy, SEO-friendly product description (max 2-3 paragraphs) based on this product name: {$request->product_name}";
            }

            $result = Gemini::generativeModel(model: 'gemini-3.7-flash')->generateContent($prompt);
            return response()->json([
                'description' => $result->text()
            ]);
        } catch (\Exception $e) {
            // This will return the exact error message from the API or package
            return response()->json([
                'error' => 'Failed to generate description: ' . $e->getMessage()
            ], 500);
        }
    }

    public function generateDescriptionGrok(Request $request)
{
    $request->validate([
        'product_name' => 'required|string|max:255',
    ]);

    try {
        $response = Http::withToken(config('services.groq.key'))
            ->post('https://api.groq.com/openai/v1/chat/completions', [
                'model' => 'llama-3.3-70b-versatile', // Matches your API doc
                'messages' => [
                    [
                        'role' => 'system',
                        'content' => 'You are an expert e-commerce copywriter. Write a catchy, SEO-friendly product description (max 2-3 paragraphs).'
                    ],
                    [
                        'role' => 'user',
                        'content' => "Product Name: {$request->product_name}"
                    ]
                ],
            ]);

        if ($response->failed()) {
            throw new \Exception($response->json('error.message') ?? 'Groq API error');
        }

        $description = $response->json('choices.0.message.content');

        return response()->json([
            'description' => trim($description)
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'error' => 'Failed to generate description: ' . $e->getMessage()
        ], 500);
    }
}
}