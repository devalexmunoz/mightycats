<?php

namespace App\Http\Controllers;

use App\Http\Requests\CadenceFileRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Storage;

class FetchCadenceFileController extends Controller
{
    public function fetchScript(CadenceFileRequest $request): JsonResponse
    {
        return $this->fetchCadenceFile('scripts', $request->filename);
    }

    public function fetchTransaction(CadenceFileRequest $request): JsonResponse
    {
        return $this->fetchCadenceFile('transactions', $request->filename);
    }

    protected function fetchCadenceFile($directory, $filename): JsonResponse
    {
        $fullCadenceFilePath = "cadence/$directory/$filename.cdc";

        if (! Storage::disk('flow')->exists($fullCadenceFilePath)) {
            abort(404);
        }

        $contents = Storage::disk('flow')->get($fullCadenceFilePath);

        return response()->json([
            'success' => true,
            'fileContents' => base64_encode($contents),
        ]);
    }
}
