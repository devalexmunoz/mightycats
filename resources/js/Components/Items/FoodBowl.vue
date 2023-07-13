<script setup>
  import { computed } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule.js'

  const feedingModule = useFeedingModule()

  const status = computed(() => {
    return feedingModule.getStatus() === 'feeding' ? 'full' : 'empty'
  })
</script>

<template>
  <div>
    Food Bowl
    <span>({{ status }})</span>
  </div>
</template>

<style lang="scss" scoped>
  div {
    text-align: center;
  }

  span {
    display: block;
  }
</style>
