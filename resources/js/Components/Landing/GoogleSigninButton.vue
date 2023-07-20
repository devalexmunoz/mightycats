<script setup>
  import { onMounted, ref } from 'vue'
  import { router } from '@inertiajs/vue3'

  const btnContainer = ref(null)
  const loadGoogleClient = () => {
    let googleClientScriptTag = document.createElement('script')
    googleClientScriptTag.onload = initGoogleSigninButton
    googleClientScriptTag.src = 'https://accounts.google.com/gsi/client'
    document.head.appendChild(googleClientScriptTag)
  }

  const initGoogleSigninButton = () => {
    google.accounts.id.initialize({
      client_id: import.meta.env.VITE_GOOGLE_CLIENT_ID,
      callback: onGoogleSignin,
    })

    google.accounts.id.renderButton(btnContainer.value, {
      theme: 'outline',
      locale: 'en-US',
    })
    google.accounts.id.prompt()
  }

  const onGoogleSignin = (response) => {
    router.post(route('auth.provider-signin'), {
      credential: response.credential,
    })
  }

  onMounted(() => {
    // Be careful with this method, it should only be called once per pageload to avoid repeatedly loading the script,
    // in this case we make sure this component is only mounted once using v-show insted of v-if on LoginModal.vue
    loadGoogleClient()
  })
</script>

<template>
  <div id="google-button-container" ref="btnContainer"></div>
</template>

<style lang="scss" scoped>
  #google-button-container {
    min-height: 40px;
  }
</style>
