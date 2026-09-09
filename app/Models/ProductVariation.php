<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductVariation extends Model
{
    protected $fillable = [
        'product_id',
        'attribute_id',
        'attribute_value_ids',
    ];

    protected $casts = [
        'attribute_value_ids' => 'array',
    ];

    // Automatically append attribute_values to JSON responses
    protected $appends = ['attribute_values'];

    /**
     * Relationship to parent Attribute model
     */
    public function attribute(): BelongsTo
    {
        return $this->belongsTo(Attribute::class, 'attribute_id');
    }

    /**
     * Accessor to fetch AttributeValue models from JSON IDs
     */
    public function getAttributeValuesAttribute()
    {
        if (empty($this->attribute_value_ids)) {
            return [];
        }

        return AttributeValue::whereIn('id', $this->attribute_value_ids)->get();
    }
}