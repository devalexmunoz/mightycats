<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Providers\RouteServiceProvider;
use Google_Client;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthenticationController extends Controller
{
    /**
     * Handle an incoming authentication request.
     */
    public function handleSigninWithProvider(Request $request): RedirectResponse
    {
        $request->validate([
            'credential' => ['required', 'string'],
        ]);

        $credentialToken = $request->credential;

        $client = new Google_Client(['client_id' => config('services.google.client_id')]);
        $payload = $client->verifyIdToken($credentialToken);
        if (! $payload) {
            abort(400);
        }

        $google_id = $payload['sub'];

        $userAuthProviderProperties = [
            'auth_provider' => 'google',
            'auth_provider_id' => $google_id,
        ];

        $user = User::where($userAuthProviderProperties)->first();

        if (! $user) {
            $user = $this->storeNewUser($userAuthProviderProperties, [
                'email' => $payload['email'],
                'email_verified_at' => $payload['email_verified'] ? now() : null,
            ]);
        }

        $redirectTo = RouteServiceProvider::HOME;
        if (! $user->hasCompletedOnboarding) {
            $redirectTo = route('onboarding.start');
        }

        Auth::login($user);

        return redirect($redirectTo);
    }

    protected function storeNewUser($userAuthProviderProperties, $userData): User
    {
        $user = new User($userAuthProviderProperties);
        $user->fill($userData);
        $user->save();

        event(new Registered($user));

        return $user;
    }
}
