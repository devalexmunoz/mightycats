<script setup>
  import { ref, watchEffect, onBeforeMount, onMounted } from 'vue'
  import { Head, Link } from '@inertiajs/vue3'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import { logout } from '@/Utils/Auth'
  import { formatSerial } from '@/Utils/NftData'
  import MightyCat from '@/Components/MightyCat.vue'

  import iconFemale from '@img/icons/icon-female.svg?raw'
  import iconMale from '@img/icons/icon-male.svg?raw'
  import imgCharacters from '@img/onboarding/characters.png'
  import imgDecorationReveal from '@img/onboarding/decoration-reveal.png'
  import AnimatedDialog from '@/Components/AnimatedDialog.vue'

  const userNftModule = useUserNftModule()
  const nftData = ref(null)

  const updateOnboardingStatus = async () => {
    await axios
      .put(route('onboarding.status'), {
        status: 'nft-revealed',
      })
      .catch(() => {})
  }

  onBeforeMount(async () => {
    nftData.value = await userNftModule.getUserNftData()
  })

  onMounted(async () => {
    watchEffect(() => {
      // Make sure NFT data is fetched correctly so we can mark reveal as successful
      if (nftData.value) {
        updateOnboardingStatus()
      }
    })
  })
</script>

<template>
  <Head title="Onboarding" />
  <div class="container">
    <nav class="navbar">
      <div></div>
      <div>
        <a href="#" class="btn" @click.prevent="logout">Log out</a>
      </div>
    </nav>

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
        <Link
          :href="$route('home')"
          as="button"
          class="btn btn-primary btn-yellow"
        >
          <span>Let's do it!</span>
        </Link>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: linear-gradient(179deg, #c05aff 0%, #715aff 100%);
    overflow: hidden;
  }

  .content {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    width: 100%;
    max-width: 1200px;

    padding-top: 4rem;
    @media (min-width: 768px) {
      padding-top: 0;
    }
  }

  .presentation-card {
    background: var(--color-white);
    padding: 1rem 2rem;
    border-radius: 1rem 0.25rem 1rem 0.25rem;
    width: 360px;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    color: #2e39ac;

    .serial {
      display: inline-block;
      background: #5cdbf8;
      color: var(--color-white);
      font-weight: bold;
      margin-top: -2rem;
      margin-bottom: 0.5rem;
      padding: 0.5rem 1rem;
      border-radius: 1rem 0 1rem 0;
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
    margin: 1rem 0;
    @media (min-width: 768px) {
      margin: 2rem 0;
    }
    padding: 0rem 4rem;

    background: var(--background-image) no-repeat;
    background-size: contain;
  }

  .dialog-container {
    width: 100%;
    max-width: 25rem;

    @media (min-width: 768px) {
      max-width: 35rem;

      padding-left: 7rem;
      @media (min-width: 768px) {
        margin-top: -1rem;
      }
    }

    .dialog-character {
      position: absolute;
      bottom: 100%;
      left: 0;
      width: 130px;
      margin-bottom: -1rem;
      z-index: 1;

      @media (min-width: 768px) {
        width: 170px;
        left: 0;
        top: -5rem;
        bottom: auto;
      }
    }
    .dialog-text {
      width: 100%;
      min-height: 6rem;

      background: rgb(0 0 0 / 50%);
      padding: 1rem;
      border-radius: 0.25rem;
      border: solid 3px #d7ffff;

      @media (min-width: 768px) {
        min-height: 7.3rem;
        width: 26rem;
        padding-left: 3rem;
      }
    }
  }

  .onboarding-action {
    margin-top: 1rem;
    @media (min-width: 768px) {
      margin-top: 2rem;
    }
  }
</style>
