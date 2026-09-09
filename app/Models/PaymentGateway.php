<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PaymentGateway extends Model
{
    use HasFactory;

    protected $table = 'payment_gateways';

    protected $fillable = [
        'name',
        'slug',
        'public_key',
        'secret_key',
        'webhook_endpoint',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];
}