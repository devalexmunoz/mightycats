<script setup>
  import { ref, onBeforeMount, onBeforeUnmount } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import { getCurrentTimestamp } from '@/Utils/Date'
  import VueCountdown from '@chenfengyuan/vue-countdown'
  import BatteryIndicator from '@/Components/Training/BatteryIndicator.vue'

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
    class="btn btn-primary btn-yellow"
    :disabled="cooldownStatus.cooldownActive"
    @click="confirmTrainingAction"
  >
    <BatteryIndicator
      :activities-remaining="cooldownStatus.activitiesRemaining"
    />
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
      <span> Training </span>
    </template>
  </button>
</template>

<style lang="scss" scoped>
  .battery-indicator {
    position: absolute;
    top: 0;
    left: 50%;
    z-index: 3;

    margin-top: -1.3rem;

    transform: translate(-50%, 0) scale(0.7);
  }
</style>
