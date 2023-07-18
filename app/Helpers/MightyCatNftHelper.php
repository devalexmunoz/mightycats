<?php

namespace App\Helpers;

class MightyCatNftHelper
{
    protected static $versions = [
        [
            'version' => '0',
            'nickname' => 'Pelusa',
            'gender' => 'F',
            'about' => 'A curious Calico that loves to chase and hunt',
        ],
        [
            'version' => '1',
            'nickname' => 'Cotton',
            'gender' => 'F',
            'about' => 'A white furred kitten that loves to nap',
        ],
        [
            'version' => '2',
            'nickname' => 'Salem',
            'gender' => 'M',
            'about' => 'A dark furred kitten that loves to play',
        ],
    ];

    public static function getRandomVersion()
    {
        $randomIndex = random_int(0, count(self::$versions) - 1);

        return self::$versions[$randomIndex];
    }
}
