import "MightyCatsGame"

pub fun main(address: Address): AnyStruct? {
    let userGameplay = MightyCatsGame.usersGameplay[address]
            ?? panic("User gameplay does not exist")

    var lastActivitiesTimestamps = userGameplay.lastActivitiesTimestamps
    let maxLength = Int(MightyCatsGame.activitiesPerCooldown!)

    if(lastActivitiesTimestamps != nil){
        if(lastActivitiesTimestamps!.length > maxLength){
            lastActivitiesTimestamps =  lastActivitiesTimestamps!.slice(from: 0, upTo: maxLength)
        }
    }

    return {
        "last_activities_timestamps": lastActivitiesTimestamps,
        "cooldown": MightyCatsGame.activitiesCooldown,
        "activities_per_cooldown": MightyCatsGame.activitiesPerCooldown
    }
}
