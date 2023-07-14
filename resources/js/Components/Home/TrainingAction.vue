<script setup>
  import { onBeforeMount, ref, watchEffect } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import ConfirmTrainingActionModal from '@/Components/Home/ConfirmTrainingActionModal.vue'

  // Template $ref
  const confirmActionModal = ref(null)

  const trainingModule = useTrainingModule()

  watchEffect(() => {
    if (trainingModule.getStatus() === 'awaiting-confirm') {
      showConfirmActionModal()
    }
  })

  const showConfirmActionModal = () => {
    confirmActionModal.value.open()
  }

  onBeforeMount(() => {
    trainingModule.resetStatus()
  })
</script>

<template>
  <ConfirmTrainingActionModal
    ref="confirmActionModal"
    @confirm="trainingModule.triggerActivitySelection"
    @cancel="trainingModule.resetStatus"
  />
</template>
