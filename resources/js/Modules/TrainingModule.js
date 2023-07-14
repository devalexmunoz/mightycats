import { ref } from 'vue'
import { router } from '@inertiajs/vue3'

const options = {
  activity_status_duration: 3000,
  done_status_duration: 2000,
}

const availableActivities = ['flight-simulator', 'laser-tactics', 'meditation']
const selectedActivity = ref(null)

const status = ref(null)

const getStatus = () => {
  return status.value
}
const setStatus = (newStatus) => {
  status.value = newStatus
}
const resetStatus = () => {
  setStatus('idle')
  selectedActivity.value = null
}

const confirmIntent = () => {
  setStatus('awaiting-confirm')
}

const startActivity = () => {
  setStatus('training')
  setTimeout(endActivity, options.activity_status_duration)
}

const endActivity = () => {
  setStatus('done')
  setTimeout(showResults, options.done_status_duration)
}

const showResults = () => {
  setStatus('results')
}

const triggerActivitySelection = () => {
  setStatus('selecting-activity')
  router.get(route('training.selector'))
}

const getAvailableActivities = () => {
  return availableActivities
}

const selectRandomActivity = () => {
  setStatus('activity-selected')
  const randomActivity =
    availableActivities[Math.floor(Math.random() * availableActivities.length)]

  selectedActivity.value = randomActivity
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
  }
}
