<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Carbon\Carbon;

class Cart extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'guest_token',
        'coupon_code',
        'subtotal',
        'discount_amount',
        'grand_total',
        'status',
        'abandoned_notification_sent_at',
        'recovered_at',
        'last_activity_at',
    ];

    protected $casts = [
        'subtotal'                       => 'decimal:2',
        'discount_amount'                => 'decimal:2',
        'grand_total'                    => 'decimal:2',
        'abandoned_notification_sent_at' => 'datetime',
        'recovered_at'                   => 'datetime',
        'last_activity_at'               => 'datetime',
    ];

    /**
     * Relationship: Cart belongs to a User (optional for guests).
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function touchActivity()
    {
        $this->update(['last_activity_at' => now()]); // Or whatever logic you use
    }

    /**
     * Relationship: Cart has many CartItems.
     */
    public function items(): HasMany
    {
        return $this->hasMany(CartItem::class);
    }

    /**
     * Scope: Query carts abandoned for more than X hours (default 24 hours).
     */
    public function scopeAbandoned($query, int $hours = 24)
    {
        return $query->where('status', '!=', 'converted')
            ->where('last_activity_at', '<=', Carbon::now()->subHours($hours));
    }

    /**
     * Scope: Query abandoned carts that have NOT received a notification yet.
     */
    public function scopeUnnotifiedAbandoned($query, int $hours = 24)
    {
        return $query->abandoned($hours)
            ->whereNull('abandoned_notification_sent_at');
    }

    /**
     * Recalculate totals based on line items.
     */
    public function recalculateTotals(): void
    {
        $this->subtotal = $this->items()->sum('total_price');
        $this->grand_total = max(0, $this->subtotal - $this->discount_amount);
        $this->last_activity_at = Carbon::now();
        $this->save();
    }
}