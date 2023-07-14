<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'
  const emit = defineEmits(['confirm', 'cancel'])

  // TODO: Find a way to automatically proxy BaseModal methods
  const modal = ref(null)

  const open = () => {
    modal.value.open()
  }
  const close = () => {
    modal.value.close()
  }
  const cancel = () => {
    emit('cancel')
    close()
  }
  const confirm = () => {
    emit('confirm')
  }

  defineExpose({
    open,
    close,
  })
</script>

<template>
  <BaseModal ref="modal" :backdrop-close="false">
    <div class="modal-title">
      <h3>Training</h3>
      <p>
        Prepare your mighty cat for the next mission with a special training
        session
      </p>
    </div>
    <div class="modal-body">Training points: 3/3</div>
    <div class="modal-actions">
      <button class="btn" @click="cancel">Cancel</button>
      <button class="btn" @click="confirm">Train</button>
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

  .modal-actions {
    display: flex;
    width: 100%;

    .btn {
      display: block;
      width: 100%;
      margin: 0 0.5rem;
    }
  }
</style>
