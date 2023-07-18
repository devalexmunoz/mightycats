<script setup>
  import { computed, defineProps } from 'vue'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  const props = defineProps({
    title: {
      type: String,
      required: true,
    },
  })

  const trainingModule = useTrainingModule()
  const status = computed(() => {
    return trainingModule.getStatus()
  })
</script>

<template>
  <h3>{{ props.title }}</h3>
  <template v-if="status === 'training'">
    <slot name="training"></slot>
  </template>
  <template v-if="status === 'done' || status === 'results'">
    <slot name="done"></slot>
  </template>
</template>

<style lang="scss" scoped>
  h3 {
    font-size: 2.5rem;
    margin-top: -19rem;
  }
</style>
