<script setup>
  import { ref, onBeforeMount } from 'vue'
  import { getUserNftData } from '@/Utils/UserNftData'

  const nftData = ref(null)

  onBeforeMount(async () => {
    nftData.value = await getUserNftData()
  })
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
