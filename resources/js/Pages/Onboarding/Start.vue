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

    <div class="content">
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

  .content {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    width: 100%;
    max-width: 1200px;
  }

  .img-onboarding {
    width: 325px;
    @media (min-width: 768px) {
      width: 380px;
    }
  }

  .dialog-container {
    width: 100%;
    max-width: 25rem;

    @media (min-width: 768px) {
      max-width: 35rem;

      padding-left: 7rem;
      margin-top: -4rem;
    }

    .dialog-character {
      position: absolute;
      bottom: 100%;
      left: 0;
      width: 130px;
      margin-bottom: -1rem;
      z-index: 1;

      @media (min-width: 768px) {
        width: 170px;
        left: 0;
        top: -5rem;
        bottom: auto;
      }
    }
    .dialog-text {
      width: 100%;
      min-height: 7.3rem;

      background: rgb(0 0 0 / 50%);
      padding: 1rem;
      border-radius: 0.25rem;
      border: solid 3px #d7ffff;

      @media (min-width: 768px) {
        width: 26rem;
        padding-left: 3rem;
      }
    }
  }

  .onboarding-action {
    margin-top: 3rem;
    @media (min-width: 768px) {
      margin-top: 5rem;
    }

    .btn-primary {
      span {
        flex-direction: column;
      }
    }
  }
</style>
