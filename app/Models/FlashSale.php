<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FlashSale extends Model
{
    protected $fillable = [
        'title',
        'start_date',
        'end_date',
        'discount_type',
        'discount',
        'product_ids',
        'is_active',
    ];

    protected $casts = [
        'discount'    => 'decimal:2',
        'start_date'  => 'datetime',
        'end_date'    => 'datetime',
        'product_ids' => 'array',
        'is_active'   => 'boolean',
    ];
}