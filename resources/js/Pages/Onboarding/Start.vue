<script setup>
  import { ref } from 'vue'
  import { Head, router } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'
  import BaseModal from '@/Components/BaseModal.vue'

  import imgOnboarding from '@img/onboarding/img-onboarding-start.png'
  import imgCharacters from '@img/onboarding/characters.png'
  import imgBackground from '@img/onboarding/bg-onboarding.png'
  import AnimatedDialog from '@/Components/AnimatedDialog.vue'

  const infoModal = ref(null)

  const props = defineProps({
    purchaseUrl: {
      type: String,
      required: true,
    },
  })

  const onButtonClick = () => {
    infoModal.value.open()
  }

  const onInfoModalClose = () => {
    router.post(props.purchaseUrl)
  }
</script>

<template>
  <Head title="Onboarding" />
  <div class="container" :style="`--background-image: url(${imgBackground})`">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" class="btn" @click.prevent="logout">Log out</a>
      </div>
    </nav>

    <img class="img-onboarding" :src="imgOnboarding" />

    <div class="dialog-container">
      <img class="dialog-character" :src="imgCharacters" />
      <AnimatedDialog class="dialog-text">
        Thanks for coming mighty ranger! We have detected a new "cat"-astrophe
        and need to evacuate some kittens A.S.A.P.
      </AnimatedDialog>
    </div>

    <div class="onboarding-action">
      <button class="btn btn-primary btn-yellow" @click="onButtonClick">
        <span>Send rescue pod <small>($50)</small></span>
      </button>
    </div>
  </div>

  <BaseModal id="info-modal" ref="infoModal">
    <div class="modal-title">
      <h3>FYI</h3>
    </div>
    <div class="modal-body">
      <p>You're now being redirected to a demo Stripe checkout page.</p>
      <p>
        Use the Stripe test card <strong>"4242-4242-4242-4242"</strong> with any
        email, expiration date, cvv and location (postal code / zipcode) to
        purchase.
      </p>
    </div>
    <div class="modal-actions">
      <button class="btn btn-primary btn-yellow" @click="onInfoModalClose">
        <span>Ok</span>
      </button>
    </div>
  </BaseModal>
</template>

<style lang="scss" scoped>
  .container {
    background: var(--background-image),
      linear-gradient(145deg, #140b45 15%, #5a0085 120%);
    background-size: 364px, cover;
    overflow: hidden;
  }

  .img-onboarding {
    width: 380px;
    position: absolute;
    top: 1rem;
  }

  .dialog-container {
    width: 35rem;
    margin-top: 8rem;

    .dialog-character {
      width: 170px;
      z-index: 1;
    }
    .dialog-text {
      position: absolute;
      width: 26rem;
      height: 7rem;
      background: rgba(0, 0, 0, 0.5);
      padding: 1rem;
      padding-left: 3rem;
      left: 7rem;
      top: 6rem;

      border-radius: 0.25rem;
      border: solid 3px #d7ffff;
    }
  }

  .onboarding-action {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;

    z-index: 1;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 5rem 0;

    .btn-primary {
      span {
        flex-direction: column;
      }
    }
  }
</style>
