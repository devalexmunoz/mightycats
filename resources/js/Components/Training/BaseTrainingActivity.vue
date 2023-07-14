<script setup>
  import { computed } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  const trainingModule = useTrainingModule()
  const status = computed(() => {
    return trainingModule.getStatus()
  })
</script>

<template>
  <template v-if="status === 'training'">
    <slot name="training"></slot>
  </template>
  <template v-if="status === 'done' || status === 'results'">
    <slot name="done"></slot>
  </template>
</template>
