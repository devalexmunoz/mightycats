<script setup>
  import { ref, onBeforeMount, watchEffect } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  const options = {
    animationInterval: 130,
    animationDuration: 130 * 15,
    waitAfterAnimation: 3000,
  }

  const trainingModule = useTrainingModule()
  const availableActivities = ref([])
  const selectedActivity = ref(null)
  const selectedActivityText = ref('')

  watchEffect(() => {
    if (selectedActivity.value) {
      startRandomSelectionAnimation()
      setTimeout(stopRandomSelectionAnimation, options.animationDuration)
      setTimeout(
        trainingModule.goToSelectedActivity,
        options.waitAfterAnimation
      )
    }
  })

  let animationIntervalRef = null
  let animationActivityIndex = 0
  const randomSelectionAnimation = () => {
    selectedActivityText.value =
      availableActivities.value[animationActivityIndex].name
    animationActivityIndex++
    if (animationActivityIndex >= availableActivities.value.length) {
      animationActivityIndex = 0
    }
  }

  const startRandomSelectionAnimation = () => {
    animationIntervalRef = setInterval(
      randomSelectionAnimation,
      options.animationInterval
    )
  }
  const stopRandomSelectionAnimation = () => {
    clearInterval(animationIntervalRef)
    selectedActivityText.value = selectedActivity.value.name
  }

  onBeforeMount(async () => {
    availableActivities.value = await trainingModule.getAvailableActivities()
    selectedActivity.value = await trainingModule.selectRandomActivity(
      availableActivities.value
    )
  })
</script>

<template>
  <Head title="Training selector" />
  <div class="container">
    <h1>Training Selector</h1>
    <template v-if="selectedActivity">
      <p>Today's training session will be:</p>
      <h3 v-text="selectedActivityText"></h3>
    </template>
  </div>
</template>
