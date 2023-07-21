<script setup>
  import { ref } from 'vue'
  import SettingsModal from '@/Components/Home/SettingsModal.vue'

  import iconSettings from '@img/icons/icon-settings.png'

  const settingsModal = ref(null)

  const showSettingsModal = () => {
    settingsModal.value.open()
  }
</script>

<template>
  <nav class="navbar">
    <div></div>
    <div>
      <button class="btn btn-default" @click="showSettingsModal">
        <img class="icon" :src="iconSettings" />
      </button>
    </div>
  </nav>

  <SettingsModal ref="settingsModal" />
</template>

<style lang="scss" scoped>
  .navbar {
    @media (width <= 767px) {
      top: 8.5rem;

      width: 90vw;
      max-width: 500px;
      padding-right: 0;
      padding-left: 0;
    }
  }

  .btn {
    width: 3rem;
    height: 3rem;
    padding: 0.5rem;

    line-height: 0;

    border-radius: 1rem;

    @media (width >= 768px) {
      width: 4rem;
      height: 4rem;
      padding: 0.75rem;
      border-radius: 1.5rem;
    }

    .icon {
      width: 100%;
    }
  }
</style>
