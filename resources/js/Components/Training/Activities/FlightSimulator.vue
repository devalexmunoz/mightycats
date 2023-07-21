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
  <BaseTrainingActivity v-if="nftData" :title="`Flight Simulator`">
    <template #training>
      <p>Ready for takeoff!</p>
      <img class="img-mighty-cat-activity" :src="imgMap[nftData.version]" />
    </template>
    <template #done>
      <p>Finished Flight Simulator!</p>
      <div class="mighty-cat-container activity-done">
        <MightyCat />
      </div>
    </template>
  </BaseTrainingActivity>
</template>

<style lang="scss" scoped>
  p {
    font-size: 1.25rem;
    font-weight: bold;
    text-align: center;
  }

  .img-mighty-cat-activity {
    position: absolute;
    bottom: 2rem;
    z-index: 1;
    width: 350px;
  }

  .mighty-cat-container.activity-done {
    position: absolute;
    bottom: 6rem;
    z-index: 1;
    width: 220px;
  }
</style>
