<script setup>
  import { ref, onMounted } from 'vue'
  import { Head, Link } from '@inertiajs/vue3'
  import { logout, getAuthUser } from '@/Utils/Auth'
  import { useDemoCatsNftModule } from '@/Modules/DemoCatsNftModule'

  const demoCatsNftModule = useDemoCatsNftModule()

  const nftData = ref(null)

  const fetchNftData = async () => {
    const data = await demoCatsNftModule.getUserDemoCatNftById(
      getAuthUser().minted_nft_id
    )
    if (!data) {
      return
    }

    nftData.value = data
    await updateOnboardingStatus()
  }
  const updateOnboardingStatus = async () => {
    await axios
      .put(route('onboarding.status'), {
        status: 'nft-revealed',
      })
      .catch(() => {})
  }

  onMounted(() => {
    fetchNftData()
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
    <p v-if="nftData">NFT Data: {{ nftData }}</p>
    <Link :href="$route('home')" as="button" class="btn">Continue</Link>
  </div>
</template>

<style lang="scss" scoped>
  p {
    max-width: 600px;
    text-align: center;
  }
</style>
