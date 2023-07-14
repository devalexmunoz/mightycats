<script setup>
  import { ref, watchEffect, onBeforeMount, onMounted } from 'vue'
  import { Head, Link } from '@inertiajs/vue3'
  import { logout } from '@/Utils/Auth'
  import { useUserNftModule } from '@/Modules/UserNftModule'
  import MightyCat from '@/Components/MightyCat.vue'

  const userNftModule = useUserNftModule()
  const nftDataFetched = ref(false)

  const updateOnboardingStatus = async () => {
    await axios
      .put(route('onboarding.status'), {
        status: 'nft-revealed',
      })
      .catch(() => {})
  }

  onBeforeMount(async () => {
    const nftData = await userNftModule.getUserNftData()
    // Make sure NFT data is fetched correctly so we can mark reveal as successful
    if (nftData) {
      nftDataFetched.value = true
    }
  })

  onMounted(async () => {
    watchEffect(() => {
      if (nftDataFetched.value) {
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
        <a href="#" @click.prevent="logout">Log out</a>
      </div>
    </nav>

    <h1>Onboarding</h1>
    <template v-if="nftDataFetched">
      <MightyCat />
      <Link :href="$route('home')" as="button" class="btn">Continue</Link>
    </template>
  </div>
</template>
