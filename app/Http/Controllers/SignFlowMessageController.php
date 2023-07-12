<?php

namespace App\Http\Controllers;

use App\Helpers\FlowCloudKmsHelper;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SignFlowMessageController extends Controller
{
    public function __invoke(Request $request, string $signatureType): JsonResponse
    {
        $request->validate([
            'message' => ['required', 'string'],
        ]);

        if ($signatureType === 'admin') {
            $signature = FlowCloudKmsHelper::signWithAdminKey($request->message);
        }

        if ($signatureType === 'user') {
            $signature = FlowCloudKmsHelper::signWithCustodialKey($request->message, Auth::user()->custodial_key_id);
        }

        return response()->json($signature);
    }
}
