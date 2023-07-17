<script setup>
  import { computedAsync } from '@vueuse/core'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import XpDisplay from '@/Components/Home/MightyCatInfoCard/XpDisplay.vue'
  import LevelDisplay from '@/Components/Home/MightyCatInfoCard/LevelDisplay.vue'

  const userNftModule = useUserNftModule()

  const nftData = computedAsync(async () => {
    return await userNftModule.getUserNftData()
  }, null)
</script>

<template>
  <div v-if="nftData" id="mighty-info-card" class="box">
    <div class="info-row">
      <div class="basic-info">
        <span class="nickname">{{ nftData.nickname }}</span>
        <span class="gender">{{ nftData.gender }}</span>
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
    width: 90vw;
    max-width: 500px;
    padding: 1rem;
    margin-bottom: 5rem;

    border: solid 1px var(--box-border-color);

    .info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-bottom: 0.5rem;

      .nickname {
        padding-right: 0.5rem;
        font-weight: bold;
      }
    }

    .level-row {
      display: flex;
    }

    .xp-info {
      text-align: right;
    }
  }
</style>
