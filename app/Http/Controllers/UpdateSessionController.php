<?php

namespace App\Http\Controllers;

use App\Rules\ValidSessionData;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UpdateSessionController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $request->validate([
            'session_data' => ['required', 'string', new ValidSessionData],
        ]);

        $request->session_data = json_decode(base64_decode($request->session_data), true);

        foreach ($request->session_data as $key => $value) {
            $request->session()->put($key, $value);
        }

        return response()->json([
            'success' => true,
        ]);
    }
}
