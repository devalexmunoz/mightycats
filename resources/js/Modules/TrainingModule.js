import { ref } from 'vue'
import { router } from '@inertiajs/vue3'
import { useMightyCatsGameModule } from '@/Modules/MightyCatsGameModule'
import {
  convertSecondsToMilliseconds,
  getCurrentTimestamp,
} from '@/Utils/Date.js'

const options = {
  end_status_duration: 1500,
}

const mightyCatsGameModule = useMightyCatsGameModule()

const availableActivities = ref([])
const selectedActivity = ref(null)

const status = ref(null)
const cooldownStatus = ref(null)
const postTrainingStats = ref(null)

const getStatus = () => {
  return status.value
}
const setStatus = (newStatus) => {
  status.value = newStatus
}
const resetStatus = () => {
  setStatus('idle')
  selectedActivity.value = null
  postTrainingStats.value = null
}

const confirmIntent = () => {
  setStatus('awaiting-confirm')
}

const startActivity = async () => {
  setStatus('training')
  const result = await registerTrainingActivity()
  if (!result) {
    setStatus('error')
    return
  }

  await endActivity()
}

const endActivity = async () => {
  setStatus('done')
  const result = await fetchPostTrainingStats()
  if (!result) {
    setStatus('error')
    return
  }

  setTimeout(showResults, options.end_status_duration)
}

const showResults = () => {
  setStatus('results')
}

const triggerActivitySelection = () => {
  setStatus('selecting-activity')
  router.get(route('training.selector'))
}

const getAvailableActivities = async () => {
  const activities = await mightyCatsGameModule.getAvailableTrainingActivities()
  availableActivities.value = activities

  return activities
}

const selectRandomActivity = async () => {
  if (!availableActivities.value) {
    return null
  }

  const randomActivity = await axios
    .post(route('random-pick'), { options_pool: availableActivities.value })
    .then((response) => response.data.pick)

  if (!randomActivity) {
    return null
  }

  selectedActivity.value = randomActivity
  setStatus('activity-selected')

  return randomActivity
}

const getSelectedActivity = () => {
  return selectedActivity.value
}

const goToSelectedActivity = () => {
  if (!selectedActivity.value) {
    return
  }

  router.get(route('training.activity'))
}

const getTrainingCooldownStatus = async () => {
  const gameCooldownStatus = await mightyCatsGameModule.getTrainingCooldown()
  const now = getCurrentTimestamp()

  let isCooldownActive = false
  let activitiesRemaining = gameCooldownStatus.activities_per_cooldown
  let lastTimestampInCooldown = null
  const activitiesPerCooldown = gameCooldownStatus.activities_per_cooldown
  let response = {
    cooldownActive: isCooldownActive,
    activitiesRemaining: activitiesRemaining,
    activitiesPerCooldown: activitiesPerCooldown,
  }

  if (
    gameCooldownStatus.last_activities_timestamps &&
    gameCooldownStatus.cooldown
  ) {
    isCooldownActive = true
    gameCooldownStatus.last_activities_timestamps.forEach((timestamp) => {
      if (
        now >
        convertSecondsToMilliseconds(timestamp + gameCooldownStatus.cooldown)
      ) {
        isCooldownActive = false
        return
      } else {
        activitiesRemaining--
        lastTimestampInCooldown = timestamp
      }
    })

    response.cooldownActive = isCooldownActive
    response.activitiesRemaining = activitiesRemaining

    if (isCooldownActive) {
      response.cooldownEndTimestamp = convertSecondsToMilliseconds(
        lastTimestampInCooldown + gameCooldownStatus.cooldown
      )
    } else if (activitiesRemaining < activitiesPerCooldown) {
      response.refreshTimestamp = convertSecondsToMilliseconds(
        lastTimestampInCooldown + gameCooldownStatus.cooldown
      )
    }
  }

  cooldownStatus.value = response

  return response
}

const registerTrainingActivity = async () => {
  return await mightyCatsGameModule.registerTraining(selectedActivity.value)
}

const fetchPostTrainingStats = async () => {
  const stats = await mightyCatsGameModule.getPostTrainingStats(
    selectedActivity.value
  )
  if (!stats) {
    return false
  }

  postTrainingStats.value = stats
  return true
}

const getPostTrainingStats = () => {
  return postTrainingStats.value
}

export function useTrainingModule() {
  return {
    getStatus,
    resetStatus,

    confirmIntent,
    triggerActivitySelection,

    getAvailableActivities,
    selectRandomActivity,
    getSelectedActivity,
    goToSelectedActivity,

    startActivity,

    cooldownStatus,
    getTrainingCooldownStatus,
    getPostTrainingStats,
  }
}
