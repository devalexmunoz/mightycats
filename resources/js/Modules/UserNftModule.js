import { ref } from 'vue'
import { usePage } from '@inertiajs/vue3'
import { getAuthUser } from '@/Utils/Auth'
import { useMightyCatNftModule } from '@/Modules/MightyCatNftModule'

const mightyCatsNftModule = useMightyCatNftModule()

let initialized = false
const userNftData = ref(null)

const getUserNftData = async () => {
  if (!initialized) {
    await initializeUserNftData()
  }

  return userNftData.value
}
const setUserNftData = (nftData) => {
  return (userNftData.value = nftData)
}

const fetchUserNftData = async () => {
  const nftID = getAuthUser().minted_nft_id
  if (!nftID) {
    return null
  }

  return await mightyCatsNftModule.getUserMightyCatNftById(nftID)
}

const saveUserNftDataToSession = async (nftData) => {
  const newSessionData = {
    user_nft: nftData,
  }

  await axios
    .put(route('session.update'), {
      session_data: btoa(JSON.stringify(newSessionData)),
    })
    .catch(() => {})
}

const refreshUserNftData = async () => {
  const nftData = await fetchUserNftData()
  if (nftData) {
    await saveUserNftDataToSession(nftData)
    // Update current page props to reflect changes
    const page = usePage()
    page.props.user_nft = nftData
  }

  setUserNftData(nftData)
}

const initializeUserNftData = async () => {
  if (initialized) {
    return
  }

  let nftData = null
  // Look for stored data in page properties first (i.e. session data)
  const page = usePage()
  nftData = page.props.user_nft
  if (nftData) {
    setUserNftData(nftData)
    return
  }

  // If there's no stored data then fetch it from a Cadence script and save it to session
  nftData = await fetchUserNftData()
  if (nftData) {
    await saveUserNftDataToSession(nftData)
    // Update current page props to reflect changes
    page.props.user_nft = nftData
  }

  setUserNftData(nftData)
  initialized = true
}

export function useUserNftModule() {
  return {
    getUserNftData,
    refreshUserNftData,
  }
}
