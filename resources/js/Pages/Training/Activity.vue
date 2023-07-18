<script setup>
  import { ref, onMounted, watchEffect } from 'vue'
  import { Head, router } from '@inertiajs/vue3'
  import { useTrainingModule } from '@/Modules/TrainingModule'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import XpAwardedModal from '@/Components/XpAwardedModal.vue'
  import ErrorModal from '@/Components/ErrorModal.vue'

  import FlightSimulator from '@/Components/Training/Activities/FlightSimulator.vue'
  import LaserTactics from '@/Components/Training/Activities/LaserTactics.vue'
  import Meditation from '@/Components/Training/Activities/Meditation.vue'

  // TODO: Find a better way to map components (maybe use slugs?)
  const activitiesComponents = {
    'Flight Simulator': FlightSimulator,
    'Laser Tactics': LaserTactics,
    Meditation: Meditation,
  }

  // Template $ref
  const resultsModal = ref(null)
  const errorModal = ref(null)

  const trainingModule = useTrainingModule()
  const activity = trainingModule.getSelectedActivity()

  const userNftModule = useUserNftModule()

  const xpGained = ref(0)

  watchEffect(() => {
    if (trainingModule.getStatus() === 'results') {
      showResultsModal()
    }

    if (trainingModule.getStatus() === 'error') {
      showErrorModal()
    }
  })

  const showResultsModal = () => {
    const stats = trainingModule.getPostTrainingStats()
    xpGained.value = parseInt(stats.xp_gained)
    resultsModal.value.open()
  }

  const showErrorModal = () => {
    errorModal.value.open()
  }

  const onResultsModalClose = () => {
    router.get(
      route('home'),
      {},
      {
        onFinish: () => {
          userNftModule.refreshUserNftData()
        },
      }
    )
  }

  const onErrorModalClose = () => {
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
    <Head :title="`Training: ${activity.name}`" />
    <div class="container">
      <component :is="activitiesComponents[activity.name]"></component>
    </div>
  </template>

  <!--  Results Modal  -->
  <XpAwardedModal
    ref="resultsModal"
    :xp-gained="xpGained"
    @close="onResultsModalClose"
  >
    <template #heading> Training complete! </template>
    <template #subheading> Your mighty cat is growing stronger </template>
  </XpAwardedModal>

  <!--  Error Modal  -->
  <ErrorModal ref="errorModal" @close="onErrorModalClose" />
</template>

<style lang="scss" scoped>
  .container {
    background: linear-gradient(173deg, #3645da 0%, #6d2eac 100%);
    overflow: hidden;

    &::after {
      content: '';
      display: block;

      border-top: solid 3px #1d36a6;
      background: linear-gradient(180deg, #ff70a8 0%, #bf36ff 100%);

      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 30%;
    }
  }
</style>
