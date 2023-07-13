<script setup>
  import { ref } from 'vue'
  const emit = defineEmits(['open', 'close'])

  const isOpen = ref(false)
  const open = () => {
    isOpen.value = true
    emit('open')
  }
  const close = () => {
    isOpen.value = false
    emit('close')
  }

  defineProps({
    backdropClose: {
      type: Boolean,
      default: true,
    },
  })

  defineExpose({
    open,
    close,
  })
</script>

<template>
  <Teleport to="body">
    <div v-show="isOpen" class="modal">
      <slot></slot>
    </div>
    <div
      v-if="isOpen"
      class="modal-backdrop"
      @click="backdropClose && close"
    ></div>
  </Teleport>
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
    top: 50%;
    left: 50%;
    z-index: 1;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    width: 360px;
    min-height: 160px;
    padding: 1rem;

    background: var(--background-color);

    transform: translate(-50%, -50%);
    animation: 0.1s ease-in 0s 1 fade-in;
  }
</style>
