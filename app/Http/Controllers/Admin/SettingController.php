<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    /**
     * Fetch all current system settings grouped by domain.
     */
    public function index(): JsonResponse
    {
        $settings = Setting::all()->pluck('value', 'key');

        return response()->json([
            'status' => true,
            'data'   => [
                'general' => [
                    'logo'            => $settings['logo'] ?? '',
                    'site_name'       => $settings['site_name'] ?? '',
                    'site_email'      => $settings['site_email'] ?? '',
                    'site_phone'      => $settings['site_phone'] ?? '',
                    'site_currency'   => $settings['site_currency'] ?? 'USD',
                    'currency_symbol' => $settings['currency_symbol'] ?? '$',
                ],
                'maintenance' => [
                    'maintenance_mode'    => filter_var($settings['maintenance_mode'] ?? false, FILTER_VALIDATE_BOOLEAN),
                    'maintenance_message' => $settings['maintenance_message'] ?? '',
                ],
                'notification' => [
                    'sms_notification' => $settings['sms_notification'] ?? '',
                    'email_notification' => $settings['email_notification'] ?? '',
                    'push_notification' => $settings['push_notification'] ?? '',
                ],
                'global_seo' => [
                    'meta_title'       => $settings['global_meta_title'] ?? '',
                    'meta_description' => $settings['global_meta_description'] ?? '',
                    'meta_keywords'    => $settings['global_meta_keywords'] ?? '',
                    'meta_image'       => $settings['global_meta_image'] ?? '',
                ],
                'homepage_seo' => [
                    'meta_title'       => $settings['homepage_meta_title'] ?? '',
                    'meta_description' => $settings['homepage_meta_description'] ?? '',
                    'meta_keywords'    => $settings['homepage_meta_keywords'] ?? '',
                ],
            ]
        ]);
    }

    /**
     * Update General Platform Basic Information with Audit Log.
     */
    public function updateGeneralInfo(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'site_name'       => 'required|string|max:150',
            'site_email'      => 'required|email|max:150',
            'site_phone'      => 'required|string|max:50',
            'site_currency'   => 'required|string|max:10',
            'currency_symbol' => 'required|string|max:10',
            'logo'            => 'nullable|image|mimes:jpeg,png,jpg,svg,webp|max:2048', // Adjusted to valid image rules and max 2MB
        ]);

        $keys = array_keys($validated);
        $oldValues = Setting::whereIn('key', $keys)->pluck('value', 'key')->toArray();

        // Handle file upload for logo if provided
        if ($request->hasFile('logo')) {
            $file = $request->file('logo');
            $path = $file->store('logos', 'public'); // Stores in storage/app/public/logos
            
            // Overwrite the logo value in validated array with the storage path string
            $validated['logo'] = $path;

            // Optional: Delete the old logo file if it exists to save server storage space
            if (!empty($oldValues['logo']) && \Storage::disk('public')->exists($oldValues['logo'])) {
                \Storage::disk('public')->delete($oldValues['logo']);
            }
        } else {
            // If no new logo was uploaded, keep the old logo value so it doesn't get wiped out
            unset($validated['logo']);
        }

        foreach ($validated as $key => $value) {
            Setting::setKey($key, $value);
        }

        // Record Audit Log directly in controller function
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_general_settings',
            'description' => 'Updated system general settings (site name, email, phone, currency, and/or logo).',
            'old_values'  => $oldValues,
            'new_values'  => $validated,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'General settings updated successfully.'
        ]);
    }

    public function updateNotification(Request $request, $id)
    {
    // Validate that status is provided (boolean or 1/0)
    $request->validate([
        'status' => 'required',
    ]);

    // Retrieve current settings (adjust based on your storage mechanism, e.g., JSON column, database table, or config file)
    $settings = Setting::where('key',$id)->first(); // or however you fetch your settings

    if (!$settings) {
        return response()->json([
            'status' => false,
            'message' => 'Settings not found.'
        ], 404);
    }


    // Save back to the database
    $settings->value = $request->status;
    $settings->save();

    return response()->json([
        'status' => true,
        'message' => 'Notification preference updated successfully.',
        'data' => $settings,
    ]);
}

    /**
     * Update Maintenance Mode state and message with Audit Log.
     */
    public function updateMaintenanceMode(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'maintenance_mode'    => 'required|boolean',
            'maintenance_message' => 'nullable|string|max:500',
        ]);

        $oldValues = [
            'maintenance_mode'    => Setting::getByKey('maintenance_mode', '0'),
            'maintenance_message' => Setting::getByKey('maintenance_message', ''),
        ];

        Setting::setKey('maintenance_mode', $validated['maintenance_mode'] ? '1' : '0');
        if (isset($validated['maintenance_message'])) {
            Setting::setKey('maintenance_message', $validated['maintenance_message']);
        }

        $statusMessage = $validated['maintenance_mode'] ? 'enabled' : 'disabled';

        // Record Audit Log directly in controller function
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_maintenance_mode',
            'description' => "System maintenance mode was {$statusMessage}.",
            'old_values'  => $oldValues,
            'new_values'  => $validated,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => "Maintenance mode has been {$statusMessage} successfully."
        ]);
    }

    /**
     * Update Global SEO Settings with Audit Log.
     */
    public function updateGlobalSeo(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'meta_title'       => 'required|string|max:255',
            'meta_description' => 'required|string|max:500',
            'meta_keywords'    => 'nullable|string|max:255',
            'meta_image'       => 'nullable|string|url',
        ]);

        $oldValues = [
            'meta_title'       => Setting::getByKey('global_meta_title'),
            'meta_description' => Setting::getByKey('global_meta_description'),
            'meta_keywords'    => Setting::getByKey('global_meta_keywords'),
            'meta_image'       => Setting::getByKey('global_meta_image'),
        ];

        Setting::setKey('global_meta_title', $validated['meta_title']);
        Setting::setKey('global_meta_description', $validated['meta_description']);
        Setting::setKey('global_meta_keywords', $validated['meta_keywords'] ?? '');
        Setting::setKey('global_meta_image', $validated['meta_image'] ?? '');

        // Record Audit Log directly in controller function
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_global_seo',
            'description' => 'Updated system global SEO meta parameters.',
            'old_values'  => $oldValues,
            'new_values'  => $validated,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Global SEO settings updated successfully.'
        ]);
    }

    /**
     * Update Homepage Specific SEO Settings with Audit Log.
     */
    public function updateHomepageSeo(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'meta_title'       => 'required|string|max:255',
            'meta_description' => 'required|string|max:500',
            'meta_keywords'    => 'nullable|string|max:255',
        ]);

        $oldValues = [
            'meta_title'       => Setting::getByKey('homepage_meta_title'),
            'meta_description' => Setting::getByKey('homepage_meta_description'),
            'meta_keywords'    => Setting::getByKey('homepage_meta_keywords'),
        ];

        Setting::setKey('homepage_meta_title', $validated['meta_title']);
        Setting::setKey('homepage_meta_description', $validated['meta_description']);
        Setting::setKey('homepage_meta_keywords', $validated['meta_keywords'] ?? '');

        // Record Audit Log directly in controller function
        AuditLog::create([
            'user_id'     => $request->user()?->id,
            'action'      => 'update_homepage_seo',
            'description' => 'Updated landing page SEO meta parameters.',
            'old_values'  => $oldValues,
            'new_values'  => $validated,
            'ip_address'  => $request->ip(),
            'user_agent'  => $request->userAgent(),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Homepage SEO settings updated successfully.'
        ]);
    }

    /**
     * Get Paginated Audit Logs for Admin Panel View.
     */
    public function auditLogs(Request $request): JsonResponse
    {
        $query = AuditLog::with('user');

        if ($request->filled('action')) {
            $query->where('action', $request->action);
        }

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        $logs = $query->latest()->paginate($request->get('per_page', 20));

        return response()->json([
            'status' => true,
            'data'   => $logs
        ]);
    }
}