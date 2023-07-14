<script setup>
  import { ref, onMounted, watchEffect } from 'vue'
  import { Head, router } from '@inertiajs/vue3'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import XpAwardedModal from '@/Components/XpAwardedModal.vue'

  import FlightSimulator from '@/Components/Training/Activities/FlightSimulator.vue'
  import LaserTactics from '@/Components/Training/Activities/LaserTactics.vue'
  import Meditation from '@/Components/Training/Activities/Meditation.vue'

  const activitiesComponents = {
    'flight-simulator': FlightSimulator,
    'laser-tactics': LaserTactics,
    meditation: Meditation,
  }

  // Template $ref
  const resultsModal = ref(null)

  const trainingModule = useTrainingModule()
  const activity = trainingModule.getSelectedActivity()

  watchEffect(() => {
    if (trainingModule.getStatus() === 'results') {
      showResultsModal()
    }
  })

  const showResultsModal = () => {
    resultsModal.value.open()
  }

  const onResultsModalClose = () => {
    router.get(route('home'))
  }

  onMounted(() => {
    if (!activity) {
      trainingModule.triggerActivitySelection()
      return
    }

    trainingModule.startActivity()
  })
</script>

<template>
  <template v-if="activity">
    <Head :title="`Training: ${activity}`" />
    <div class="container">
      <h1>{{ activity }}</h1>
      <component :is="activitiesComponents[activity]"></component>
    </div>
  </template>
  <XpAwardedModal ref="resultsModal" @close="onResultsModalClose" />
</template>
