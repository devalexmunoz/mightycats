<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'
  import GoogleSigninButton from '@/Components/Landing/GoogleSigninButton.vue'

  const modal = ref(null)
  const open = () => {
    modal.value.open()
  }
  const close = () => {
    modal.value.close()
  }

  defineExpose({
    open,
    close,
  })
</script>

<template>
  <BaseModal ref="modal" :persist-on-dom="true">
    <button class="btn btn-close" @click="close"></button>
    <div class="modal-title">
      <h3>Login</h3>
    </div>
    <div class="modal-content">
      <GoogleSigninButton />
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .modal-title {
    margin-bottom: 1rem;
  }
</style>
