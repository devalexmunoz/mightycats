<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import BaseTrainingActivity from '@/Components/Training/BaseTrainingActivity.vue'
  import MightyCat from '@/Components/MightyCat.vue'

  import mightyCat0 from '@img/mighty-cat/training-activities/flight-simulator/0.png'
  import mightyCat1 from '@img/mighty-cat/training-activities/flight-simulator/1.png'
  import mightyCat2 from '@img/mighty-cat/training-activities/flight-simulator/2.png'

  const imgMap = {
    0: mightyCat0,
    1: mightyCat1,
    2: mightyCat2,
  }

  const userNftModule = useUserNftModule()

  const nftData = computedAsync(async () => {
    return await userNftModule.getUserNftData()
  }, null)
</script>

<template>
  <BaseTrainingActivity>
    <template #training>
      <p>Ready for takeoff!</p>
      <img class="img-mighty-cat" :src="imgMap[nftData.version]" />
    </template>
    <template #done>
      <p>Finished Flight Simulator!</p>
      <MightyCat class="mighty-cat-activity-done" />
    </template>
  </BaseTrainingActivity>
</template>

<style lang="scss" scoped>
  p {
    font-size: 1.2rem;
    font-weight: bold;
  }

  .img-mighty-cat {
    width: 400px;

    position: absolute;
    bottom: 2rem;
    z-index: 1;
  }

  .mighty-cat-activity-done {
    width: 280px;
    position: absolute;
    bottom: 6rem;
    z-index: 1;
  }
</style>
