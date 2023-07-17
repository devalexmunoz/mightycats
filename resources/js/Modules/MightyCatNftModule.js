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
const mintMightyCatNftToUserAccount = async (nftProps) => {
  const count = await getUserMightyCatNftCount()

  // Only mint if account doesn't have an NFT in its collection
  if (count == 0) {
    const result = await fclModule.executeTransaction(
      'mint_mighty_cat_to_custodial_account',
      (arg, t) => [
        arg(nftProps.version, t.UInt64),
        arg(nftProps.nickname, t.String),
        arg(nftProps.gender, t.String),
        arg(nftProps.about, t.String),
      ],
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

  const mightyCatNftId = await getUserLastMintedMightyCatNftId()
  return mightyCatNftId
}

/*
 * SCRIPTS
 */
const getUserMightyCatNftCount = async () => {
  const result = await fclModule.runScript(
    'get_user_mighty_cat_count',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

const getUserLastMintedMightyCatNftId = async () => {
  const result = await fclModule.runScript(
    'get_user_last_minted_mighty_cat_id',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

const getUserMightyCatNftById = async (nftId) => {
  const result = await fclModule.runScript(
    'get_user_mighty_cat_by_id',
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

export function useMightyCatNftModule() {
  return {
    mintMightyCatNftToUserAccount,
    getUserMightyCatNftById,
  }
}
