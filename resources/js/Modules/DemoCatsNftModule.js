import { withPrefix } from '@onflow/fcl'
import { useFclModule } from '@/Modules/FclModule'
import { getAuthUser } from '@/Utils/Auth'
import {
  adminAuthorization,
  userAuthorization,
} from '@/Utils/FlowAuthorizations'

const fclModule = useFclModule()

/*
 * TRANSACTIONS
 */
const mintDemoCatNftToUserAccount = async () => {
  const count = await getUserDemoCatsNftCount()

  // Only mint if account doesn't have an NFT in its collection
  if (count == 0) {
    const result = await fclModule.executeTransaction(
      'mint_demo_cat_to_custodial_account',
      (arg, t) => [arg('0', t.Int)],
      {
        payer: adminAuthorization,
        proposer: adminAuthorization,
        authorizations: [adminAuthorization, userAuthorization],
      }
    )

    if (!result.success) {
      return false
    }
  }

  const demoCatNftId = await getUserLastMintedDemoCatNftId()
  return demoCatNftId
}

/*
 * SCRIPTS
 */
const getUserDemoCatsNftCount = async () => {
  const result = await fclModule.runScript(
    'get_user_demo_cats_count',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

const getUserLastMintedDemoCatNftId = async () => {
  const result = await fclModule.runScript(
    'get_user_last_minted_demo_cat_id',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

const getUserDemoCatNftById = async (nftId) => {
  const result = await fclModule.runScript(
    'get_user_demo_cat_by_id',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
      arg(nftId, t.UInt64),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

export function useDemoCatsNftModule() {
  return {
    mintDemoCatNftToUserAccount,
    getUserDemoCatNftById,
  }
}
