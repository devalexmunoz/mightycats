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

    <template v-if="nftData">
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
    </template>
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: linear-gradient(179deg, #c05aff 0%, #715aff 100%);
    overflow: hidden;
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
      margin-bottom: 1rem;
      padding: 0.5rem 1rem;
      border-radius: 1rem 0 1rem 0;
    }

    .icon-female {
      color: #a073ff;
    }
    .icon-male {
      color: #5cdbf8;
    }

    p {
      margin-bottom: 0;
    }
  }

  .presentation-mighty-cat {
    position: absolute;
    top: 12rem;
    width: 350px;
    padding: 0rem 4rem;

    background: var(--background-image) no-repeat;
    background-size: contain;
  }

  .dialog-container {
    width: 35rem;
    margin-top: 12rem;

    .dialog-character {
      width: 170px;
      z-index: 1;
    }
    .dialog-text {
      position: absolute;
      width: 26rem;
      height: 7rem;
      background: rgb(0 0 0 / 50%);
      padding: 1rem;
      padding-left: 3rem;
      left: 7rem;
      top: 6rem;

      border-radius: 0.25rem;
      border: solid 3px #d7ffff;
    }
  }
</style>
