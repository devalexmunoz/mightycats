<script setup>
  import { ref } from 'vue'
  import BaseModal from '@/Components/BaseModal.vue'

  import imgContent1 from '@img/home/welcome-modal/img-content-1.png'
  import imgContent2 from '@img/home/welcome-modal/img-content-2.png'
  import imgContent3 from '@img/home/welcome-modal/img-content-3.png'

  // TODO: Find a way to automatically proxy BaseModal methods
  const modal = ref(null)

  const contentIndex = ref(0)
  const contentCount = 3

  const open = () => {
    modal.value.open()
  }
  const close = () => {
    modal.value.close()
  }

  const onButtonClick = () => {
    if (contentIndex.value < contentCount - 1) {
      contentIndex.value++
    } else {
      close()
    }
  }

  defineExpose({
    open,
  })
</script>

<template>
  <BaseModal ref="modal" :backdrop-close="false">
    <div class="modal-title">
      <h3>Welcome</h3>
    </div>

    <div v-show="contentIndex === 0" class="content">
      <img :src="imgContent1" />
      <div class="modal-body">
        This will be the new home for your Mighty Cat! Don’t forget to
        <strong>come and feed it</strong> a few times a day.
      </div>
    </div>
    <div v-show="contentIndex === 1" class="content">
      <img :src="imgContent2" />
      <div class="modal-body">
        You can also keep your Mighty Cat in shape by
        <strong>completing training drills</strong>... whenever it has enough
        energy
      </div>
    </div>
    <div v-show="contentIndex === 2" class="content">
      <img :src="imgContent3" />
      <div class="modal-body">
        Feeding and training will
        <strong>make your Mighty Cat stronger</strong>. Can you two reach the
        maximum level?
      </div>
    </div>

    <div class="modal-actions">
      <button class="btn btn-primary btn-yellow" @click="onButtonClick">
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

  .content {
    img {
      display: block;
      max-width: 100%;
      margin-top: -1rem;
      margin-bottom: -1rem;
    }
  }

  .modal-body {
    width: 100%;
    padding: 1.5rem 0;
    margin-bottom: 1rem;

    background: #2e39ac;
    border: solid 3px var(--color-white);
    border-radius: 1rem;

    .poins-remaining {
      margin-bottom: 1rem;
      font-size: 1.2rem;
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
