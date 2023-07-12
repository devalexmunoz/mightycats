<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'google' => [
        'client_id' => env('GOOGLE_CLIENT_ID'),
        'client_secret' => env('GOOGLE_CLIENT_SECRET'),
        'application_credentials_path' => env('GOOGLE_APPLICATION_CREDENTIALS'),
    ],

    'cloud_kms' => [
        'project' => env('CLOUD_KMS_PROJECT'),
        'location' => env('CLOUD_KMS_LOCATION'),
        'admin_key_ring' => env('CLOUD_KMS_ADMIN_KEY_RING'),
        'admin_key' => env('CLOUD_KMS_ADMIN_KEY'),
        'custodial_key_ring' => env('CLOUD_KMS_CUSTODIAL_KEY_RING'),
    ],

    'stripe' => [
        'secret_key' => env('STRIPE_SECRET_KEY'),
        'webhook_secret' => env('STRIPE_WEBHOOK_SECRET'),
        'purchase_price_id' => env('STRIPE_PURCHASE_PRICE_ID'),
    ],

];
