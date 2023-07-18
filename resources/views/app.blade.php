<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title inertia>{{ config('app.name') }}</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=lilita-one:400|montserrat:400,600,700,800,900&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    {!! \App\Helpers\ViteCdnHelper::loadAssets(['resources/js/app.js']) !!}
    @inertiaHead
</head>
<body>
@inertia
</body>
</html>
