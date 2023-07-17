import * as fcl from '@onflow/fcl'
import { ref } from 'vue'
import {
  fetchCadenceScript,
  fetchCadenceTransaction,
} from '@/Utils/FetchCadenceFiles'
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

const runScript = async (scriptFilename, args, limit) => {
  await init()

  let response = {}

  const script = await fetchCadenceScript(scriptFilename)
  const result = await fcl
    .query({
      cadence: script,
      args: args,
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

const executeTransaction = async (transactionFilename, args, options) => {
  await init()

  let response = {}

  const transaction = await fetchCadenceTransaction(transactionFilename)
  const transactionId = await fcl
    .mutate({
      cadence: transaction,
      args: args,
      payer: options.payer || fcl.authz,
      proposer: options.proposer || fcl.authz,
      authorizations: options.authorizations || [fcl.authz],
      limit: options.limit || 100,
    })
    .catch((error) => {
      response = { error: true, errorMessage: error }
    })

  if (!transactionId) {
    return response
  }

  response = { transactionId }

  const transactionResult = await fcl
    .tx(transactionId)
    .onceSealed()
    .catch((error) => {
      response = { ...response, error: true, errorMessage: error }
    })

  if (!transactionResult) {
    return response
  }

  return { ...response, transactionResult, success: true }
}

export function useFclModule() {
  return {
    runScript,
    executeTransaction,
  }
}
