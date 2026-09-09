<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Ticket;
use App\Models\TicketMessage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TicketController extends Controller
{
  /**
     * List all support tickets with filtering, pagination, and status metrics.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Ticket::with('user');

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('priority')) {
            $query->where('priority', $request->priority);
        }

        if ($request->filled('search')) {
            $query->where(function ($q) use ($request) {
                $q->where('ticket_id', 'LIKE', '%' . $request->search . '%')
                  ->orWhere('subject', 'LIKE', '%' . $request->search . '%');
            });
        }

        $tickets = $query->latest()->paginate($request->get('per_page', 15));

        // Compute metrics/counts for support ticket statuses
        $metrics = [
            'open'    => Ticket::where('status', 'open')->count(),
            'replied' => Ticket::where('status', 'replied')->count(),
            'closed'  => Ticket::where('status', 'closed')->count(),
            'total'   => Ticket::count(),
        ];

        return response()->json([
            'status'  => true,
            'metrics' => $metrics,
            'data'    => $tickets
        ]);
    }

    /**
     * View full thread of a single support ticket.
     */
    public function show($id): JsonResponse
    {
        $ticket = Ticket::with(['user', 'messages'])->find($id);

        if (!$ticket) {
            return response()->json(['status' => false, 'message' => 'Support ticket not found.'], 404);
        }

        return response()->json([
            'status' => true,
            'data'   => $ticket
        ]);
    }

    /**
     * Reply to a support ticket.
     */
    public function reply(Request $request, $id): JsonResponse
    {
        $ticket = Ticket::find($id);

        if (!$ticket) {
            return response()->json(['status' => false, 'message' => 'Support ticket not found.'], 404);
        }

        if ($ticket->status === 'closed') {
            return response()->json(['status' => false, 'message' => 'Cannot reply to a closed ticket.'], 422);
        }

        $validated = $request->validate([
            'message'       => 'required|string',
            'attachments'   => 'nullable|array',
            'attachments.*' => 'string',
        ]);

        $message = TicketMessage::create([
            'ticket_id'   => $ticket->id,
            'user_id'     => Auth::id(),
            'message'     => $validated['message'],
            'attachments' => $validated['attachments'] ?? [],
        ]);

        $ticket->update([
            'status' => 'replied'
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Reply submitted successfully.',
            'data'    => $message->load('user')
        ], 201);
    }

    /**
     * Close a support ticket.
     */
    public function close($id): JsonResponse
    {
        $ticket = Ticket::find($id);

        if (!$ticket) {
            return response()->json(['status' => false, 'message' => 'Support ticket not found.'], 404);
        }

        $ticket->update([
            'status' => 'closed'
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'Ticket closed successfully.',
            'data'    => $ticket
        ]);
    }
}