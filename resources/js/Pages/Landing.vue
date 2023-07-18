<script setup>
  import { ref } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import Logo from '@/Components/Logo.vue'
  import LoginModal from '@/Components/Onboarding/LoginModal.vue'

  import imgLanding from '@img/landing/img-landing.png'

  const loginModal = ref(null)

  const openLoginModal = () => {
    loginModal.value.open()
  }
</script>

<template>
  <Head title="Welcome" />
  <div class="container">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" class="btn" @click.prevent="openLoginModal">Login</a>
      </div>
    </nav>

    <div class="call-to-action">
      <Logo />
      <h3>Gather up and save the kittens!</h3>
      <button class="btn btn-primary btn-blue" @click="openLoginModal">
        <span>Join the rescue!</span>
      </button>
    </div>

    <img class="img-landing" :src="imgLanding" />

    <LoginModal ref="loginModal" />
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: linear-gradient(173deg, #3645da 0%, #6d2eac 100%);
    overflow: hidden;
  }

  .navbar {
    z-index: 1;
  }

  .call-to-action {
    padding: 1rem;
    position: absolute;
    inset: 0;
    top: 64%;
    @media (min-width: 768px) {
      top: 0;
      right: 55%;
    }

    text-align: center;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    z-index: 1;

    &::before,
    &::after {
      content: '';
      display: block;
      position: absolute;
    }

    &::before {
      inset: 0;
      transform: rotate(4deg) scale(1.2);
      @media (min-width: 768px) {
        transform: rotate(5deg) scale(1.15);
      }
      background: #181b56;
    }

    &::after {
      border-top: 10px solid transparent;
      border-bottom: 10px solid transparent;
      border-right: 10px solid #181b56;
      right: 10%;
      bottom: 64%;
      transform: rotate(276deg) scale(20);
      @media (min-width: 768px) {
        right: 3rem;
        bottom: 25%;
        transform: rotate(7deg) scale(20);
      }
    }

    & > * {
      z-index: 1;
    }
  }

  .logo {
    max-width: 230px;
    @media (min-width: 768px) {
      max-width: none;
    }
  }

  h3 {
    font-size: 1.5rem;
    margin-top: 1rem;
    @media (min-width: 768px) {
      font-size: 2rem;
      margin-top: 4rem;
    }
  }

  .img-landing {
    position: absolute;
    z-index: 0;
    width: 479px;
    left: 50%;
    bottom: 0%;
    transform: translate(-53%, 0);
    @media (min-width: 768px) {
      margin-right: 0;
      top: 15%;
      left: auto;
      right: 5%;
      transform: scale(1.3);
    }
  }
</style>
