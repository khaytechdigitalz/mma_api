<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FrontendContent extends Model
{
    protected $table = 'frontend_contents';

    protected $fillable = [
        'component',
        'type',
        'slug',
        'value',
        'status',
    ];

    protected $casts = [
        'status' => 'boolean',
    ];
}