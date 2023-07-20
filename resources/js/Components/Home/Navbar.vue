<script setup>
  import { ref } from 'vue'
  import SettingsModal from '@/Components/Home/SettingsModal.vue'

  const settingsModal = ref(null)

  const showSettingsModal = () => {
    settingsModal.value.open()
  }
</script>

<template>
  <nav class="navbar">
    <div></div>
    <div>
      <button class="btn" @click="showSettingsModal">Settings</button>
    </div>
  </nav>

  <SettingsModal ref="settingsModal" />
</template>
