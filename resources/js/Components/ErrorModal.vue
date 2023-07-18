<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'

  // TODO: Find a way to automatically proxy BaseModal methods
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
  <BaseModal ref="modal" :backdrop-close="false">
    <div class="modal-title">
      <h3>Uh oh!</h3>
    </div>
    <div class="modal-body">
      There was an error connecting to the game server.
    </div>
    <div class="modal-actions">
      <button class="btn btn-primary btn-yellow" @click="close">
        <span>Ok</span>
      </button>
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .modal-title,
  .modal-body {
    text-align: center;
  }

  .modal-body {
    padding-bottom: 1rem;
    margin: 1rem 0;
  }

  .modal-actions {
    .btn {
      display: block;
      width: 10rem;
    }
  }
</style>
