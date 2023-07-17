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
    height: 1rem;
    background: #eee;

    .progress-bar {
      max-width: 100%;
      height: 100%;
      background: red;
    }
  }
</style>
