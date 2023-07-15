<script setup>
  import { Head } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'
  import MightyCat from '@/Components/MightyCat.vue'
  import FoodBowl from '@/Components/Items/FoodBowl.vue'
  import ActionButtons from '@/Components/Home/ActionButtons.vue'
  import FeedingAction from '@/Components/Home/FeedingAction.vue'
  import TrainingAction from '@/Components/Home/TrainingAction.vue'
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

    <div id="action-container"></div>

    <MightyCat />
    <FoodBowl />

    <ActionButtons />
    <FeedingAction action-container="#action-container" />
    <TrainingAction />
  </div>
</template>
