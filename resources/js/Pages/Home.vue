<script setup>
  import { computed } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import MightyCat from '@/Components/MightyCat.vue'
  import FeedingAction from '@/Components/Home/FeedingAction.vue'
  import FoodBowl from '@/Components/Items/FoodBowl.vue'

  const feedingModule = useFeedingModule()

  const showActionButtons = computed(() => {
    return feedingModule.getStatus() === 'idle'
  })

  const feed = () => {
    feedingModule.startAction()
  }
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

    <div v-if="showActionButtons" class="actions">
      <button class="btn" @click="feed">Feed</button>
    </div>
  </div>
  <FeedingAction container="#action-container" />
</template>

<style lang="scss" scoped>
  .actions {
    margin: 1rem;

    .btn {
      width: 10rem;
    }
  }
</style>
