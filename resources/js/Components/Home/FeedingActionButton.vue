<script setup>
  import { ref, onBeforeMount } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import { getCurrentTimestamp } from '@/Utils/Date'
  import VueCountdown from '@chenfengyuan/vue-countdown'

  const feedingModule = useFeedingModule()
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

  const onTimerEnd = () => {
    cooldownStatus.value.cooldownActive = false
  }

  const startFeedingAction = async () => {
    await feedingModule.startAction()
  }

  onBeforeMount(async () => {
    cooldownStatus.value = await feedingModule.getFeedingCooldownStatus()
  })
</script>

<template>
  <button
    v-if="cooldownStatus"
    class="btn"
    :disabled="cooldownStatus.cooldownActive"
    @click="startFeedingAction"
  >
    <VueCountdown
      v-if="cooldownStatus.cooldownActive"
      v-slot="{ hours, minutes, seconds }"
      :time="getTimerInput()"
      :transform="transformTimerSlots"
      @end="onTimerEnd"
    >
      {{ hours }}:{{ minutes }}:{{ seconds }}
    </VueCountdown>
    <template v-else> Feed </template>
  </button>
</template>
