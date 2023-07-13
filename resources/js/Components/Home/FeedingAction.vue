<script setup>
  import { ref, computed, onBeforeMount, watchEffect } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import XpAwardedModal from '@/Components/XpAwardedModal.vue'

  // Template $ref
  const resultsModal = ref(null)

  const feedingModule = useFeedingModule()
  const feedingActionStatus = computed(() => {
    return feedingModule.getStatus()
  })

  watchEffect(() => {
    if (feedingModule.getStatus() === 'results') {
      showResultsModal()
    }
  })

  const showResultsModal = () => {
    resultsModal.value.open()
  }

  onBeforeMount(() => {
    feedingModule.resetStatus()
  })

  defineProps({
    container: {
      type: String,
      required: false,
      default: null,
    },
  })
</script>

<template>
  <template v-if="feedingActionStatus !== 'idle'">
    <Teleport :disabled="!container" :to="container">
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
  </template>
  <XpAwardedModal ref="resultsModal" @close="feedingModule.resetStatus" />
</template>

<style lang="scss" scoped>
  #action-display {
    text-align: center;
  }
</style>
