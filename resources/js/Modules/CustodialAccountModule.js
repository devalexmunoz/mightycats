import { withPrefix } from '@onflow/fcl'
import { useFclModule } from '@/Modules/FclModule'
import { getAuthUser, updateAuthUserProps } from '@/Utils/Auth'
import { adminAuthorization } from '@/Utils/FlowAuthorizations'
import CREATE_CUSTODIAL_ACCOUNT from '@resources/cadence/transactions/createCustodialAccount'
import GET_CUSTODIAL_ACCOUNT_ADDRESS_IN_DIRECTORY from '@resources/cadence/scripts/getCustodialAccountAddressInDirectory'

const fclModule = useFclModule()

/*
 * TRANSACTIONS
 */
const createCustodialAccount = async () => {
  const publicKey = await createCustodialKeys()

  // Check if there's an existing account address based on publicKey and return it if found
  let custodialAccountAddress = await getCustodialAccountAddress(publicKey)
  if (custodialAccountAddress) {
    if (!getAuthUser().custodial_wallet_address) {
      // Edge-case: User has a wallet, but it isn't saved in DB
      await storeCreatedWalletAddress(custodialAccountAddress)
    }
    return custodialAccountAddress
  }

  // Execute transaction to create and fund new custodial account
  const result = await fclModule.executeTransaction(
    CREATE_CUSTODIAL_ACCOUNT,
    (arg, t) => [arg(publicKey, t.String), arg('1.0', t.UFix64)],
    {
      // TODO: Figure out the appropriate limit
      limit: 500,
      payer: adminAuthorization,
      proposer: adminAuthorization,
      authorizations: [adminAuthorization],
    }
  )

  if (!result.success) {
    return false
  }

  // Fetch new account address and save it to user model
  custodialAccountAddress = await getCustodialAccountAddress(publicKey)
  await storeCreatedWalletAddress(custodialAccountAddress)

  return custodialAccountAddress
}

/*
 * SCRIPTS
 */
const getCustodialAccountAddress = async (publicKey) => {
  const adminAddress = getViteEnv('FLOW_ADMIN_ACCOUNT_ADDRESS')

  const result = await fclModule.runScript(
    GET_CUSTODIAL_ACCOUNT_ADDRESS_IN_DIRECTORY,
    (arg, t) => [
      arg(withPrefix(adminAddress), t.Address),
      arg(publicKey, t.String),
    ]
  )

  if (!result.success) {
    return null
  }

  return result.result
}

/*
 * UTIL
 */

const createCustodialKeys = async () => {
  const createdPublicKey = await axios
    .post(route('onboarding.crypto-keys'))
    .then((response) => response.data.publicKey)
    .catch(() => {})

  if (!createdPublicKey) {
    return false
  }

  return createdPublicKey
}

const storeCreatedWalletAddress = async (walletAddress) => {
  const success = await axios
    .put(route('onboarding.user-wallet'), { wallet_address: walletAddress })
    .then((response) => {
      if (response.data.success) {
        // This ajax call updates user model properties, so we need to reflect those changes on the current authUser
        updateAuthUserProps({
          custodial_wallet_address: response.data.walletAddress,
        })
      }

      return response.data.success
    })
    .catch(() => {})

  return success === true
}

export function useCustodialAccountModule() {
  return {
    createCustodialAccount,
  }
}
