<?php

namespace App\Http\Controllers;

use App\Helpers\FlowCloudKmsHelper;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CustodialCryptoKeysController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $user = Auth::user();

        if (! $user->has_custodial_wallet) {
            $publicKey = FlowCloudKmsHelper::createCustodialKey($user->custodial_key_id);
        }

        return response()->json([
            'success' => true,
            'publicKey' => $publicKey,
        ]);
    }
}
