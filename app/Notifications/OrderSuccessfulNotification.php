<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\Order;

class OrderSuccessfulNotification extends Notification implements ShouldQueue
{
    use Queueable;

    /**
    * The order instance.
    *
    * @var \App\Models\Order
    */
    public $order;

    /**
     * Create a new notification instance.
     */
    public function __construct(Order $order)
    {
        $this->order = $order;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        $order = $this->order;

        return (new MailMessage)
            ->subject('Order Payment Confirmed - #' . $order->order_no)
            ->greeting('Hello ' . ($notifiable->name ?? 'Valued Customer') . ',')
            ->line('Thank you for your purchase! Your payment has been successfully verified, and your order has been placed into processing.')
            ->line('---')
            ->line('**Order Details:**')
            ->line('• **Order Number:** ' . $order->order_no)
            ->line('• **Total Paid:** ' . config('app.currency_symbol', '₦') . number_format($order->grand_total, 2))
            ->line('• **Payment Status:** Paid')
            ->line('---')
            ->action('View Order Status', url('/orders/' . $order->order_no))
            ->line('We will send you another update when your order is shipped or ready.')
            ->salutation('Thank you for shopping with us!');
    }

    /**
     * Get the array representation of the notification (optional for database storage if needed later).
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            'order_id' => $this->order->id,
            'order_no' => $this->order->order_no,
            'grand_total' => $this->order->grand_total,
            'message' => 'Payment successful for order #' . $this->order->order_no,
        ];
    }
}