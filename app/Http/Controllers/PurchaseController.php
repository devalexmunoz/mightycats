<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Stripe\Checkout\Session as StripeCheckoutSession;
use Stripe\Stripe;

class PurchaseController extends Controller
{
    public function __invoke(Request $request): Response
    {
        Stripe::setApiKey(config('services.stripe.secret_key'));

        $checkoutSession = StripeCheckoutSession::create([
            'line_items' => [[
                'price' => config('services.stripe.purchase_price_id'),
                'quantity' => 1,
            ]],
            'mode' => 'payment',
            'client_reference_id' => Auth::user()->id,
            'success_url' => route('onboarding.reveal'),
            'cancel_url' => route('onboarding.start').'?cancel_purchase',
        ]);

        return Inertia::location($checkoutSession->url);
    }
}
