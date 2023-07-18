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
      class="mighty-cat-container"
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
    top: 14rem;
    @media (min-width: 768px) {
      top: 12rem;
    }
  }

  .mighty-cat-container {
    position: absolute;
    top: 55%;
    transform: translate(0, -50%);
    width: 250px;
    @media (min-width: 768px) {
      width: 300px;
    }
    padding: 1rem;

    &.feeding {
      left: 50%;
      transform: translateX(-150px) scaleX(-1);
      @media (min-width: 768px) {
        transform: translateX(-280px) scaleX(-1);
      }
    }

    &.post-feeding {
      top: 65%;
    }
  }

  .item-food-bowl {
    position: absolute;
    bottom: -1.5rem;
    left: 50%;
    transform: translate(-75%, 0);
    @media (min-width: 768px) {
      transform: translate(-115%, 0);
    }
  }
</style>
