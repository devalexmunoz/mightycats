<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="apple-touch-icon" sizes="180x180" href="meta/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="meta/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="meta/favicon-16x16.png">
    <link rel="manifest" href="meta/site.webmanifest">
    <link rel="mask-icon" href="meta/safari-pinned-tab.svg" color="#5cdbf8">
    <meta name="msapplication-TileColor" content="#181b56">
    <meta name="theme-color" content="#181b56">

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
