<?php

namespace App\Http\Middleware;

use App\Models\User;
use App\Providers\RouteServiceProvider;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class EnsureOnboardingStatus
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $onboardingStatus): Response
    {
        $allowedStatuses = explode('|', $onboardingStatus);

        // Replace "empty" parameter value with null to match user property potential value
        $allowedStatuses = array_map(function ($status) {
            return ($status === 'empty') ? null : $status;
        }, $allowedStatuses);

        $user = Auth::user();

        if (! in_array($user->onboarding_status, $allowedStatuses)) {
            switch ($user->onboarding_status) {
                case User::ONBOARDING_STATUS_PURCHASED:
                    return redirect()->route('onboarding.mint');
                case User::ONBOARDING_STATUS_MINTED:
                    return redirect()->route('onboarding.reveal');
                case User::ONBOARDING_STATUS_COMPLETED:
                    return redirect(RouteServiceProvider::HOME);
                default:
                    return redirect()->route('onboarding.start');
            }
        }

        return $next($request);
    }
}
