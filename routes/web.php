<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\AuthenticationController;
use App\Http\Controllers\CustodialCryptoKeysController;
use App\Http\Controllers\CustodialWalletController;
use App\Http\Controllers\FetchCadenceFileController;
use App\Http\Controllers\OnboardingStatusController;
use App\Http\Controllers\PurchaseController;
use App\Http\Controllers\SignFlowMessageController;
use App\Http\Controllers\Webhooks\WebhooksController;
use App\Models\User;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::middleware('guest')->group(function () {
    Route::get('/', function () {
        return Inertia::render('Landing');
    });

    Route::post('/auth/provider-signin', [AuthenticationController::class, 'handleSigninWithProvider'])
        ->name('auth.provider-signin');
});

Route::middleware('auth')->group(function () {
    /*
    * ONBOARDING
    */
    Route::prefix('onboarding')->name('onboarding.')->group(function () {
        Route::get('/', function () {
            return Inertia::render('Onboarding/Start', [
                'purchaseUrl' => URL::temporarySignedRoute('onboarding.purchase', now()->addMinutes(5), ['user' => Auth::id()]),
            ]);
        })->middleware('onboarding-status:empty')->name('start');

        Route::post('/purchase', PurchaseController::class)
            ->middleware('signed')->name('purchase');

        Route::get('/mint', function () {
            return Inertia::render('Onboarding/MintNft');
        })->middleware('onboarding-status:'.User::ONBOARDING_STATUS_PURCHASED)->name('mint');

        Route::post('/crypto-keys', [CustodialCryptoKeysController::class, 'store'])
            ->middleware('onboarding-status:'.User::ONBOARDING_STATUS_PURCHASED)->name('crypto-keys');

        Route::put('/user-wallet', [CustodialWalletController::class, 'update'])->name('user-wallet');

        Route::get('/reveal', function () {
            return Inertia::render('Onboarding/RevealNft');
        })->middleware('onboarding-status:'.User::ONBOARDING_STATUS_MINTED)->name('reveal');

        Route::put('/status', [OnboardingStatusController::class, 'update'])->name('status');
    });

    Route::post('sign/flow/{signatureType}', SignFlowMessageController::class)
        ->whereIn('signatureType', ['admin', 'user'])->name('sign.flow');

    Route::get('/home', function () {
        return Inertia::render('Home');
    })->middleware('onboarding-status:'.User::ONBOARDING_STATUS_COMPLETED)->name('home');

    Route::post('logout', [AuthenticatedSessionController::class, 'destroy'])
        ->name('logout');
});

Route::prefix('cadence')->name('cadence.')->middleware('ajax-only')->group(function () {
    Route::get('/script', [FetchCadenceFileController::class, 'fetchScript'])->name('script');
    Route::get('/transaction', [FetchCadenceFileController::class, 'fetchTransaction'])->name('transaction');
});

Route::post('webhooks/{driver}', [WebhooksController::class, 'store'])
    ->withoutMiddleware('csrf');
