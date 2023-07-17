import "NonFungibleToken"
import "MightyCat"

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(MightyCat.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let ids = collectionRef.getIDs()

    return ids.length
}
