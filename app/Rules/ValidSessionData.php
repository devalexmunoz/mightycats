<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class ValidSessionData implements ValidationRule
{
    protected $allowedSessionKeys = [
        'user_nft' => [
            'type' => 'array',
            'allowed_array_keys' => ['version', 'nickname', 'gender', 'about', 'xp', 'level', 'levelProgress', 'thumbnail', 'itemID', 'resourceID', 'owner'],
        ],
    ];

    /**
     * Run the validation rule.
     *
     * @param  \Closure(string): \Illuminate\Translation\PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        $sessionData = json_decode(base64_decode($value), true);

        foreach ($sessionData as $sessionKey => $sessionValue) {
            if (! in_array($sessionKey, array_keys($this->allowedSessionKeys))) {
                $fail('The :attribute contains invalid session keys.');
            }

            $sessionValueType = gettype($sessionValue);

            if ($sessionValueType !== $this->allowedSessionKeys[$sessionKey]['type']) {
                $fail('The :attribute contains invalid session values.');
            }

            if ($sessionValueType === 'array') {
                foreach (array_keys($sessionValue) as $key) {
                    if (! in_array($key, $this->allowedSessionKeys[$sessionKey]['allowed_array_keys'])) {
                        $fail('The :attribute contains invalid session values.');
                    }
                }
            }
        }
    }
}
