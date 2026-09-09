<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserLogin extends Model
{
    use HasFactory;

    public $timestamps = false; // Using custom logged_in_at field

    protected $fillable = [
        'user_id',
        'ip_address',
        'country',
        'city',
        'browser',
        'platform',
        'device_type',
        'device_name',
        'user_agent',
        'logged_in_at',
    ];

    protected $casts = [
        'logged_in_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}