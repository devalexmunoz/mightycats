<script setup>
  import { ref } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import LoginModal from '@/Components/Onboarding/LoginModal.vue'

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
        <a href="#" @click.prevent="openLoginModal">Login</a>
      </div>
    </nav>

    <h1>Mighty Cats</h1>

    <button class="btn" @click="openLoginModal">Join the rescue!</button>

    <LoginModal ref="loginModal" />
  </div>
</template>
