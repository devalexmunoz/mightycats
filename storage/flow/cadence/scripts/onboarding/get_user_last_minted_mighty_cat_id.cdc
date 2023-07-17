import "NonFungibleToken"
import "MightyCat"

pub fun main(address: Address): UInt64? {
    let account = getAccount(address)

    let collectionRef = account.getCapability(MightyCat.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    let ids = collectionRef.getIDs()

    return ids[ids.length - 1]
}
