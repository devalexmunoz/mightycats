<?php

namespace App\Http\Controllers;

use App\Rules\WalletAddress;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CustodialWalletController extends Controller
{
    public function update(Request $request): JsonResponse
    {
        $request->validate([
            'wallet_address' => ['required', 'string', new WalletAddress],
        ]);

        $user = Auth::user();
        $walletAddress = $request->wallet_address;

        if (! $user->has_custodial_wallet) {
            $user->custodial_wallet_address = $walletAddress;
            $user->save();
        }

        return response()->json([
            'success' => true,
            'walletAddress' => $walletAddress,
        ]);
    }
}
