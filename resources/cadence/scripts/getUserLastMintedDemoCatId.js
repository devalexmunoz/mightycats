const GET_USER_LAST_MINTED_DEMO_CAT_ID = `
import "NonFungibleToken"
import "DemoCats"

pub fun main(address: Address): UInt64? {
    let account = getAccount(address)

    let collectionRef = account.getCapability(DemoCats.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let ids = collectionRef.getIDs()

    return ids[ids.length - 1]
}

`

export default GET_USER_LAST_MINTED_DEMO_CAT_ID
