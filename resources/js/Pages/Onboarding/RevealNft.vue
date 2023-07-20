<script setup>
  import { ref, onBeforeMount } from 'vue'
  import { Head, router } from '@inertiajs/vue3'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import { formatSerial } from '@/Utils/NftData'
  import MightyCat from '@/Components/MightyCat.vue'
  import AnimatedDialog from '@/Components/AnimatedDialog.vue'

  /* Image assets */
  import iconFemale from '@img/icons/icon-female.svg?raw'
  import iconMale from '@img/icons/icon-male.svg?raw'
  import imgCharacters from '@img/onboarding/characters.png'
  import imgDecorationReveal from '@img/onboarding/decoration-reveal.png'

  const userNftModule = useUserNftModule()
  const nftData = ref(null)

  const updateOnboardingStatus = () => {
    return axios
      .put(route('onboarding.status'), {
        status: 'nft-revealed',
      })
      .catch(() => {})
  }

  const redirectHome = () => {
    router.get(route('home'))
  }

  onBeforeMount(async () => {
    nftData.value = await userNftModule.getUserNftData()
  })

  const onButtonClick = () => {
    updateOnboardingStatus().then(redirectHome)
  }
</script>

<template>
  <Head title="Onboarding" />
  <div class="container">
    <div v-if="nftData" class="content">
      <div class="presentation-card">
        <span class="serial"
          >Mighty Cat {{ formatSerial(nftData.itemID) }}</span
        >
        <h3>
          {{ nftData.nickname }}
          <!-- eslint-disable vue/no-v-html -->
          <span
            v-if="nftData.gender === 'F'"
            class="icon-female"
            v-html="iconFemale"
          ></span>
          <span
            v-if="nftData.gender === 'M'"
            class="icon-male"
            v-html="iconMale"
          ></span>
          <!-- eslint-enable vue/no-v-html -->
        </h3>
        <p>{{ nftData.about }}</p>
      </div>

      <div
        class="presentation-mighty-cat"
        :style="`--background-image: url(${imgDecorationReveal})`"
      >
        <MightyCat />
      </div>

      <div class="dialog-container">
        <img class="dialog-character" :src="imgCharacters" />
        <AnimatedDialog class="dialog-text">
          Look at that! It seems like this cat is something special... What do
          you say? You're still looking for a partner right?
        </AnimatedDialog>
      </div>

      <div class="onboarding-action">
        <button
          type="button"
          class="btn btn-primary btn-yellow"
          @click="onButtonClick"
        >
          <span>Let's do it!</span>
        </button>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .container {
    overflow: hidden;
    background: linear-gradient(179deg, #c05aff 0%, #715aff 100%);
  }

  .content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    width: 100%;
    max-width: 1200px;
    padding-top: 4rem;

    @media (width >= 768px) {
      padding-top: 0;
    }
  }

  .presentation-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    width: 360px;
    padding: 1rem 2rem;

    color: #2e39ac;

    background: var(--color-white);
    border-radius: 1rem 0.25rem;

    .serial {
      display: inline-block;

      padding: 0.5rem 1rem;
      margin-top: -2rem;
      margin-bottom: 0.5rem;

      font-weight: bold;
      color: var(--color-white);

      background: #5cdbf8;
      border-radius: 1rem 0;
    }

    h3 {
      margin-bottom: 0.5rem;
    }

    .icon-female {
      color: #a073ff;
    }

    .icon-male {
      color: #5cdbf8;
    }

    p {
      margin-bottom: 0;
      text-align: center;
    }
  }

  .presentation-mighty-cat {
    width: 350px;
    padding: 0 4rem;
    margin: 1rem 0;

    background: var(--background-image) no-repeat;
    background-size: contain;

    @media (width >= 768px) {
      margin: 2rem 0;
    }
  }

  .dialog-container {
    width: 100%;
    max-width: 25rem;

    @media (width >= 768px) {
      max-width: 35rem;
      padding-left: 7rem;

      @media (width >= 768px) {
        margin-top: -1rem;
      }
    }

    .dialog-character {
      position: absolute;
      bottom: 100%;
      left: 0;
      z-index: 1;

      width: 130px;
      margin-bottom: -1rem;

      @media (width >= 768px) {
        top: -5rem;
        bottom: auto;
        left: 0;
        width: 170px;
      }
    }

    .dialog-text {
      width: 100%;
      min-height: 6rem;
      padding: 1rem;

      background: rgb(0 0 0 / 50%);
      border: solid 3px #d7ffff;
      border-radius: 0.25rem;

      @media (width >= 768px) {
        width: 26rem;
        min-height: 7.3rem;
        padding-left: 3rem;
      }
    }
  }

  .onboarding-action {
    margin-top: 1rem;

    @media (width >= 768px) {
      margin-top: 2rem;
    }
  }
</style>
