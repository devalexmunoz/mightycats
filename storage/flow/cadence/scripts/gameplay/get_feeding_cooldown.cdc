import "MightyCatsGame"

access(all) view fun main(address: Address): AnyStruct? {
    let userGameplay = MightyCatsGame.usersGameplay[address]
            ?? panic("User gameplay does not exist")

    return {
        "last_fed_timestamp": userGameplay.lastFedTimestamp,
        "cooldown": MightyCatsGame.feedingCooldown
    }
}
