<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'
  import GoogleSigninButton from '@/Components/Onboarding/GoogleSigninButton.vue'

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

  .btn-close {
    position: absolute;
    top: 0;
    right: 0;

    padding: 0.5rem;
    margin: 0.5rem;

    background: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23FFF'%3e%3cpath d='M.293.293a1 1 0 0 1 1.414 0L8 6.586 14.293.293a1 1 0 1 1 1.414 1.414L9.414 8l6.293 6.293a1 1 0 0 1-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 0 1-1.414-1.414L6.586 8 .293 1.707a1 1 0 0 1 0-1.414z'/%3e%3c/svg%3e");
    opacity: 0.5;

    &:hover,
    &:active,
    &:focus {
      opacity: 1;
    }
  }
</style>
