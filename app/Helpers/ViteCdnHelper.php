<?php

namespace App\Helpers;

use Illuminate\Foundation\Vite;

class ViteCdnHelper
{
    public static function loadAssets($assets = []): string
    {
        $cdnMode = (bool) config('app.asset_url');

        $buildDirectory = $cdnMode ? '' : 'assets';
        $manifestPath = ($cdnMode ? 'assets/' : '').'manifest.json';

        return (new Vite)->useBuildDirectory($buildDirectory)
            ->useManifestFilename($manifestPath)
            ->withEntryPoints($assets)
            ->toHtml();
    }
}
