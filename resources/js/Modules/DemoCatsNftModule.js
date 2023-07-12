import { withPrefix } from '@onflow/fcl'
import { useFclModule } from '@/Modules/FclModule'
import { getAuthUser } from '@/Utils/Auth'
import {
  adminAuthorization,
  userAuthorization,
} from '@/Utils/FlowAuthorizations'
import MINT_DEMOCAT_TO_CUSTODIAL_ACCOUNT from '@resources/cadence/transactions/mintDemoCatToCustodialAccount'
import GET_USER_DEMO_CATS_COUNT from '@resources/cadence/scripts/getUserDemoCatsCount'
import GET_USER_LAST_MINTED_DEMO_CAT_ID from '@resources/cadence/scripts/getUserLastMintedDemoCatId'
import GET_USER_DEMO_CAT_BY_ID from '@resources/cadence/scripts/getUserDemoCatById'

const fclModule = useFclModule()

/*
 * TRANSACTIONS
 */
const mintDemoCatNftToUserAccount = async () => {
  const count = await getUserDemoCatsNftCount()

  // Only mint if account doesn't have an NFT in its collection
  if (count == 0) {
    const result = await fclModule.executeTransaction(
      MINT_DEMOCAT_TO_CUSTODIAL_ACCOUNT,
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
    GET_USER_DEMO_CATS_COUNT,
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
    GET_USER_LAST_MINTED_DEMO_CAT_ID,
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
    GET_USER_DEMO_CAT_BY_ID,
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
