/// This transction uses the MightyCatsGame Admin resource to create a new MightyCatsGame Activity.
/// It must be run with the account that has the admin resource
/// stored at path /storage/MightyCatsGameAdmin.

import "NonFungibleToken"
import "MightyCatsGame"
import "MetadataViews"

transaction(
    name: String,
    xp: UInt64,
) {
    // Local variable for storing the admin resource reference
    let admin: &MightyCatsGame.Admin

    // Previous Activity ID before the transaction executes
    let activityIDBefore: UInt64

    prepare(adminAccount: AuthAccount) {
        // Get the last activity last ID
        self.activityIDBefore = MightyCatsGame.totalActivitiesCreated

        // Borrow a reference to the Admin resource in storage
        self.admin = adminAccount.borrow<&MightyCatsGame.Admin>(from: MightyCatsGame.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Admin resource")

    }

    execute {
        // Create a new Activity
        self.admin.createActivity(
            name: name,
            xp: xp
        )
    }

    post {
        MightyCatsGame.totalActivitiesCreated == self.activityIDBefore + 1: "The total activities created should have been increased by 1"
    }
}
