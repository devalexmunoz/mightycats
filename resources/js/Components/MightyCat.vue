<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'

  const userNftModule = useUserNftModule()

  const nftData = computedAsync(async () => {
    return await userNftModule.getUserNftData()
  }, null)
</script>

<template>
  <div v-if="nftData">
    <p>NFT Data: {{ nftData }}</p>
  </div>
</template>

<style lang="scss" scoped>
  p {
    max-width: 600px;
    text-align: center;
  }
</style>
