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
    @media (max-width: 767px) {
      top: 8.5rem;
      width: 90vw;
      max-width: 500px;
      padding-left: 0;
      padding-right: 0;
    }
  }

  .btn {
    width: 3rem;
    height: 3rem;
    border-radius: 1rem;
    padding: 0.5rem;
    @media (min-width: 768px) {
      width: 4rem;
      height: 4rem;
      border-radius: 1.5rem;
      padding: 0.75rem;
    }

    line-height: 0;

    .icon {
      width: 100%;
    }
  }
</style>
