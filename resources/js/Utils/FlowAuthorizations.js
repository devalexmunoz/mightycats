import { getAuthUser } from '@/Utils/Auth'

export const adminAuthorization = async (account) => {
  const address = getViteEnv('FLOW_ADMIN_ACCOUNT_ADDRESS')
  const keyIndex = 0

  return {
    ...account,
    tempId: `${address}-${keyIndex}`,
    addr: address,
    keyId: Number(keyIndex),
    signingFunction: async (signable) => {
      // Singing functions are passed a signable and need to return a composite signature
      // signable.message is a hex string of what needs to be signed.
      const signature = await axios
        .post(route('sign.flow', 'admin'), { message: signable.message })
        .then((response) => response.data)

      return {
        addr: address,
        keyId: Number(keyIndex),
        signature: signature,
      }
    },
  }
}

export const userAuthorization = async (account) => {
  const address = getAuthUser().custodial_wallet_address
  const keyIndex = 0

  return {
    ...account,
    tempId: `${address}-${keyIndex}`,
    addr: address,
    keyId: Number(keyIndex),
    signingFunction: async (signable) => {
      // Singing functions are passed a signable and need to return a composite signature
      // signable.message is a hex string of what needs to be signed.
      const signature = await axios
        .post(route('sign.flow', 'user'), { message: signable.message })
        .then((response) => response.data)

      return {
        addr: address,
        keyId: Number(keyIndex),
        signature: signature,
      }
    },
  }
}
