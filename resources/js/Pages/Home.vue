<script setup>
  import { Head } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'
  import MightyCat from '@/Components/MightyCat.vue'
</script>

<template>
  <Head title="Home" />
  <div class="container">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" @click.prevent="logout">Log out</a>
      </div>
    </nav>

    <h1>Home</h1>
    <MightyCat />
  </div>
</template>
