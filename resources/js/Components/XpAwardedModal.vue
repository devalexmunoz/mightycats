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
      <h3>Feeding complete!</h3>
      <p>Your mighty cat grew stronger!</p>
    </div>
    <div class="modal-body">
      Your mighty cat gained
      <span class="points-awarded">255</span>
      Mighty Points
    </div>
    <div class="modal-action">
      <button class="btn" @click="close">Ok</button>
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .modal-title,
  .modal-body {
    text-align: center;
  }

  .modal-title {
    p {
      margin-bottom: 0;
    }
  }

  .modal-body {
    padding: 3rem 0;
    margin: 1rem 0;

    .points-awarded {
      display: block;
    }
  }

  .modal-action {
    .btn {
      display: block;
      width: 10rem;
    }
  }
</style>
