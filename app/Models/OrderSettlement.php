<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderSettlement extends Model
{
    protected $fillable = [
        'order_id', 'seller_id', 'gross_amount', 'platform_fee', 'net_settlement', 'status', 'settled_at'
    ];

    protected $casts = [
        'gross_amount'   => 'decimal:2',
        'platform_fee'   => 'decimal:2',
        'net_settlement' => 'decimal:2',
        'settled_at'     => 'datetime',
    ];

    /**
     * Get the seller associated with the settlement.
     */
    public function seller()
    {
        return $this->belongsTo(User::class, 'seller_id');
    }
}