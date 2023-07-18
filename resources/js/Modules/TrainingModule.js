import { ref } from 'vue'
import { router } from '@inertiajs/vue3'
import { useMightyCatsGameModule } from '@/Modules/MightyCatsGameModule'
import { convertSecondsToMilliseconds, getCurrentTimestamp } from '@/Utils/Date'

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
  cooldownStatus.value = await fetchTrainingCooldownStatus()

  return cooldownStatus.value
}

const fetchTrainingCooldownStatus = async () => {
  const gameCooldownStatus = await mightyCatsGameModule.getTrainingCooldown()
  const now = getCurrentTimestamp()

  const cooldownTimeSetting = gameCooldownStatus.cooldown
  const activitiesPerCooldown = gameCooldownStatus.activities_per_cooldown
  const lastActivitiesTimestamps = gameCooldownStatus.last_activities_timestamps

  let isCooldownActive = false
  let activitiesRemaining = activitiesPerCooldown
  let lastTimestampInCooldown = null

  let response = {
    cooldownActive: isCooldownActive,
    activitiesRemaining: activitiesRemaining,
    activitiesPerCooldown: activitiesPerCooldown,
  }

  if (!lastActivitiesTimestamps || !cooldownTimeSetting) {
    return response
  }

  if (lastActivitiesTimestamps.length < activitiesPerCooldown) {
    lastActivitiesTimestamps.forEach((timestamp) => {
      if (now < convertSecondsToMilliseconds(timestamp + cooldownTimeSetting)) {
        activitiesRemaining--
        lastTimestampInCooldown = timestamp
      }
    })

    response.activitiesRemaining = activitiesRemaining
    if (activitiesRemaining < activitiesPerCooldown) {
      response.refreshTimestamp = convertSecondsToMilliseconds(
        lastTimestampInCooldown + cooldownTimeSetting
      )
    }

    return response
  }

  isCooldownActive = true
  lastActivitiesTimestamps.forEach((timestamp) => {
    if (now > convertSecondsToMilliseconds(timestamp + cooldownTimeSetting)) {
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
      lastTimestampInCooldown + cooldownTimeSetting
    )
  } else if (activitiesRemaining < activitiesPerCooldown) {
    response.refreshTimestamp = convertSecondsToMilliseconds(
      lastTimestampInCooldown + cooldownTimeSetting
    )
  }

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
