<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderStatusHistory extends Model
{
    use HasFactory;

    // Disable updated_at since logs are insert-only
    public const UPDATED_AT = null;

    protected $fillable = [
        'order_id',
        'status',
        'comment',
        'changed_by_user_id',
    ];

    /**
     * Relationship back to parent Order
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class, 'order_id');
    }

    /**
     * Relationship to the user who triggered the status change (Admin, Vendor, System)
     */
    public function changedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'changed_by_user_id');
    }
}