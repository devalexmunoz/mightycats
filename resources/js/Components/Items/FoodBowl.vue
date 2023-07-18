<script setup>
  import { computed } from 'vue'
  import { useFeedingModule } from '@/Modules/FeedingModule'

  import imgEmpty from '@img/items/food-bowl-empty.png'
  import imgFull from '@img/items/food-bowl-full.png'

  const feedingModule = useFeedingModule()

  const status = computed(() => {
    return feedingModule.getStatus() === 'feeding' ? 'full' : 'empty'
  })
</script>

<template>
  <div class="food-bowl">
    <img v-show="status === 'empty'" :src="imgEmpty" />
    <img v-show="status === 'full'" :src="imgFull" />
  </div>
</template>

<style lang="scss" scoped>
  .food-bowl {
    width: 400px;
    line-height: 0;

    img {
      max-width: 100%;
    }
  }
</style>
