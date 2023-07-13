import { usePage } from '@inertiajs/vue3'
import { getAuthUser } from '@/Utils/Auth'
import { useDemoCatsNftModule } from '@/Modules/DemoCatsNftModule'

const demoCatsNftModule = useDemoCatsNftModule()

export async function getUserNftData() {
  let nftData = null

  // Look for stored data in page properties first (i.e. session data)
  const page = usePage()
  nftData = page.props.user_nft
  if (nftData) {
    return nftData
  }

  // If there's no stored data then fetch it from a Cadence script and save it to session
  nftData = await fetchUserNftData()
  if (nftData) {
    await saveUserNftDataToSession(nftData)
    // Update current page props to reflect changes
    page.props.user_nft = nftData
  }

  return nftData
}

const fetchUserNftData = async () => {
  const nftID = getAuthUser().minted_nft_id
  if (!nftID) {
    return null
  }

  return await demoCatsNftModule.getUserDemoCatNftById(nftID)
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
