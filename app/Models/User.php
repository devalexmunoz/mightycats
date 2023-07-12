<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

/**
 * @property string $auth_provider
 * @property int $auth_provider_id
 * @property string $email
 * @property datetime $email_verified_at
 * @property string $custodial_wallet_address
 * @property string $onboarding_status
 * @property bool $has_completed_onboarding
 * @property bool $has_custodial_wallet
 */
class User extends Authenticatable
{
    use HasUuids, HasFactory, Notifiable;

    public const ONBOARDING_STATUS_PURCHASED = 'nft-purchased';

    public const ONBOARDING_STATUS_MINTED = 'nft-minted';

    public const ONBOARDING_STATUS_REVEALED = 'nft-revealed';

    public const ONBOARDING_STATUS_COMPLETED = self::ONBOARDING_STATUS_REVEALED;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'auth_provider',
        'auth_provider_id',
        'email',
        'email_verified_at',
        'custodial_wallet_address',
        'onboarding_status',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected function getHasCompletedOnboardingAttribute()
    {
        return $this->onboarding_status = $this::ONBOARDING_STATUS_COMPLETED;
    }

    protected function getCustodialKeyIdAttribute()
    {
        return $this->id;
    }

    protected function getHasCustodialWalletAttribute()
    {
        return ! empty($this->custodial_wallet_address);
    }

    protected function getHasMintedNftAttribute()
    {
        // TODO: FIX THIS
        return ! empty($this->custodial_wallet_address);
    }
}
