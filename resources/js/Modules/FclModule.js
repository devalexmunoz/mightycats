import * as fcl from '@onflow/fcl'
import { ref } from 'vue'
import flowJSON from '@storage/flow/flow.json'

const isInitialized = ref(false)

const init = async () => {
  if (isInitialized.value) {
    return
  }

  const flowNetwork = getViteEnv('FLOW_NETWORK')
  const accessNodeApi = getViteEnv('FLOW_ACCESS_NODE_API')

  await fcl
    .config({
      'flow.network': flowNetwork,
      'accessNode.api': accessNodeApi,
      'discovery.wallet': `https://fcl-discovery.onflow.org/${flowNetwork}/authn`,
    })
    .load({ flowJSON })

  isInitialized.value = true
}

const runScript = async (cadence, args, limit) => {
  await init()

  let response = {}
  const result = await fcl
    .query({
      cadence,
      args,
      limit: limit || 50,
    })
    .catch((error) => {
      response = { error: true, errorMessage: error }
    })

  if (!result) {
    return response
  }

  return { result, success: true }
}

const executeTransaction = async (cadence, args, options) => {
  await init()

  let response = {}
  const transactionId = await fcl
    .mutate({
      cadence,
      args,
      payer: options.payer || fcl.authz,
      proposer: options.proposer || fcl.authz,
      authorizations: options.authorizations || [fcl.authz],
      limit: options.limit || 50,
    })
    .catch((error) => {
      response = { error: true, errorMessage: error }
    })

  if (!transactionId) {
    return response
  }

  response = { transactionId }

  const transaction = await fcl
    .tx(transactionId)
    .onceSealed()
    .catch((error) => {
      response = { ...response, error: true, errorMessage: error }
    })

  if (!transaction) {
    return response
  }

  return { ...response, transaction, success: true }
}

export function useFclModule() {
  return {
    runScript,
    executeTransaction,
  }
}
