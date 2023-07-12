const GET_USER_DEMO_CATS_COUNT = `
import "NonFungibleToken"
import "DemoCats"

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(DemoCats.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let ids = collectionRef.getIDs()

    return ids.length
}

`

export default GET_USER_DEMO_CATS_COUNT
