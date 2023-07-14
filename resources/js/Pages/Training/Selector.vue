<script setup>
  import { ref, onMounted } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  const options = {
    animationInterval: 130,
    animationDuration: 130 * 15,
    waitAfterAnimation: 3000,
  }

  const trainingModule = useTrainingModule()
  const availableActivities = trainingModule.getAvailableActivities()
  const selectedActivity = trainingModule.selectRandomActivity()
  const selectedActivityText = ref(availableActivities[0])

  let animationIntervalRef = null
  let animationActivityIndex = 1
  const randomSelectionAnimation = () => {
    selectedActivityText.value = availableActivities[animationActivityIndex]
    animationActivityIndex++
    if (animationActivityIndex >= availableActivities.length) {
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
    selectedActivityText.value = selectedActivity
  }

  onMounted(() => {
    startRandomSelectionAnimation()
    setTimeout(stopRandomSelectionAnimation, options.animationDuration)
    setTimeout(trainingModule.goToSelectedActivity, options.waitAfterAnimation)
  })
</script>

<template>
  <Head title="Training selector" />
  <div class="container">
    <h1>Training Selector</h1>
    <p>Today's training session will be:</p>
    <h3 v-text="selectedActivityText"></h3>
  </div>
</template>
