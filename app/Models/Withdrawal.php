<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Withdrawal extends Model
{
    protected $fillable = [
        'reference',
        'user_id',
        'user_bank_detail_id',
        'amount',
        'fee',
        'net_amount',
        'status',
        'admin_notes',
        'processed_by_user_id',
        'processed_at',
    ];

    protected $casts = [
        'amount'       => 'decimal:2',
        'fee'          => 'decimal:2',
        'net_amount'   => 'decimal:2',
        'processed_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function bankDetail(): BelongsTo
    {
        return $this->belongsTo(UserBankDetail::class, 'user_bank_detail_id');
    }

    public function processedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'processed_by_user_id');
    }
}