<script setup>
  import { ref, onMounted, watchEffect } from 'vue'
  import { Head, router, usePage } from '@inertiajs/vue3'
  import { getAuthUser, updateAuthUserProps } from '@/Utils/Auth'
  import { useMightyCatNftModule } from '@/Modules/MightyCatNftModule'
  import { useCustodialAccountModule } from '@/Modules/CustodialAccountModule'
  import ErrorModal from '@/Components/ErrorModal.vue'

  import imgMinting from '@img/onboarding/img-minting.png'
  import imgCharacters from '@img/onboarding/characters.png'
  import imgBackground from '@img/onboarding/bg-onboarding.png'
  import AnimatedDialog from '@/Components/AnimatedDialog.vue'

  const custodialAccountModule = useCustodialAccountModule()
  const mightyCatsNftModule = useMightyCatNftModule()

  const errorModal = ref(null)
  const status = ref(null)

  watchEffect(() => {
    if (status.value === 'error') {
      showErrorModal()
    }
  })

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

  const showErrorModal = () => {
    errorModal.value.open()
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
  <div class="container" :style="`--background-image: url(${imgBackground})`">
    <img class="img-minting" :src="imgMinting" />

    <div class="dialog-container">
      <img class="dialog-character" :src="imgCharacters" />
      <AnimatedDialog class="dialog-text">
        Thanks for the help! We have secured a kitten and it's now in its way to
        the safe zone. Why don't you meet it there?
      </AnimatedDialog>
    </div>

    <div class="status">
      <p v-if="status === 'creating-account'">Setting up account...</p>
      <p v-else-if="status === 'minting-nft'">Minting NFT...</p>
    </div>

    <!--  Error Modal  -->
    <ErrorModal ref="errorModal" />
  </div>
</template>

<style lang="scss" scoped>
  .container {
    background: var(--background-image),
      linear-gradient(145deg, #140b45 15%, #5a0085 120%);
    background-size: 364px, cover;
    overflow: hidden;
  }

  @keyframes shake {
    0% {
      transform: rotate(-1deg);
    }

    50% {
      transform: rotate(1deg);
    }

    100% {
      transform: rotate(-1deg);
    }
  }

  .img-minting {
    width: 450px;
    position: absolute;
    top: -10rem;
    margin-left: -5rem;

    animation: 0.25s shake ease-in-out infinite;
  }

  .dialog-container {
    width: 35rem;
    margin-top: 18rem;

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

  .status {
    min-height: 1rem;
    margin-top: 3rem;
    text-align: center;
  }
</style>
