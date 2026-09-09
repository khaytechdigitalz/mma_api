<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Coupon extends Model
{
    protected $fillable = [
        'name',
        'code',
        'discount_type',
        'discount',
        'start_date',
        'end_date',
        'product_ids',
        'is_active',
    ];

    protected $casts = [
        'discount'    => 'decimal:2',
        'start_date'  => 'date',
        'end_date'    => 'date',
        'product_ids' => 'array',
        'is_active'   => 'boolean',
    ];

    /**
     * Automatically append the virtual 'products' field when serializing to JSON
     */
    protected $appends = ['products'];

    /**
     * Accessor to select only id, name, and image for matching products
     */
    public function getProductsAttribute()
    {
        if (empty($this->product_ids) || !is_array($this->product_ids)) {
            return [];
        }

        return Product::whereIn('id', $this->product_ids)
            ->select('id', 'name', 'thumbnail')
            ->get();
    }
}