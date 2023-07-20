<script setup>
  import bgSprite from '@img/training/sprite-battery-indicator.png'

  const props = defineProps({
    activitiesRemaining: {
      type: Number,
      required: true,
    },
  })
</script>

<template>
  <span
    class="battery-indicator"
    :data-remaining="props.activitiesRemaining"
    :style="`--background-sprite: url(${bgSprite})`"
  ></span>
</template>

<style lang="scss" scoped>
  .battery-indicator {
    display: inline-block;

    width: 90px;
    height: 40px;

    background: var(--background-sprite);
    background-size: 390px;

    &::before {
      content: none;
    }

    &[data-remaining='2'] {
      background-position: -100px 0;
    }

    &[data-remaining='1'] {
      background-position: -200px 0;
    }

    &[data-remaining='0'] {
      background-position: -300px 0;
    }
  }
</style>
