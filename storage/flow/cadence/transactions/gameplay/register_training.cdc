/// This transction uses the MightyCatsGame Admin resource to register a user MightyCatsGame user activity.
/// It must be run with the account that has the admin resource
/// stored at path /storage/MightyCatsGameAdmin.

import "MightyCat"
import "MightyCatsGame"

transaction(
    user: Address,
    activityID: UInt64,
) {

    let currentTimestamp: UFix64

    let activities: {UInt64: MightyCatsGame.Activity}

    let admin: &MightyCatsGame.Admin

    let minter: &MightyCat.NFTMinter

    let userGameplay: MightyCatsGame.Gameplay

    let activity: MightyCatsGame.Activity

    let mightyCat: &MightyCat.NFT

    let initialXp: UInt64


    prepare(adminAccount: AuthAccount) {
         // Borrow a reference to the NFTMinter resource in storage
        self.admin = adminAccount.borrow<&MightyCatsGame.Admin>(from: MightyCatsGame.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Admin resource")

        self.minter = adminAccount.borrow<&MightyCat.NFTMinter>(from: MightyCat.MinterStoragePath)
            ?? panic("Could not borrow a reference to the Minter resource")

        self.activities = MightyCatsGame.activities

        self.activity = MightyCatsGame.activities[activityID]
            ?? panic("Actiivity does not exist")

        self.userGameplay = MightyCatsGame.usersGameplay[user]
            ?? panic("User gameplay does not exist")

        self.currentTimestamp = getCurrentBlock().timestamp

         let collection = getAccount(user)
        .getCapability(MightyCat.CollectionPublicPath)
        .borrow<&{MightyCat.MightyCatCollectionPublic}>()
        ?? panic("Could not borrow a reference to the collection")

        let ids = collection.getIDs()

        let itemID =  ids[ids.length - 1]

        self.mightyCat = collection.borrowMightyCat(id: itemID)!

        self.initialXp = self.mightyCat.xp
    }

    execute {
        var currentTimestamp = self.currentTimestamp
        var lastActivitiesTimestamps = self.userGameplay.lastActivitiesTimestamps ?? nil

        var cooldownActive = true
        if(lastActivitiesTimestamps == nil){
            cooldownActive = false
        }else{
            for timestamp in lastActivitiesTimestamps! {
                if(currentTimestamp > timestamp + MightyCatsGame.activitiesCooldown){
                    cooldownActive = false
                }
            }
        }

        if(cooldownActive) {
            panic("Cooldown active")
        }

        self.admin.updateUserGameplayLastActivitiesTimestamps(user: user, lastActivityTimestamp: currentTimestamp)

        self.minter.updateMightyCatXp(mightyCat: self.mightyCat, xp: self.activity.xp)
    }

    post {
        self.initialXp + self.activity.xp == self.mightyCat.xp
    }
}
