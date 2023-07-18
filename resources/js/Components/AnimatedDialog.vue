<script setup>
  import { ref, onMounted } from 'vue'

  const emit = defineEmits(['animated'])

  const dialogInput = ref(null)
  const animatedDialogText = ref('')

  const animateDialog = () => {
    const text = dialogInput.value.innerText
    dialogInput.value.remove()

    const chars = Array.from(text)

    let animationInterval = setInterval(() => {
      animatedDialogText.value += chars.shift()
      if (!chars.length) {
        clearTimeout(animationInterval)
        emit('animated')
      }
    }, 24)
  }

  onMounted(() => {
    setTimeout(animateDialog, 500)
  })
</script>

<template>
  <div>
    <div v-show="false" ref="dialogInput">
      <slot></slot>
    </div>
    <p v-text="animatedDialogText"></p>
  </div>
</template>

<style lang="scss" scoped>
  p {
    margin-bottom: 0;
  }
</style>
