<script setup>
  import { computed } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import FeedingActionButton from '@/Components/Home/FeedingActionButton.vue'

  const feedingModule = useFeedingModule()
  const trainingModule = useTrainingModule()

  const showActionButtons = computed(() => {
    return feedingModule.getStatus() === 'idle'
  })

  const train = () => {
    trainingModule.confirmIntent()
  }
</script>

<template>
  <div v-if="showActionButtons" id="action-buttons">
    <FeedingActionButton />
    <button class="btn" @click="train">Training</button>
  </div>
</template>

<style lang="scss" scoped>
  #action-buttons {
    margin: 1rem;

    :deep(.btn) {
      width: 10rem;
      margin: 0 0.5rem;
    }
  }
</style>
