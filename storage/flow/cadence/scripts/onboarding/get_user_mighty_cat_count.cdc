import "NonFungibleToken"
import "MightyCat"

access(all) fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionCap = account.capabilities
        .get<&MightyCat.Collection>(MightyCat.CollectionPublicPath)

    let collectionRef = collectionCap.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let ids = collectionRef.getIDs()


    return ids.length
}
