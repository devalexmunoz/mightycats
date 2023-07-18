<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import BaseTrainingActivity from '@/Components/Training/BaseTrainingActivity.vue'
  import MightyCat from '@/Components/MightyCat.vue'

  import mightyCat0 from '@img/mighty-cat/training-activities/meditation/0.png'
  import mightyCat1 from '@img/mighty-cat/training-activities/meditation/1.png'
  import mightyCat2 from '@img/mighty-cat/training-activities/meditation/2.png'

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
  <BaseTrainingActivity v-if="nftData" :title="`Meditation`">
    <template #training>
      <p>Entering zen mode!</p>
      <img class="img-mighty-cat-activity" :src="imgMap[nftData.version]" />
    </template>
    <template #done>
      <p>Finished Meditating!</p>
      <div class="mighty-cat-container activity-done">
        <MightyCat />
      </div>
    </template>
  </BaseTrainingActivity>
</template>

<style lang="scss" scoped>
  p {
    text-align: center;
    font-size: 1.25rem;
    font-weight: bold;
  }

  .img-mighty-cat-activity {
    width: 350px;

    position: absolute;
    bottom: 4rem;
    z-index: 1;
  }

  .mighty-cat-container.activity-done {
    width: 220px;
    position: absolute;
    bottom: 6rem;
    z-index: 1;
  }
</style>
