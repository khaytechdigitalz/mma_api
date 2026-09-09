<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',
        'product_id',
        'seller_id',
        'unit_price',
        'quantity',
        'tax',
        'discount',
        'total_price',
        'variation_options',
        'delivery_status',
    ];

    protected $casts = [
        'variation_options' => 'array',
        'unit_price'        => 'decimal:2',
        'tax'               => 'decimal:2',
        'discount'          => 'decimal:2',
        'total_price'       => 'decimal:2',
        'quantity'          => 'integer',
    ];

    /**
     * Relationship back to parent Order
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class, 'order_id');
    }

    /**
     * Relationship to Product (Nullable if product gets deleted)
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class, 'product_id');
    }

    /**
     * Relationship to Seller
     */
    public function seller(): BelongsTo
    {
        return $this->belongsTo(User::class, 'seller_id');
    }
}