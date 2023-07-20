<script setup>
  import { ref } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import Logo from '@/Components/Logo.vue'
  import LoginModal from '@/Components/Landing/LoginModal.vue'

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
        <a href="#" class="btn btn-default" @click.prevent="openLoginModal"
          >Login</a
        >
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
    overflow: hidden;
    background: linear-gradient(173deg, #3645da 0%, #6d2eac 100%);
  }

  .navbar {
    z-index: 1;
  }

  .call-to-action {
    position: absolute;
    inset: 0;
    top: 64%;
    z-index: 1;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    padding: 1rem;

    text-align: center;

    @media (width >= 768px) {
      top: 0;
      right: 55%;
    }

    &::before,
    &::after {
      position: absolute;
      display: block;
      content: '';
    }

    &::before {
      inset: 0;
      background: #181b56;
      transform: rotate(4deg) scale(1.2);

      @media (width >= 768px) {
        transform: rotate(5deg) scale(1.15);
      }
    }

    &::after {
      right: 10%;
      bottom: 64%;

      border-top: 10px solid transparent;
      border-right: 10px solid #181b56;
      border-bottom: 10px solid transparent;

      transform: rotate(276deg) scale(20);

      @media (width >= 768px) {
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

    @media (width >= 768px) {
      max-width: none;
    }
  }

  h3 {
    margin-top: 1rem;
    font-size: 1.5rem;

    @media (width >= 768px) {
      margin-top: 4rem;
      font-size: 2rem;
    }
  }

  .img-landing {
    position: absolute;
    bottom: 0%;
    left: 50%;
    z-index: 0;

    width: 479px;

    transform: translate(-53%, 0);

    @media (width >= 768px) {
      top: 15%;
      right: 5%;
      left: auto;

      margin-right: 0;

      transform: scale(1.3);
    }
  }
</style>
