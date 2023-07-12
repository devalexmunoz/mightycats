<script setup>
  import { ref } from 'vue'
  import GoogleSigninButton from './GoogleSigninButton.vue'

  const isOpen = ref(false)
  const open = () => {
    isOpen.value = true
  }
  const close = () => {
    isOpen.value = false
  }

  defineExpose({
    open,
    close,
  })
</script>

<template>
  <div v-show="isOpen" class="modal">
    <button class="btn btn-close" @click="close"></button>
    <div class="modal-title">
      <h3>Login</h3>
    </div>
    <div class="modal-content">
      <GoogleSigninButton />
    </div>
  </div>
  <div v-if="isOpen" class="modal-backdrop" @click="close"></div>
</template>

<style lang="scss" scoped>
  @keyframes fade-in {
    0% {
      opacity: 0;
    }

    100% {
      opacity: 1;
    }
  }

  .modal-backdrop {
    position: fixed;
    inset: 0;
    background: rgb(0 0 0 / 50%);
    animation: 0.2s ease-in 0s 1 fade-in;
  }

  .modal {
    position: fixed;
    z-index: 1;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    width: 360px;
    min-height: 160px;
    padding: 1rem;

    background: var(--background-color);

    animation: 0.1s ease-in 0s 1 fade-in;

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
  }
</style>
