<script setup>
  import { computed } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  const feedingModule = useFeedingModule()
  const trainingModule = useTrainingModule()

  const showActionButtons = computed(() => {
    return feedingModule.getStatus() === 'idle'
  })

  const feed = () => {
    feedingModule.startAction()
  }

  const train = () => {
    trainingModule.confirmIntent()
  }
</script>

<template>
  <!-- Action Buttons are teleported here -->
  <div v-if="showActionButtons" id="action-buttons">
    <button class="btn" @click="feed">Feed</button>
    <button class="btn" @click="train">Training</button>
  </div>
</template>

<style lang="scss" scoped>
  #action-buttons {
    margin: 1rem;

    .btn {
      width: 10rem;
      margin: 0 0.5rem;
    }
  }
</style>
