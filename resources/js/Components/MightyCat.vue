<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'

  import mightyCat0 from '@img/mighty-cat/0.png'
  import mightyCat1 from '@img/mighty-cat/1.png'
  import mightyCat2 from '@img/mighty-cat/2.png'

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
  <div v-if="nftData" class="mighty-cat">
    <img :src="imgMap[nftData.version]" />
  </div>
</template>

<style lang="scss" scoped>
  img {
    width: 500px;
    max-width: 100%;
  }
</style>
