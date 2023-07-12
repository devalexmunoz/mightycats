<?php

namespace App\Http\Controllers\Webhooks;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Receiver\Facades\Receiver;

class WebhooksController extends Controller
{
    public function store(Request $request, string $driver)
    {
        return Receiver::driver($driver)
            ->receive($request)
            ->ok();
    }
}
