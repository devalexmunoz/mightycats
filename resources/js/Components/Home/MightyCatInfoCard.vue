<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import { formatSerial } from '@/Utils/NftData'
  import XpDisplay from '@/Components/Home/MightyCatInfoCard/XpDisplay.vue'
  import LevelDisplay from '@/Components/Home/MightyCatInfoCard/LevelDisplay.vue'

  import iconFemale from '@img/icons/icon-female.svg?raw'
  import iconMale from '@img/icons/icon-male.svg?raw'

  const userNftModule = useUserNftModule()

  const nftData = computedAsync(async () => {
    return await userNftModule.getUserNftData()
  }, null)
</script>

<template>
  <div v-if="nftData" id="mighty-info-card" class="box">
    <span class="serial">Mighty Cat {{ formatSerial(nftData.itemID) }}</span>
    <div class="info-row">
      <div class="basic-info">
        <h3 class="nickname">
          {{ nftData.nickname }}
          <!-- eslint-disable vue/no-v-html -->
          <span
            v-if="nftData.gender === 'F'"
            class="icon-female"
            v-html="iconFemale"
          ></span>
          <span
            v-if="nftData.gender === 'M'"
            class="icon-male"
            v-html="iconMale"
          ></span>
          <!-- eslint-enable vue/no-v-html -->
        </h3>
      </div>
      <div class="xp-info">
        <XpDisplay :xp="nftData.xp" />
      </div>
    </div>
    <div class="level-row">
      <LevelDisplay
        :level="nftData.level"
        :progress="nftData.levelProgress"
        :xp="nftData.xp"
      />
    </div>
  </div>
</template>

<style lang="scss" scoped>
  #mighty-info-card {
    position: absolute;
    top: 1.5rem;

    width: 90vw;
    max-width: 500px;
    padding: 1rem;

    color: #2d86fe;

    background: var(--color-white);
    border-radius: 1rem 0.25rem;
    box-shadow: 0 5px #d7ffff;

    @media (width >= 768px) {
      top: 3rem;
    }

    .serial {
      position: absolute;
      top: 0;

      display: inline-block;

      padding: 0.5rem 1rem;
      margin-top: -1rem;

      font-weight: bold;
      color: var(--color-white);

      background: #5cdbf8;
      border-radius: 1rem 0;
    }

    .info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-bottom: 0.5rem;

      .nickname {
        padding-right: 0.5rem;
        margin-bottom: 0;
        color: #2e39ac;
      }

      .icon-female {
        color: #a073ff;
      }

      .icon-male {
        color: #5cdbf8;
      }
    }

    .level-row {
      display: flex;
      align-items: center;
    }

    .xp-info {
      text-align: right;
    }
  }
</style>
