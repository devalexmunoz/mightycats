import { ref } from 'vue'
import { useMightyCatsGameModule } from '@/Modules/MightyCatsGameModule'
import {
  getCurrentTimestamp,
  convertSecondsToMilliseconds,
} from '@/Utils/Date.js'

const options = {
  end_status_duration: 1500,
}

const mightyCatsGameModule = useMightyCatsGameModule()

const status = ref(null)
const postFeedingStats = ref(null)

const getStatus = () => {
  return status.value
}
const setStatus = (newStatus) => {
  status.value = newStatus
}
const resetStatus = () => {
  setStatus('idle')
  postFeedingStats.value = null
}

const startAction = async () => {
  setStatus('feeding')
  const result = await registerFeedingAction()
  if (!result) {
    setStatus('error')
    return
  }

  await endAction()
}

const endAction = async () => {
  setStatus('done')
  const result = await fetchPostFeedingStats()
  if (!result) {
    setStatus('error')
    return
  }

  setTimeout(showResults, options.end_status_duration)
}

const showResults = () => {
  setStatus('results')
}

const getFeedingCooldownStatus = async () => {
  const gameCooldownStatus = await mightyCatsGameModule.getFeedingCooldown()
  const now = getCurrentTimestamp()

  let response = { cooldownActive: false }
  if (gameCooldownStatus.last_fed_timestamp && gameCooldownStatus.cooldown) {
    const cooldownEndTimestamp = convertSecondsToMilliseconds(
      gameCooldownStatus.last_fed_timestamp + gameCooldownStatus.cooldown
    )
    const isCooldownActive = now < cooldownEndTimestamp
    if (isCooldownActive) {
      response.cooldownActive = isCooldownActive
      response.cooldownEndTimestamp = cooldownEndTimestamp
    }
  }

  return response
}

const registerFeedingAction = async () => {
  return await mightyCatsGameModule.registerFeeding()
}

const fetchPostFeedingStats = async () => {
  const stats = await mightyCatsGameModule.getPostFeedingStats()
  if (!stats) {
    return false
  }

  postFeedingStats.value = stats
  return true
}

const getPostFeedingStats = () => {
  return postFeedingStats.value
}

export function useFeedingModule() {
  return {
    getStatus,
    resetStatus,

    startAction,

    getFeedingCooldownStatus,
    getPostFeedingStats,
  }
}
