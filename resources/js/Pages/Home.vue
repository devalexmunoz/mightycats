<script setup>
  import { computed } from 'vue'
  import { Head } from '@inertiajs/vue3'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import { logout } from '@/Utils/Auth'
  import MightyCatInfoCard from '@/Components/Home/MightyCatInfoCard.vue'
  import MightyCat from '@/Components/MightyCat.vue'
  import FoodBowl from '@/Components/Items/FoodBowl.vue'
  import ActionButtons from '@/Components/Home/ActionButtons.vue'
  import FeedingAction from '@/Components/Home/FeedingAction.vue'
  import TrainingAction from '@/Components/Home/TrainingAction.vue'

  import imgBackground from '@img/home/bg-home.jpg'

  const feedingModule = useFeedingModule()

  const feedingStatus = computed(() => {
    return feedingModule.getStatus()
  })
</script>

<template>
  <Head title="Home" />
  <div class="container" :style="`--background-image: url(${imgBackground})`">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" class="btn" @click.prevent="logout">Log out</a>
      </div>
    </nav>

    <MightyCatInfoCard />

    <div id="action-container"></div>

    <div
      class="mighty-cat"
      :class="{
        feeding: feedingStatus === 'feeding',
        'post-feeding': feedingStatus === 'done' || feedingStatus === 'results',
      }"
    >
      <MightyCat />
    </div>
    <FoodBowl class="item item-food-bowl" />

    <ActionButtons />
    <FeedingAction action-container="#action-container" />
    <TrainingAction />
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: var(--background-image) center;
    background-size: cover;
    overflow: hidden;
  }

  #action-container {
    position: absolute;
    top: 12rem;
  }

  .mighty-cat {
    position: absolute;
    top: 55%;
    transform: translate(0, -50%);
    width: 300px;
    padding: 1rem;

    &.feeding {
      top: 70%;
      left: 30%;
      transform: scale(-1, 1);
    }

    &.post-feeding {
      top: 65%;
    }
  }

  .item-food-bowl {
    position: absolute;
    bottom: -1.5rem;
    left: 15%;
  }
</style>
