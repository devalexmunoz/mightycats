<script setup>
  import { ref, toRefs, onBeforeMount, watch } from 'vue'
  import {
    getAnimationOptions,
    calculateAnimationDuration,
  } from '@/Utils/XpAnimation'

  import iconMightyPoints from '@img/mighty-points-icon.svg?raw'

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
  <h3>
    <!-- eslint-disable-next-line vue/no-v-html -->
    <span class="icon-mighty-points" v-html="iconMightyPoints"></span>
    <span class="xp-count" v-text="formattedXpCount"></span>
  </h3>
  <span class="xp-label">Mighty Points</span>
</template>

<style lang="scss" scoped>
  h3 {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    margin-bottom: 0;
  }

  .icon-mighty-points {
    display: inline-block;
    height: 2rem;
  }

  .xp-count {
    margin-left: 0.25rem;
    color: #2e39ac;
  }

  .xp-label {
    font-weight: bold;
  }
</style>
