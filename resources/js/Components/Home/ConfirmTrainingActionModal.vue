<script setup>
  import { ref } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import { getCurrentTimestamp } from '@/Utils/Date'
  import VueCountdown from '@chenfengyuan/vue-countdown'
  import BaseModal from '@/Components/BaseModal.vue'
  import BatteryIndicator from '@/Components/Training/BatteryIndicator.vue'

  import imgRandom from '@img/training/img-random.png'

  const emit = defineEmits(['confirm', 'cancel'])

  // TODO: Find a way to automatically proxy BaseModal methods
  const modal = ref(null)

  const trainingModule = useTrainingModule()

  // TODO: Find a better way to manage reactive cooldown status
  const cooldownStatus = trainingModule.cooldownStatus

  const open = () => {
    modal.value.open()
  }
  const close = () => {
    modal.value.close()
  }
  const cancel = () => {
    emit('cancel')
    close()
  }
  const confirm = () => {
    emit('confirm')
  }

  const getTimerInput = () => {
    return cooldownStatus.value.refreshTimestamp - getCurrentTimestamp()
  }

  const transformTimerSlots = (props) => {
    const formattedProps = {}

    Object.entries(props).forEach(([key, value]) => {
      formattedProps[key] = value < 10 ? `0${value}` : String(value)
    })

    return formattedProps
  }

  defineExpose({
    open,
    close,
  })
</script>

<template>
  <BaseModal ref="modal" :backdrop-close="false">
    <div class="modal-title">
      <h3>Training</h3>
      <p>
        Prepare your mighty cat for the next mission with a special training
      </p>
    </div>
    <img class="img-random" :src="imgRandom" />
    <div v-if="cooldownStatus" class="modal-body">
      <BatteryIndicator
        :activities-remaining="cooldownStatus.activitiesRemaining"
      />
      <div class="points-remaining">
        Energy level:
        {{ cooldownStatus.activitiesRemaining }}/{{
          cooldownStatus.activitiesPerCooldown
        }}
      </div>

      <div class="cooldown-status">
        <template
          v-if="
            cooldownStatus.activitiesRemaining ===
            cooldownStatus.activitiesPerCooldown
          "
        >
          Your mighty cat has full energy
        </template>
        <VueCountdown
          v-else
          v-slot="{ hours, minutes, seconds }"
          :time="getTimerInput()"
          :transform="transformTimerSlots"
        >
          Next energy point in {{ hours }}:{{ minutes }}:{{ seconds }}
        </VueCountdown>
      </div>
    </div>
    <div class="modal-actions">
      <button class="btn btn-primary btn-blue" @click="cancel">
        <span>Cancel</span>
      </button>
      <button class="btn btn-primary btn-yellow" @click="confirm">
        <span>Train</span>
      </button>
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .modal-title,
  .modal-body {
    text-align: center;
  }

  .modal-title {
    p {
      margin-bottom: 0;
      font-weight: bold;
    }
  }

  .img-random {
    width: 150px;
  }

  .battery-indicator {
    position: absolute;
    top: -1.4rem;
    left: 50%;
    transform: translate(-50%, 0);
  }

  .modal-body {
    width: 100%;
    padding: 1.5rem 0;
    margin-top: 2rem;
    margin-bottom: 1rem;

    background: #2e39ac;
    border: solid 3px var(--color-white);
    border-radius: 1rem;

    .points-remaining {
      margin-bottom: 1rem;
      font-size: 1.2rem;
      font-weight: bold;
    }
  }

  .modal-actions {
    display: flex;
    width: 100%;

    .btn {
      display: block;
      width: 100%;
      margin: 0 0.5rem;
    }
  }
</style>
