import { ref } from 'vue'

const options = {
  feeding_status_duration: 3000,
  done_status_duration: 2000,
}

const status = ref(null)

const getStatus = () => {
  return status.value
}
const setStatus = (newStatus) => {
  status.value = newStatus
}
const resetStatus = () => {
  setStatus('idle')
}

const startAction = () => {
  setStatus('feeding')
  setTimeout(endAction, options.feeding_status_duration)
}

const endAction = () => {
  setStatus('done')
  setTimeout(showResults, options.done_status_duration)
}

const showResults = () => {
  setStatus('results')
}

export function useFeedingModule() {
  return {
    getStatus,
    resetStatus,

    startAction,
  }
}
