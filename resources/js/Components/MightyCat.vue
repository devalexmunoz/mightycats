<script setup>
  import { ref, watch } from 'vue'
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'

  import mightyCat0 from '@img/mighty-cat/0.png'
  import mightyCat1 from '@img/mighty-cat/1.png'
  import mightyCat2 from '@img/mighty-cat/2.png'

  import bgLevelUp from '@img/mighty-cat/bg-level-up.png'

  const imgMap = {
    0: mightyCat0,
    1: mightyCat1,
    2: mightyCat2,
  }

  const options = {
    levelUpStateDuration: 1500,
  }

  const userNftModule = useUserNftModule()

  const nftData = computedAsync(async () => {
    return await userNftModule.getUserNftData()
  }, null)

  const showLevelUpState = ref(false)
  const onLevelUp = () => {
    showLevelUpState.value = true
    setTimeout(() => {
      showLevelUpState.value = false
    }, options.levelUpStateDuration)
  }

  watch(nftData, (newData, oldData) => {
    if (newData && oldData) {
      if (newData.level > oldData.level) {
        onLevelUp()
      }
    }
  })
</script>

<template>
  <div v-if="nftData" class="mighty-cat">
    <div
      v-show="showLevelUpState"
      class="level-up-state"
      :style="`--bg-level-up: url(${bgLevelUp})`"
    >
      <h3 v-if="showLevelUpState" class="label-level-up">Level up!</h3>
    </div>
    <img :src="imgMap[nftData.version]" />
  </div>
</template>

<style lang="scss" scoped>
  img {
    width: 500px;
    max-width: 100%;
  }

  @keyframes slide-up {
    0% {
      transform: translate(-50%, 100%);
    }

    80% {
      transform: translate(-50%, -50%);
    }

    100% {
      transform: translate(-50%, 0);
    }
  }

  .level-up-state {
    position: absolute;
    inset: -2rem 0;

    display: block;

    background: var(--bg-level-up) center bottom no-repeat;
    background-size: 100%;

    .label-level-up {
      position: absolute;
      top: 0;
      left: 50%;

      margin-top: -1rem;

      transform: translate(-50%, 0);
      animation: 0.2s ease-in 0s 1 slide-up;
    }
  }
</style>
