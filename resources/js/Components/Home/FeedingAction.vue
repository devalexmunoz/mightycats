<script setup>
  import { ref, computed, onBeforeMount, watchEffect } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import XpAwardedModal from '@/Components/XpAwardedModal.vue'
  import ErrorModal from '@/Components/ErrorModal.vue'

  defineProps({
    actionContainer: {
      type: String,
      required: false,
      default: null,
    },
  })

  // Template $ref
  const resultsModal = ref(null)
  const errorModal = ref(null)

  const feedingModule = useFeedingModule()
  const feedingActionStatus = computed(() => {
    return feedingModule.getStatus()
  })

  const userNftModule = useUserNftModule()

  const xpGained = ref(0)

  watchEffect(() => {
    if (feedingModule.getStatus() === 'results') {
      showResultsModal()
    }

    if (feedingModule.getStatus() === 'error') {
      showErrorModal()
    }
  })

  const showResultsModal = () => {
    const stats = feedingModule.getPostFeedingStats()
    xpGained.value = parseInt(stats.xp_gained)
    resultsModal.value.open()
  }

  const showErrorModal = () => {
    errorModal.value.open()
  }

  const onResultsModalClose = () => {
    feedingModule.resetStatus()
    userNftModule.refreshUserNftData()
  }

  const onErrorModalClose = () => {
    feedingModule.resetStatus()
  }

  onBeforeMount(() => {
    feedingModule.resetStatus()
  })
</script>

<template>
  <!--  Action  -->
  <Teleport
    v-if="feedingActionStatus !== 'idle'"
    :disabled="!actionContainer"
    :to="actionContainer"
  >
    <div id="action-display">
      <h3>Feeding</h3>
      <p v-if="feedingActionStatus === 'feeding'">Nom nom nom...</p>
      <p
        v-if="
          feedingActionStatus === 'done' || feedingActionStatus === 'results'
        "
      >
        Your mighty cat is now full!
      </p>
    </div>
  </Teleport>

  <!--  Results Modal  -->
  <XpAwardedModal
    ref="resultsModal"
    :xp-gained="xpGained"
    @close="onResultsModalClose"
  >
    <template #heading> Feeding complete! </template>
    <template #subheading> Your mighty cat is growing stronger </template>
  </XpAwardedModal>

  <!--  Error Modal  -->
  <ErrorModal ref="errorModal" @close="onErrorModalClose" />
</template>

<style lang="scss" scoped>
  #action-display {
    text-align: center;
    h3 {
      font-size: 2.5rem;
    }
    p {
      font-size: 1.25rem;
      font-weight: bold;
    }
  }
</style>
