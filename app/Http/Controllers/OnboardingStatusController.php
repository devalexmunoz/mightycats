<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;

class OnboardingStatusController extends Controller
{
    public function update(Request $request): JsonResponse
    {
        $request->validate([
            'status' => ['required', 'string', Rule::in([
                User::ONBOARDING_STATUS_PURCHASED,
                User::ONBOARDING_STATUS_MINTED,
                User::ONBOARDING_STATUS_REVEALED,
            ])],
            'minted_nft_id' => ['nullable', 'numeric'],
        ]);

        $user = Auth::user();

        //TODO: Validate logic (status order)

        if ($request->status === User::ONBOARDING_STATUS_MINTED && $request->minted_nft_id) {
            $user->minted_nft_id = $request->minted_nft_id;
        }

        $user->onboarding_status = $request->status;
        $user->save();

        return response()->json([
            'success' => true,
        ]);
    }
}
