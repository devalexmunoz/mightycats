<script setup>
  import { ref, onMounted } from 'vue'
  import { Head, router, usePage } from '@inertiajs/vue3'
  import { getAuthUser, updateAuthUserProps } from '@/Utils/Auth'
  import { useMightyCatNftModule } from '@/Modules/MightyCatNftModule'
  import { useCustodialAccountModule } from '@/Modules/CustodialAccountModule'

  const custodialAccountModule = useCustodialAccountModule()
  const mightyCatsNftModule = useMightyCatNftModule()

  const status = ref(null)

  const createCustodialAccount = async () => {
    status.value = 'creating-account'

    const result = await custodialAccountModule.createCustodialAccount()
    if (!result) {
      status.value = 'error'
    }
  }

  const mintNft = async () => {
    const nftProps = usePage().props.nftProps
    if (!nftProps) {
      status.value = 'error'
      return
    }

    status.value = 'minting-nft'

    const mintedNftId = await mightyCatsNftModule.mintMightyCatNftToUserAccount(
      nftProps
    )

    if (!mintedNftId) {
      status.value = 'error'
      return
    }

    await updateOnboardingStatus(mintedNftId)
  }

  const updateOnboardingStatus = async (mintedNftId) => {
    await axios
      .put(route('onboarding.status'), {
        status: 'nft-minted',
        minted_nft_id: mintedNftId,
      })
      .then(() => {
        // This ajax call updates user model properties, so we need to reflect those changes on the current authUser
        updateAuthUserProps({ minted_nft_id: mintedNftId })
        status.value = 'success'
      })
      .catch(() => {
        status.value = 'error'
      })
  }

  onMounted(async () => {
    // Create custodial account if user doesn't already have one
    if (!getAuthUser().custodial_wallet_address) {
      await createCustodialAccount()
      if (status.value === 'error') {
        return
      }
    }

    // Run mint Transaction
    await mintNft()

    // Redirect to reveal page on mint success
    if (status.value === 'success') {
      router.get(route('onboarding.reveal'))
    }
  })
</script>

<template>
  <Head title="Onboarding" />
  <div class="container">
    <h1>Onboarding</h1>

    <p v-if="status === 'creating-account'">Setting up account...</p>
    <p v-else-if="status === 'minting-nft'">Minting NFT...</p>
    <p v-else-if="status === 'error'">
      There was an error setting up your account.<br />
      Please refresh this page to try again.
    </p>
  </div>
</template>

<style lang="scss" scoped>
  p {
    text-align: center;
  }
</style>
