<?php

namespace App\Helpers;

class MightyCatNftHelper
{
    protected static $versions = [
        [
            'version' => '0',
            'nickname' => 'Pelusa',
            'gender' => 'F',
            'about' => 'Lorem impsum...',
        ],
        [
            'version' => '1',
            'nickname' => 'Cotton',
            'gender' => 'F',
            'about' => 'Lorem impsum...',
        ],
        [
            'version' => '2',
            'nickname' => 'Salem',
            'gender' => 'M',
            'about' => 'Lorem impsum...',
        ],
    ];

    public static function getRandomVersion()
    {
        $randomIndex = random_int(0, count(self::$versions) - 1);

        return self::$versions[$randomIndex];
    }
}
