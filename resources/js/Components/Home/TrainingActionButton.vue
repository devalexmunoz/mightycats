<script setup>
  import { ref, onBeforeMount, onBeforeUnmount } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import { getCurrentTimestamp } from '@/Utils/Date'
  import VueCountdown from '@chenfengyuan/vue-countdown'

  const trainingModule = useTrainingModule()
  const cooldownStatus = ref(null)

  const getTimerInput = () => {
    return cooldownStatus.value.cooldownEndTimestamp - getCurrentTimestamp()
  }

  const transformTimerSlots = (props) => {
    const formattedProps = {}

    Object.entries(props).forEach(([key, value]) => {
      formattedProps[key] = value < 10 ? `0${value}` : String(value)
    })

    return formattedProps
  }

  const onCooldownTimerEnd = () => {
    refreshCooldownStatus()
  }

  const refreshCooldownStatus = async () => {
    cooldownStatus.value = await trainingModule.getTrainingCooldownStatus()
  }

  const confirmTrainingAction = async () => {
    trainingModule.confirmIntent()
  }

  let refreshTimeoutRef = null
  onBeforeMount(async () => {
    cooldownStatus.value = await trainingModule.getTrainingCooldownStatus()
    if (
      !cooldownStatus.value.cooldownActive &&
      cooldownStatus.value.refreshTimestamp
    ) {
      refreshTimeoutRef = setTimeout(
        refreshCooldownStatus,
        cooldownStatus.value.refreshTimestamp - getCurrentTimestamp()
      )
    }
  })

  onBeforeUnmount(() => {
    clearTimeout(refreshTimeoutRef)
  })
</script>

<template>
  <button
    v-if="cooldownStatus"
    class="btn"
    :disabled="cooldownStatus.cooldownActive"
    @click="confirmTrainingAction"
  >
    <VueCountdown
      v-if="cooldownStatus.cooldownActive"
      v-slot="{ hours, minutes, seconds }"
      :time="getTimerInput()"
      :transform="transformTimerSlots"
      @end="onCooldownTimerEnd"
    >
      {{ hours }}:{{ minutes }}:{{ seconds }}
    </VueCountdown>
    <template v-else>
      Training
      <span v-if="cooldownStatus"
        >({{ cooldownStatus.activitiesRemaining }})</span
      >
    </template>
  </button>
</template>
