<?php

namespace App\Helpers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AgentHelper
{
    public static function parse(Request $request): array
    {
        $userAgent = $request->header('User-Agent') ?? '';
        $ip = $request->ip();

        // Standard local fallback for development testing
        if ($ip === '127.0.0.1' || $ip === '::1') {
            $ip = '8.8.8.8'; 
        }

        $browser = self::getBrowser($userAgent);
        $platform = self::getPlatform($userAgent);
        $deviceType = self::getDeviceType($userAgent);
        $deviceName = "{$platform} ({$browser})";

        // Simple GeoIP lookup via free IP API
        $location = self::getLocation($ip);

        return [
            'ip_address'   => $request->ip(),
            'country'      => $location['country'] ?? 'Unknown',
            'city'         => $location['city'] ?? 'Unknown',
            'browser'      => $browser,
            'platform'     => $platform,
            'device_type'  => $deviceType,
            'device_name'  => $deviceName,
            'user_agent'   => $userAgent,
            'logged_in_at' => now(),
        ];
    }

    private static function getBrowser(string $agent): string
    {
        if (preg_match('/MSIE/i', $agent) && !preg_match('/Opera/i', $agent)) return 'Internet Explorer';
        if (preg_match('/Firefox/i', $agent)) return 'Firefox';
        if (preg_match('/OPR/i', $agent) || preg_match('/Opera/i', $agent)) return 'Opera';
        if (preg_match('/Chrome/i', $agent) && !preg_match('/Edge/i', $agent)) return 'Chrome';
        if (preg_match('/Safari/i', $agent) && !preg_match('/Edge/i', $agent)) return 'Safari';
        if (preg_match('/Edge/i', $agent)) return 'Edge';
        return 'Unknown Browser';
    }

    private static function getPlatform(string $agent): string
    {
        if (preg_match('/linux/i', $agent)) return 'Linux';
        if (preg_match('/macintosh|mac os x/i', $agent)) return 'macOS';
        if (preg_match('/windows|win32/i', $agent)) return 'Windows';
        if (preg_match('/android/i', $agent)) return 'Android';
        if (preg_match('/iphone|ipad|ipod/i', $agent)) return 'iOS';
        return 'Unknown Platform';
    }

    private static function getDeviceType(string $agent): string
    {
        if (preg_match('/(tablet|ipad|playbook)|(android(?!.*mobile))/i', $agent)) return 'tablet';
        if (preg_match('/(mobile|iphone|ipod|blackberry|opera mini)/i', $agent)) return 'mobile';
        return 'desktop';
    }

    private static function getLocation(string $ip): array
    {
        try {
            $response = Http::timeout(3)->get("http://ip-api.com/json/{$ip}?fields=status,country,city");
            if ($response->successful() && $response->json('status') === 'success') {
                return [
                    'country' => $response->json('country'),
                    'city'    => $response->json('city'),
                ];
            }
        } catch (\Throwable $e) {
            // Silence geo lookup exceptions on failure
        }

        return ['country' => 'Unknown', 'city' => 'Unknown'];
    }
}