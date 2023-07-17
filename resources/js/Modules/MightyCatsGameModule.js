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

const registerTraining = async (activity) => {
  const result = await fclModule.executeTransaction(
    'gameplay/register_training',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
      arg(activity.id, t.UInt64),
    ],
    {
      limit: 100,
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
  formattedResult.last_fed_timestamp = result.result.last_fed_timestamp
    ? parseInt(result.result.last_fed_timestamp)
    : null
  formattedResult.cooldown = result.result.cooldown
    ? parseInt(result.result.cooldown)
    : null

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

const getTrainingCooldown = async () => {
  const result = await fclModule.runScript(
    'gameplay/get_training_cooldown',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
    ]
  )

  if (!result.success) {
    return null
  }

  let formattedResult = {}
  formattedResult.last_activities_timestamps = result.result
    .last_activities_timestamps
    ? result.result.last_activities_timestamps.map((timestamp) =>
        parseInt(timestamp)
      )
    : null
  formattedResult.cooldown = result.result.cooldown
    ? parseInt(result.result.cooldown)
    : null
  formattedResult.activities_per_cooldown = result.result
    .activities_per_cooldown
    ? parseInt(result.result.activities_per_cooldown)
    : null

  return formattedResult
}

const getAvailableTrainingActivities = async () => {
  const result = await fclModule.runScript(
    'gameplay/get_available_training_activities',
    []
  )

  if (!result.success) {
    return null
  }

  let parsedResult = []
  for (let key in result.result) {
    parsedResult.push(result.result[key])
  }

  return parsedResult
}

const getPostTrainingStats = async (activity) => {
  const result = await fclModule.runScript(
    'gameplay/get_post_training_stats',
    (arg, t) => [
      arg(withPrefix(getAuthUser().custodial_wallet_address), t.Address),
      arg(getAuthUser().minted_nft_id, t.UInt64),
      arg(activity.id, t.UInt64),
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

    getTrainingCooldown,
    getAvailableTrainingActivities,
    registerTraining,
    getPostTrainingStats,
  }
}
