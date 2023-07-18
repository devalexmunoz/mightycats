<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'

  import iconMightyPoints from '@img/mighty-points-icon.svg?raw'

  defineProps({
    xpGained: {
      type: Number,
      required: true,
    },
  })

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
      <h3><slot name="heading"></slot></h3>
      <p><slot name="subheading"></slot></p>
    </div>
    <div class="modal-body">
      Your mighty cat gained
      <div class="points-awarded">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <span class="icon-mighty-points" v-html="iconMightyPoints"></span>
        <span class="xp-gained">{{ xpGained }}</span>
      </div>
      <span class="label-migthy-points">Mighty Points</span>
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

  .modal-title {
    p {
      margin-bottom: 0;
      font-weight: bold;
    }
  }

  .modal-body {
    width: 100%;
    padding: 1.5rem 0;
    margin: 1rem 0;
    background: #2e39ac;
    border: solid 3px var(--color-white);
    border-radius: 1rem;

    .points-awarded {
      display: flex;
      align-items: center;
      justify-content: center;

      .icon-mighty-points {
        display: inline-block;
        height: 2.5rem;
      }

      .xp-gained {
        font-family: 'Lilita One', display;
        font-size: 4rem;

        margin-left: 0.5rem;
      }
    }

    .label-migthy-points {
      color: #5cdbf8;
      font-weight: bold;
    }
  }

  .modal-actions {
    .btn {
      display: block;
      width: 10rem;
    }
  }
</style>
