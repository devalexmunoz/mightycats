<script setup>
  import { ref } from 'vue'
  import { getAuthUser } from '@/Utils/Auth'
  import { logout } from '@/Utils/Auth.js'
  import { buildFlowviewAccountUrl } from '@/Utils/Flow'
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
  })
</script>

<template>
  <BaseModal ref="modal">
    <button class="btn btn-close" @click="close"></button>
    <div class="modal-title">
      <h3>Settings</h3>
    </div>
    <div class="modal-body">
      <div>
        Your Mighty Cats Flow address:
        <strong>
          <a
            target="_blank"
            :href="
              buildFlowviewAccountUrl(getAuthUser().custodial_wallet_address)
            "
          >
            {{ getAuthUser().custodial_wallet_address }}
          </a>
        </strong>
      </div>
      <div>
        <button class="btn" disabled>
          Connect your Flow Wallet
          <small>(Coming soon)</small>
        </button>
      </div>
      <div>
        <button class="btn" @click="logout">Log out</button>
      </div>
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .modal-title,
  .modal-body {
    text-align: center;
  }

  .modal-body {
    padding-right: 1rem;
    padding-bottom: 1rem;
    padding-left: 1rem;
    margin: 1rem 0;

    div + div {
      margin-top: 0.5rem;
    }

    .btn {
      display: block;

      width: 100%;

      font-weight: bold;
      color: var(--color-blue);

      border-radius: 0.5rem;

      &[disabled] {
        opacity: 1;
      }

      small {
        display: block;
      }
    }
  }
</style>
