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
    position: absolute;
    bottom: 0;
    margin-bottom: 1.5rem;
    @media (min-width: 768px) {
      margin-bottom: 4rem;
    }

    :deep(.btn-primary) {
      width: 10rem;
      margin: 0 0.5rem;

      &[disabled] {
        opacity: 1;
      }
    }
  }
</style>
