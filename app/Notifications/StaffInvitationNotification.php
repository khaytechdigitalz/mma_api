<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class StaffInvitationNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public array $credentials;

    /**
     * Create a new notification instance.
     *
     * @param array $credentials Contains 'name', 'email', 'password', and 'token'
     */
    public function __construct(array $credentials)
    {
        $this->credentials = $credentials;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param object $notifiable
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param object $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail(object $notifiable): MailMessage
    {
        $loginUrl = config('app.frontend_url', config('app.url')) . '/login';
        $acceptUrl = config('app.frontend_url', config('app.url')) . '/accept-invitation?token=' . $this->credentials['token'];

        return (new MailMessage)
            ->subject('You have been invited to the Admin Portal')
            ->greeting("Hello {$this->credentials['name']},")
            ->line('You have been invited to join the platform as a staff member.')
            ->line('Your temporary login credentials are provided below:')
            ->line("**Email:** {$this->credentials['email']}")
            ->line("**Temporary Password:** {$this->credentials['password']}")
            ->action('Accept Invitation & Login', $acceptUrl)
            ->line('Please make sure to log in and change your password upon your first sign-in.')
            ->line('Thank you for joining our team!');
    }

    /**
     * Get the array representation of the notification.
     *
     * @param object $notifiable
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            'email' => $this->credentials['email'],
            'token' => $this->credentials['token'],
        ];
    }
}