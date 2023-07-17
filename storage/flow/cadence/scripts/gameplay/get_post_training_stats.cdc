import "MightyCatsGame"
import "MightyCat"

pub fun main(address: Address, itemID: UInt64, activityID: UInt64): AnyStruct? {
    let userGameplay = MightyCatsGame.usersGameplay[address]
            ?? panic("User gameplay does not exist")

    let collection = getAccount(address)
        .getCapability(MightyCat.CollectionPublicPath)
        .borrow<&{MightyCat.MightyCatCollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

    let mightyCat = collection.borrowMightyCat(id: itemID)!

    let activity = MightyCatsGame.activities[activityID]!

    return {
        "last_activities_timestamps": userGameplay.lastActivitiesTimestamps,
        "cooldown": MightyCatsGame.feedingCooldown,
        "xp_gained": activity.xp,
        "xp": mightyCat.xp,
        "level": mightyCat.level(),
        "level_progress": mightyCat.levelProgress()
    }
}
