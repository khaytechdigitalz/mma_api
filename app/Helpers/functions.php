<?php

use App\Models\SendMail;
use App\Models\AuditLog;
use Illuminate\Support\Facades\Mail;

if (!function_exists('amount')) {
    function amount($amount, $currency)
    {
        return $currency.''.number_format($amount, 2);
    }
}

if (!function_exists('sendEmail')) {
    function sendEmail($email, $message, $page)
    {
        $content = [
            'message' => $message,
            'name' => $message['name'],
            'subject' => $message['subject'],
            'page' => $page,
        ];

        try {
            Mail::to($email)->send(new SendMail($content));
        } catch (Exception $exp) {
        }
    }
}


if (!function_exists('audit_log')) {
    /**
     * Record an event in the audit_logs table.
     *
     * @param string $action       Short event descriptor (e.g., 'product.create')
     * @param string $description  Human-readable summary of the action
     * @param array|null $oldValues Data state before changes
     * @param array|null $newValues Data state after changes
     * @return AuditLog|null
     */
    function audit_log(string $action, string $description, ?array $oldValues = null, ?array $newValues = null): ?AuditLog
    {
        try {
            $user = Auth::user();
            $userAgent = Request::header('User-Agent') ?? '';

            // Detect basic device context from User-Agent
            $device = 'Desktop';
            if (preg_match('/(tablet|ipad|playbook)|(android(?!.*mobile))/i', $userAgent)) {
                $device = 'Tablet';
            } elseif (preg_match('/(android|bb\d+|meego).+mobile|iphone|ipod|blackberry|iemobile|opera mini/i', $userAgent)) {
                $device = 'Mobile';
            }

            // Detect basic Browser
            $browser = 'Unknown';
            if (preg_match('/EDG/i', $userAgent)) $browser = 'Edge';
            elseif (preg_match('/Chrome/i', $userAgent)) $browser = 'Chrome';
            elseif (preg_match('/Firefox/i', $userAgent)) $browser = 'Firefox';
            elseif (preg_match('/Safari/i', $userAgent)) $browser = 'Safari';
            elseif (preg_match('/MSIE|Trident/i', $userAgent)) $browser = 'Internet Explorer';

            // Detect Platform
            $platform = 'Unknown';
            if (preg_match('/win/i', $userAgent)) $platform = 'Windows';
            elseif (preg_match('/mac/i', $userAgent)) $platform = 'macOS';
            elseif (preg_match('/linux/i', $userAgent)) $platform = 'Linux';
            elseif (preg_match('/android/i', $userAgent)) $platform = 'Android';
            elseif (preg_match('/iphone|ipad|ipod/i', $userAgent)) $platform = 'iOS';

            // Filter out file binaries/instances from payload to prevent bloat
            $payload = collect(Request::except(['thumbnail', 'images', 'digital_file', 'password']))
                ->toArray();

            return AuditLog::create([
                'user_id'     => $user?->id,
                'user_type'   => $user?->type ?? 'guest',
                'action'      => $action,
                'description' => $description,
                'ip_address'  => Request::ip(),
                'user_agent'  => substr($userAgent, 0, 500),
                'device'      => $device,
                'browser'     => $browser,
                'platform'    => $platform,
                'payload'     => !empty($payload) ? $payload : null,
                'old_values'  => $oldValues,
                'new_values'  => $newValues,
            ]);
        } catch (\Throwable $e) {
            // Log error silently so main request flow isn't interrupted by audit log issues
            logger()->error('Audit log creation failed: ' . $e->getMessage());
            return null;
        }
    }
}
