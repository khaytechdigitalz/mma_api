<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CartItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'cart_id',
        'product_id',
        'seller_id',
        'quantity',
        'unit_price',
        'total_price',
        'variation_options',
    ];

    protected $casts = [
        'unit_price'        => 'decimal:2',
        'total_price'       => 'decimal:2',
        'variation_options' => 'array',
    ];

    /**
     * Model Boot Event: Automatically touch parent cart's last_activity_at on item changes.
     */
    protected static function booted()
    {
        static::saved(function ($item) {
            $item->cart->touchActivity();
        });

        static::deleted(function ($item) {
            $item->cart->touchActivity();
        });
    }

    /**
     * Relationship: CartItem belongs to Cart.
     */
    public function cart(): BelongsTo
    {
        return $this->belongsTo(Cart::class);
    }

    /**
     * Relationship: CartItem belongs to Product.
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    /**
     * Helper to touch parent cart activity timestamp.
     */
    private function touchActivity(): void
    {
        if ($this->cart) {
            $this->cart->update(['last_activity_at' => now()]);
        }
    }
}