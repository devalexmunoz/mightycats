<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RandomPickController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        $request->validate([
            'options_pool' => ['required', 'array'],
        ]);

        $optionsPool = array_values($request->options_pool);

        try {
            $randomIndex = random_int(0, count($optionsPool) - 1);
        } catch (Exception $e) {
            abort(500);
        }

        $randomPick = $optionsPool[$randomIndex];

        return response()->json([
            'pick' => $randomPick,
        ]);
    }
}
