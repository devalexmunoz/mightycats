<?php

namespace App\Helpers;

use Google\ApiCore\ApiException;
use Google\Cloud\Kms\V1\CryptoKey;
use Google\Cloud\Kms\V1\CryptoKey\CryptoKeyPurpose;
use Google\Cloud\Kms\V1\CryptoKeyVersion\CryptoKeyVersionAlgorithm;
use Google\Cloud\Kms\V1\CryptoKeyVersionTemplate;
use Google\Cloud\Kms\V1\Digest;
use Google\Cloud\Kms\V1\KeyManagementServiceClient;
use Google\Cloud\Kms\V1\ProtectionLevel;
use Sop\ASN1\Type\UnspecifiedType;

class FlowCloudKmsHelper
{
    protected static $project;

    protected static $location;

    protected static $adminKeyRing;

    protected static $adminKey;

    protected static $custodialKeyRing;

    protected static $kmsClient;

    protected static $initialized = false;

    public static function createCustodialKey($keyId)
    {
        self::init();

        $keyRingName = self::$kmsClient->keyRingName(self::$project, self::$location, self::$custodialKeyRing);

        $keyName = self::$kmsClient->cryptoKeyName(self::$project, self::$location, self::$custodialKeyRing, $keyId);
        try {
            // Fetch existing key before attempting to create one
            self::$kmsClient->getCryptoKey($keyName);
        } catch (ApiException $e) {
            if ($e->getStatus() === 'NOT_FOUND') {
                $keyConfig = (new CryptoKey())
                    ->setPurpose(CryptoKeyPurpose::ASYMMETRIC_SIGN)
                    ->setVersionTemplate((new CryptoKeyVersionTemplate())
                        ->setAlgorithm(CryptoKeyVersionAlgorithm::EC_SIGN_P256_SHA256)
                        ->setProtectionLevel(ProtectionLevel::SOFTWARE)
                    );

                self::$kmsClient->createCryptoKey($keyRingName, $keyId, $keyConfig);
            }
        }

        return self::getCustodialPublicKey($keyId);
    }

    public static function getCustodialPublicKey($keyId, $version = 1)
    {
        self::init();

        $keyVersionName = self::$kmsClient->cryptoKeyVersionName(self::$project, self::$location, self::$custodialKeyRing, $keyId, $version);

        $publicKey = self::$kmsClient->getPublicKey($keyVersionName);

        return self::keyPemToHex($publicKey->getPem());
    }

    public static function getAdminPublicKey($version = 1)
    {
        self::init();

        $keyVersionName = self::$kmsClient->cryptoKeyVersionName(self::$project, self::$location, self::$adminKeyRing, self::$adminKey, $version);

        $publicKey = self::$kmsClient->getPublicKey($keyVersionName);

        return self::keyPemToHex($publicKey->getPem());
    }

    public static function signWithCustodialKey($message, $keyId, $version = 1)
    {
        self::init();

        return self::sign($message, self::$custodialKeyRing, $keyId, $version);
    }

    public static function signWithAdminKey($message)
    {
        self::init();

        return self::sign($message, self::$adminKeyRing, self::$adminKey);
    }

    protected static function init()
    {
        if (self::$initialized) {
            return;
        }

        self::$project = config('services.cloud_kms.project');
        self::$location = config('services.cloud_kms.location');
        self::$adminKeyRing = config('services.cloud_kms.admin_key_ring');
        self::$adminKey = config('services.cloud_kms.admin_key');
        self::$custodialKeyRing = config('services.cloud_kms.custodial_key_ring');

        self::$kmsClient = new KeyManagementServiceClient([
            // For some reason the env variable for Google Credentials is not being recognized during execution
            // even though it is set and readable on Docker, so we have to set client credentials manually
            'keyFile' => config('services.google.application_credentials_path'),
        ]);

        self::$initialized = true;
    }

    protected static function sign($message, $keyRing, $keyId, $version = 1)
    {
        $keyVersionName = self::$kmsClient->cryptoKeyVersionName(self::$project, self::$location, $keyRing, $keyId, $version);

        $hash = hash('sha256', hex2bin($message), true);

        $digest = (new Digest())->setSha256($hash);

        $signResponse = self::$kmsClient->asymmetricSign($keyVersionName, $digest);

        return self::asn1SignatureToHex($signResponse->getSignature());
    }

    /*
     * UTILITIES
     */
    protected static function keyPemToHex($pem)
    {
        $key = openssl_pkey_get_public($pem);
        $keyDetails = openssl_pkey_get_details($key);

        $x = bin2hex($keyDetails['ec']['x']);
        $y = bin2hex($keyDetails['ec']['y']);

        $hex = $x.$y;

        return $hex;
    }

    protected static function asn1SignatureToHex($signature)
    {
        $sequence = UnspecifiedType::fromDER($signature)->asSequence();

        $r = $sequence->at(0)->asInteger()->number();
        $s = $sequence->at(1)->asInteger()->number();

        $hex = self::uint8ArrayToHex(array_merge(self::numberToUint8Array($r), self::numberToUint8Array($s)));

        return $hex;
    }

    protected static function numberToUint8Array($number, $endianness = 'be', $size = 32)
    {
        $number = gmp_init($number);

        $array = [];
        for ($i = 0; $i < $size; $i++) {
            $array[$i] = (int) gmp_div_r($number, 256);
            $number = gmp_div_q($number, 256);
        }

        if ($endianness === 'be') {
            $array = array_reverse($array);
        }

        return $array;
    }

    protected static function uint8ArrayToHex($array)
    {
        return array_reduce($array, function ($hex, $int) {
            return $hex.str_pad(dechex($int), 2, '0', STR_PAD_LEFT);
        });
    }
}
