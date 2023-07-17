<script setup>
  import { computed } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import FeedingActionButton from '@/Components/Home/FeedingActionButton.vue'
  import TrainingActionButton from '@/Components/Home/TrainingActionButton.vue'

  const feedingModule = useFeedingModule()

  const showActionButtons = computed(() => {
    return feedingModule.getStatus() === 'idle'
  })
</script>

<template>
  <div v-if="showActionButtons" id="action-buttons">
    <FeedingActionButton />
    <TrainingActionButton />
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
