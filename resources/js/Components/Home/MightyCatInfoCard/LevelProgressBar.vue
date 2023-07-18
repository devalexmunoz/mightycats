<script setup>
  defineProps({
    progress: {
      type: Number,
      required: true,
    },
  })
</script>

<template>
  <div class="level-progress">
    <div class="progress-bar" :style="`width: ${progress}%`"></div>
  </div>
</template>

<style lang="scss" scoped>
  .level-progress {
    width: 100%;
    height: 1.5rem;
    background: #d7ffff;
    border-radius: 1rem;
    padding: 0.25rem;

    .progress-bar {
      max-width: 100%;
      height: 100%;
      background: linear-gradient(90deg, #2d86fe 0%, #2df1fe 51.53%);
      border-radius: 1rem;
    }
  }
</style>
