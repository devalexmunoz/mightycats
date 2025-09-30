import "MightyCatsGame"
import "MightyCat"
import "NonFungibleToken"

access(all) view fun main(address: Address, itemID: UInt64, activityID: UInt64): AnyStruct? {
    let userGameplay = MightyCatsGame.usersGameplay[address]
        ?? panic("User gameplay does not exist")

    let collectionCapability = getAccount(address)
        .capabilities.get<&MightyCat.Collection>(
            MightyCat.CollectionPublicPath
        )

    let collection = collectionCapability.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let mightyCat = collection.borrowNFT(id: itemID) as! &MightyCat.NFT

    return {
        "last_activities_timestamps": userGameplay.lastActivitiesTimestamps,
        "cooldown": MightyCatsGame.feedingCooldown,
        "xp_gained": activity.xp,
        "xp": mightyCat.xp,
        "level": mightyCat.level(),
        "level_progress": mightyCat.levelProgress()
    }
}
