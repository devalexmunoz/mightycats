import { withPrefix } from '@onflow/fcl'
import { useFclModule } from '@/Modules/FclModule'
import { getAuthUser } from '@/Utils/Auth'
import { adminAuthorization } from '@/Utils/FlowAuthorizations.js'

const fclModule = useFclModule()

/*
 * TRANSACTIONS
 */
const registerFeeding = async () => {
  const result = await fclModule.executeTransaction(
    'gameplay/register_feeding',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ],
    {
      payer: adminAuthorization,
      proposer: adminAuthorization,
      authorizations: [adminAuthorization],
    }
  )

  if (!result.success) {
    return false
  }

  return true
}

/*
 * SCRIPTS
 */
const getFeedingCooldown = async () => {
  const result = await fclModule.runScript(
    'gameplay/get_feeding_cooldown',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  let formattedResult = {}
  formattedResult.last_fed_timestamp = parseInt(
    result.result.last_fed_timestamp
  )
  formattedResult.cooldown = parseInt(result.result.cooldown)

  return formattedResult
}

const getPostFeedingStats = async () => {
  const result = await fclModule.runScript(
    'gameplay/get_post_feeding_stats',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
      arg(getAuthUser().minted_nft_id, t.UInt64),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

export function useMightyCatsGameModule() {
  return {
    getFeedingCooldown,
    registerFeeding,
    getPostFeedingStats,
  }
}
