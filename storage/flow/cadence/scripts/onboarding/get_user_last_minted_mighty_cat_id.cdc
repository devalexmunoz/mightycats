import "NonFungibleToken"
import "MightyCat"

access(all) view fun main(address: Address): UInt64? {
    let account = getAccount(address)

    let collectionCap = account.capabilities
        .get<&MightyCat.Collection>(MightyCat.CollectionPublicPath)

    let collectionRef = collectionCap.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let ids = collectionRef.getIDs()

    // Preserving original logic
    return ids[ids.length - 1]
}
