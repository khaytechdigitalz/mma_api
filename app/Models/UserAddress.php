<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserAddress extends Model
{
    use HasFactory;

    protected $table = 'user_addresses';

    protected $fillable = [
        'user_id',
        'address',
        'city',
        'zip',
        'state',
        'country',
        'is_default',
    ];

    /**
     * Relationship: An address belongs to a user.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}