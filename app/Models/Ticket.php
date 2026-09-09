<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Ticket extends Model
{
    protected $fillable = [
        'ticket_id',
        'user_id',
        'subject',
        'priority',
        'status',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class)->select('id', 'name', 'email');
    }

    public function messages(): HasMany
    {
        return $this->hasMany(TicketMessage::class)->with('user');
    }
}