<?php

namespace App\Http\Handlers\Stripe;

use App\Models\User;
use Illuminate\Foundation\Bus\Dispatchable;

class CheckoutSessionCompleted
{
    use Dispatchable;

    protected $user_id;

    public function __construct(public string $event, public array $data)
    {
        $this->user_id = $data['object']['client_reference_id'];
    }

    public function handle()
    {
        $user = User::find($this->user_id);
        $user->onboarding_status = User::ONBOARDING_STATUS_PURCHASED;
        $user->save();
    }
}
