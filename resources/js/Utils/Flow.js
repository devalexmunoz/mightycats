import { withPrefix } from '@onflow/fcl'

export const buildFlowviewAccountUrl = (account) => {
  const flowEnv = getViteEnv('FLOW_NETWORK')

  return `https://${
    flowEnv !== 'mainnet' ? flowEnv + '.' : ''
  }flowview.app/account/${withPrefix(account)}`
}
