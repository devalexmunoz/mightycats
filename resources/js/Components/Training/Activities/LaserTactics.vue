<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import BaseTrainingActivity from '@/Components/Training/BaseTrainingActivity.vue'
  import MightyCat from '@/Components/MightyCat.vue'

  import mightyCat0 from '@img/mighty-cat/training-activities/laser-tactics/0.png'
  import mightyCat1 from '@img/mighty-cat/training-activities/laser-tactics/1.png'
  import mightyCat2 from '@img/mighty-cat/training-activities/laser-tactics/2.png'

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
      <p>Watch out for that laser!</p>
      <img class="img-mighty-cat" :src="imgMap[nftData.version]" />
    </template>
    <template #done>
      <p>Finished Laser Tactics!</p>
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
    bottom: 0;
    z-index: 1;
  }

  .mighty-cat-activity-done {
    width: 280px;
    position: absolute;
    bottom: 6rem;
    z-index: 1;
  }
</style>
