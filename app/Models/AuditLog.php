<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AuditLog extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'user_type',
        'action',
        'description',
        'ip_address',
        'user_agent',
        'device',
        'browser',
        'platform',
        'payload',
        'old_values',
        'new_values',
    ];

    protected $casts = [
        'payload'    => 'array',
        'old_values' => 'array',
        'new_values' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}