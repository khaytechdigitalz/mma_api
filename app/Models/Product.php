<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'seller_id',
        'brand_id',
        'category_id',
        'sub_category_id',
        'name',
        'slug',
        'sku',
        'product_type',
        'unit',
        'tags',
        'short_description',
        'description',
        'thumbnail',
        'images',
        'unit_price',
        'purchase_price',
        'tax',
        'tax_type',
        'discount',
        'discount_type',
        'current_stock',
        'minimum_order_qty',
        'low_stock_threshold',
        'stock_status', 
        'shipping_cost',
        'multiply_qty',
        'digital_file',
        'digital_file_type',
        'is_featured',
        'is_todays_deal',
        'published',
        'status',
        'denied_reason',
        'meta_title',
        'meta_description',
        'meta_image',
    ];

    protected $casts = [
        'tags' => 'array',
        'images' => 'array',
        'unit_price' => 'float',
        'purchase_price' => 'float',
        'tax' => 'float',
        'discount' => 'float',
        'shipping_cost' => 'float',  
        'is_featured' => 'boolean',
        'is_todays_deal' => 'boolean',
        'published' => 'boolean',
        'multiply_qty' => 'boolean',
        
    ];

    /* --- Relationships --- */

    public function seller()
    {
        return $this->belongsTo(User::class, 'seller_id');
    } 

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function subCategory()
    {
        return $this->belongsTo(SubCategory::class, 'sub_category_id');
    }

    public function brand()
    {
        return $this->belongsTo(Brand::class);
    }
    
    public function variations()
    {
        return $this->hasMany(ProductVariation::class);
    }
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class, 'product_id');
    }
    public function reviews()
    {
        return $this->hasMany(ProductReview::class, 'product_id');
    }
}