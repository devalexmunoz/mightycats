<script setup>
  import { ref, toRefs, watch } from 'vue'
  import {
    getAnimationOptions,
    calculateAnimationDuration,
  } from '@/Utils/XpAnimation'
  import LevelProgressBar from '@/Components/Home/MightyCatInfoCard/LevelProgressBar.vue'

  const props = defineProps({
    level: {
      type: Number,
      required: true,
    },
    progress: {
      type: Number,
      required: true,
    },
    xp: {
      type: Number,
      required: true,
    },
  })

  const { level, progress, xp } = toRefs(props)
  const proxyLevel = ref(level.value)
  const proxyProgress = ref(progress.value)

  watch(xp, (newXP, oldXp) => {
    // Proxy refs hold the last value for level and progress before the xp was updated,
    // while the props already hold the new values
    animateLevelProgress(
      proxyLevel.value,
      level.value,
      proxyProgress.value,
      progress.value,
      oldXp,
      newXP
    )
  })

  const animateLevelProgress = (
    fromLevel,
    toLevel,
    fromProgress,
    toProgress,
    fromXp,
    toXp
  ) => {
    const progressGain = Math.floor(
      (toLevel + toProgress / 100 - (fromLevel + fromProgress / 100)) * 100
    )
    const duration = calculateAnimationDuration(fromXp, toXp)
    const increments =
      progressGain / (duration / getAnimationOptions().gain_animation_speed)

    let animationIntervalRef = setInterval(() => {
      if (fromProgress + increments > 100) {
        fromLevel++
      }

      fromProgress = (fromProgress + increments) % 100

      if (fromLevel === toLevel && fromProgress >= toProgress) {
        fromProgress = toProgress
        clearInterval(animationIntervalRef)
      }

      proxyLevel.value = fromLevel
      proxyProgress.value = fromProgress
    }, getAnimationOptions().gain_animation_speed)
  }
</script>

<template>
  <div class="level-indicator">Lv. {{ proxyLevel }}</div>
  <LevelProgressBar :progress="proxyProgress" />
</template>

<style lang="scss" scoped>
  .level-indicator {
    padding-right: 1rem;
    white-space: nowrap;
  }
</style>
