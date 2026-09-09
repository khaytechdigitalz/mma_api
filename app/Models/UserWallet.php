<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserWallet extends Model
{
    protected $fillable = ['user_id', 'balance', 'pending_balance', 'withdraw_lock'];

    protected $casts = [
        'balance'         => 'decimal:2',
        'pending_balance' => 'decimal:2',
        'withdraw_lock'   => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}