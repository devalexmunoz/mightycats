<script setup>
  import { ref, onBeforeMount, watchEffect } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import { useTrainingModule } from '@/Modules/TrainingModule'

  import imgRandom from '@img/training/img-random.png'

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
    <h1>Training</h1>
    <img class="img-random" :src="imgRandom" />
    <template v-if="selectedActivity">
      <p>Today's training session will be:</p>
      <h3 v-text="selectedActivityText"></h3>
    </template>
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: linear-gradient(173deg, #3645da 0%, #6d2eac 100%);
    overflow: hidden;
  }

  .img-random {
    width: 200px;
    margin-bottom: 1rem;
  }
</style>
