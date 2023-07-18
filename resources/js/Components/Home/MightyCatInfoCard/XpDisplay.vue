<script setup>
  import { ref, toRefs, onBeforeMount, watch } from 'vue'
  import {
    getAnimationOptions,
    calculateAnimationDuration,
  } from '@/Utils/XpAnimation'

  const props = defineProps({
    xp: {
      type: Number,
      required: true,
    },
  })

  const { xp } = toRefs(props)
  const formattedXpCount = ref(null)

  watch(xp, (newXp, oldXp) => {
    animateXpGain(oldXp, newXp)
  })

  const formatXpCount = (xpCount) => {
    if (xpCount < 1000 ** 1) {
      return xpCount
    }
    if (xpCount < 1000 ** 2) {
      return formatNumberValue(xpCount / 1000 ** 1) + 'k'
    }
    if (xpCount < 1000 ** 3) {
      return formatNumberValue(xpCount / 1000 ** 2) + 'M'
    }

    return formatNumberValue(xpCount / 1000 ** 3) + 'G'
  }

  const formatNumberValue = (number) => {
    return number
      .toLocaleString('us', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
      .replace(/0$/, '')
  }

  const animateXpGain = (fromXp, toXp) => {
    const xpGain = toXp - fromXp
    const duration = calculateAnimationDuration(fromXp, toXp)
    const increments = Math.ceil(
      xpGain / (duration / getAnimationOptions().gain_animation_speed)
    )

    let animationIntervalRef = setInterval(() => {
      fromXp += increments
      if (fromXp > toXp) {
        fromXp = toXp
        clearInterval(animationIntervalRef)
      }

      formattedXpCount.value = formatXpCount(fromXp)
    }, getAnimationOptions().gain_animation_speed)
  }

  onBeforeMount(() => {
    formattedXpCount.value = formatXpCount(xp.value)
  })
</script>

<template>
  <h3 class="xp-count" v-text="formattedXpCount"></h3>
  <span class="xp-label">Mighty Points</span>
</template>

<style lang="scss" scoped>
  .xp-count {
    display: block;
    color: #2e39ac;
    margin-bottom: 0;
  }
  .xp-label {
    font-weight: bold;
  }
</style>
