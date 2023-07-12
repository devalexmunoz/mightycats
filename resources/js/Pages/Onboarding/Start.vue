<script setup>
  import { Head, Link } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'

  defineProps({
    purchaseUrl: {
      type: String,
      required: true,
    },
  })
</script>

<template>
  <Head title="Onboarding" />
  <div class="container">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" @click.prevent="logout">Log out</a>
      </div>
    </nav>

    <h1>Onboarding</h1>
    <Link :href="purchaseUrl" method="post" as="button" class="btn"
      >Purchase</Link
    >
  </div>
</template>
