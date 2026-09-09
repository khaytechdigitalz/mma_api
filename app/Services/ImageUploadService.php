<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Exception;

class ImageUploadService
{
    /**
     * Upload, optionally resize, convert to WebP, and store an image in a designated folder.
     *
     * @param UploadedFile $file The uploaded file instance
     * @param string $folder Directory/folder scope (e.g., 'brands', 'categories', 'products', 'artworks')
     * @param int|null $width Target max width
     * @param int|null $height Target max height
     * @param string $disk Storage disk defined in config/filesystems.php
     * @return string Relative storage path of uploaded file (e.g., 'brands/2026/08/uuid_timestamp.webp')
     * @throws Exception
     */
   public function upload(
    UploadedFile $file,
    string $folder = 'general',
    ?int $width = null,
    ?int $height = null,
    string $disk = 'public'
): string {
    if (!$file->isValid()) {
        throw new Exception("Invalid file upload.");
    }

    // Process nested folder paths (e.g. "categories/icons" -> "categories/icons")
    $folderSegments = explode('/', trim($folder, '/'));
    $sluggedSegments = array_map(fn($segment) => Str::slug($segment), $folderSegments);
    $folderName = implode('/', array_filter($sluggedSegments));

    // Fallback if empty
    if (empty($folderName)) {
        $folderName = 'general';
    }

    // Generate clean unique filename with date organization: categories/icons/2026/08/uuid_timestamp.webp
    $filename = Str::uuid() . '_' . time() . '.webp';
    $path = $folderName . '/' . date('Y/m') . '/' . $filename;

    // Process image using native PHP GD for resizing & WebP conversion
    $processedImageData = $this->processImageNative($file, $width, $height);

    // Store directly via Laravel Storage Facade
    Storage::disk($disk)->put($path, $processedImageData);

    return $path;
}

    /**
     * Safely delete an image file from storage.
     *
     * @param string|null $path
     * @param string $disk
     * @return bool
     */
    public function delete(?string $path, string $disk = 'public'): bool
    {
        if (!empty($path) && Storage::disk($disk)->exists($path)) {
            return Storage::disk($disk)->delete($path);
        }

        return false;
    }

    /**
     * Process image natively with GD (Resizing & WebP conversion).
     */
    protected function processImageNative(UploadedFile $file, ?int $maxWidth, ?int $maxHeight): string
    {
        $filePath = $file->getRealPath();
        $imageInfo = @getimagesize($filePath);

        if (!$imageInfo) {
            return file_get_contents($filePath);
        }

        [$origWidth, $origHeight, $type] = $imageInfo;

        $srcImage = match ($type) {
            IMAGETYPE_JPEG => imagecreatefromjpeg($filePath),
            IMAGETYPE_PNG  => imagecreatefrompng($filePath),
            IMAGETYPE_WEBP => imagecreatefromwebp($filePath),
            IMAGETYPE_GIF  => imagecreatefromgif($filePath),
            default        => null,
        };

        if (!$srcImage) {
            return file_get_contents($filePath);
        }

        $newWidth = $origWidth;
        $newHeight = $origHeight;

        if ($maxWidth || $maxHeight) {
            $ratio = $origWidth / $origHeight;

            if ($maxWidth && $newWidth > $maxWidth) {
                $newWidth = $maxWidth;
                $newHeight = (int) round($newWidth / $ratio);
            }

            if ($maxHeight && $newHeight > $maxHeight) {
                $newHeight = $maxHeight;
                $newWidth = (int) round($newHeight * $ratio);
            }
        }

        $dstImage = imagecreatetruecolor($newWidth, $newHeight);

        imagealphablending($dstImage, false);
        imagesavealpha($dstImage, true);

        imagecopyresampled(
            $dstImage,
            $srcImage,
            0, 0, 0, 0,
            $newWidth,
            $newHeight,
            $origWidth,
            $origHeight
        );

        ob_start();
        imagewebp($dstImage, null, 80);
        $binaryData = ob_get_clean();

        imagedestroy($srcImage);
        imagedestroy($dstImage);

        return $binaryData;
    }
}