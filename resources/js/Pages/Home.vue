<script setup>
  import { ref, computed, onMounted } from 'vue'
  import { Head, usePage } from '@inertiajs/vue3'
  import { useFeedingModule } from '@/Modules/FeedingModule'
  import Navbar from '@/Components/Home/Navbar.vue'
  import MightyCatInfoCard from '@/Components/Home/MightyCatInfoCard.vue'
  import MightyCat from '@/Components/MightyCat.vue'
  import FoodBowl from '@/Components/Items/FoodBowl.vue'
  import ActionButtons from '@/Components/Home/ActionButtons.vue'
  import FeedingAction from '@/Components/Home/FeedingAction.vue'
  import TrainingAction from '@/Components/Home/TrainingAction.vue'
  import WelcomeModal from '@/Components/Home/WelcomeModal.vue'

  import imgBackground from '@img/home/bg-home.jpg'

  const welcomeModal = ref(null)

  const feedingModule = useFeedingModule()

  const feedingStatus = computed(() => {
    return feedingModule.getStatus()
  })

  const showWelcomeModal = () => {
    welcomeModal.value.open()
  }

  onMounted(() => {
    if (usePage().props.showWelcomeModal) {
      setTimeout(showWelcomeModal, 2000)
    }
  })
</script>

<template>
  <Head title="Home" />
  <div class="container" :style="`--background-image: url(${imgBackground})`">
    <MightyCatInfoCard />

    <Navbar />

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

    <WelcomeModal ref="welcomeModal" />
  </div>
</template>

<style lang="scss" scoped>
  .container {
    overflow: hidden;
    background: var(--background-image) center;
    background-size: cover;
  }

  #action-container {
    position: absolute;
    top: 14rem;

    @media (width >= 768px) {
      top: 12rem;
    }
  }

  .mighty-cat-container {
    position: absolute;
    top: 55%;

    width: 250px;
    padding: 1rem;

    transform: translate(0, -50%);

    @media (width >= 768px) {
      width: 300px;
    }

    &.feeding {
      left: 50%;
      transform: translateX(-150px) scaleX(-1);

      @media (width >= 768px) {
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

    @media (width >= 768px) {
      transform: translate(-115%, 0);
    }
  }
</style>
