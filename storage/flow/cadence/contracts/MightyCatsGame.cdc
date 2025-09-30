/*
*
*  This contract defines the MightyCats game resources.
*
*/

access(all) contract MightyCatsGame {

    // Types of MightyItems in existence
    access(all) let activities: {UInt64: Activity}
    access(all) var totalActivitiesCreated: UInt64

    access(all) let usersGameplay: {Address : Gameplay}

    access(all) let feedingXp: UInt64
    access(all) let activitiesPerCooldown: UInt8
    access(all) let activitiesCooldown: UFix64
    access(all) let feedingCooldown: UFix64

    access(all) let AdminStoragePath: StoragePath

    access(all) event ContractInitialized()


    access(all) struct Gameplay {
        access(all) var lastFedTimestamp: UFix64?
        access(all) var lastActivitiesTimestamps: [UFix64]?

        init(
            lastFedTimestamp: UFix64?,
            lastActivitiesTimestamps: [UFix64]?,
        ) {
            self.lastFedTimestamp = lastFedTimestamp
            self.lastActivitiesTimestamps = lastActivitiesTimestamps
        }

         access(all) fun updateLastActivitiesTimestamps(lastActivityTimestamp: UFix64): Gameplay {
            let maxLength = Int(MightyCatsGame.activitiesPerCooldown)

            if(self.lastActivitiesTimestamps == nil){
                self.lastActivitiesTimestamps = [lastActivityTimestamp]
            }else{
                // TOFIX: Condition is not working?
                if(self.lastActivitiesTimestamps?.length == maxLength){
                   self.lastActivitiesTimestamps?.removeLast()
                }

                self.lastActivitiesTimestamps?.insert(at: 0, lastActivityTimestamp)
            }

            return self
        }

        access(all) fun updateLastFedTimestamp(lastFedTimestamp: UFix64?): Gameplay {
            self.lastFedTimestamp = lastFedTimestamp
            return self
        }
    }

    access(all) struct Activity {
        // The unique ID of the Activity
        access(all) let id: UInt64

        // Activity metadata
        access(all) let name: String
        access(all) let xp: UInt64

        init(
            id: UInt64,
            name: String,
            xp: UInt64,
        ) {
            self.id = id
            self.name = name
            self.xp = xp
        }
    }

    access(all) resource Admin {
        access(all) fun createActivity(
            name: String,
            xp: UInt64,
        ) {
            var newActivity: MightyCatsGame.Activity = Activity(
                id: MightyCatsGame.totalActivitiesCreated + UInt64(1),
                name: name,
                xp: xp,
            )

            MightyCatsGame.activities[MightyCatsGame.totalActivitiesCreated + UInt64(1)] = newActivity

            MightyCatsGame.totalActivitiesCreated = MightyCatsGame.totalActivitiesCreated + UInt64(1)
        }

        access(all) fun createUserGameplay(user: Address) {
            var userGameplay = Gameplay(
                lastFedTimestamp: nil,
                lastActivitiesTimestamps: nil,
            )

            MightyCatsGame.usersGameplay[user] = userGameplay
        }

        access(all) fun updateUserGameplayLastActivitiesTimestamps(user: Address, lastActivityTimestamp: UFix64)
        {
            var userGameplay = MightyCatsGame.usersGameplay[user]!

            userGameplay.updateLastActivitiesTimestamps(lastActivityTimestamp: lastActivityTimestamp)

            MightyCatsGame.usersGameplay.insert(key:user, userGameplay)
        }

        access(all) fun updateUserGameplayLastFedTimestamp(user: Address, lastFedTimestamp: UFix64?) {
            var userGameplay = MightyCatsGame.usersGameplay[user]!

            userGameplay.updateLastFedTimestamp(lastFedTimestamp: lastFedTimestamp)

            MightyCatsGame.usersGameplay.insert(key:user, userGameplay)
        }
    }

    init() {
        // Initialize settings
        self.totalActivitiesCreated = 0
        self.activities = {}
        self.usersGameplay = {}

        self.activitiesPerCooldown = 3
        self.activitiesCooldown = 60.0 // 86400.0 // 24 hours
        self.feedingCooldown = 60.0 // 14400.0 // 4 hours

        self.feedingXp = 50

        self.AdminStoragePath = /storage/MightyCatsGameAdmin

        // Create an Admin resource and save it to storage
        let admin <- create Admin()
        self.account.storage.save(<-admin, to: self.AdminStoragePath)

        emit ContractInitialized()
    }
}
