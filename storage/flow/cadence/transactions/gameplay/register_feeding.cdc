/// This transction uses the MightyCatsGame Admin resource to register a user MightyCatsGame user activity.
/// It must be run with the account that has the admin resource
/// stored at path /storage/MightyCatsGameAdmin.

import "NonFungibleToken"
import "MightyCat"
import "MightyCatsGame"
import "MetadataViews"

transaction(
    user: Address,
) {

    let currentTimestamp: UFix64

    let admin: &MightyCatsGame.Admin

    let minter: &MightyCat.NFTMinter

    let userGameplay: MightyCatsGame.Gameplay

    let mightyCat: &MightyCat.NFT

    let initialXp: UInt64


    prepare(adminAccount: auth(Storage) &Account) {

        // Borrow a reference to the NFTMinter resource in storage
        self.admin = adminAccount.storage.borrow<&MightyCatsGame.Admin>(from: MightyCatsGame.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Admin resource")

        self.minter = adminAccount.storage.borrow<&MightyCat.NFTMinter>(from: MightyCat.MinterStoragePath)
            ?? panic("Could not borrow a reference to the Minter resource")

        self.userGameplay = MightyCatsGame.usersGameplay[user]
            ?? panic("User gameplay does not exist")

        self.currentTimestamp = getCurrentBlock().timestamp

        let collectionCap = getAccount(user).capabilities.get<&MightyCat.Collection>(MightyCat.CollectionPublicPath)

        let collection = collectionCap.borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not borrow a reference to the collection")

        let ids = collection.getIDs()

        let itemID =  ids[ids.length - 1]

        let nftRef = collection.borrowNFT(id: itemID) ?? panic("Could not borrow NFT reference")
        self.mightyCat = nftRef as! &MightyCat.NFT

        self.initialXp = self.mightyCat.xp
    }

    execute {

        if let lastTimestamp = self.userGameplay.lastFedTimestamp {
            if(!(self.currentTimestamp > lastTimestamp + MightyCatsGame.feedingCooldown)) {
                panic("Cooldown active")
            }
        }

        self.admin.updateUserGameplayLastFedTimestamp(user: user, lastFedTimestamp: self.currentTimestamp)

        self.minter.updateMightyCatXp(mightyCat: self.mightyCat, xp: MightyCatsGame.feedingXp)
    }

    post {
        self.initialXp + MightyCatsGame.feedingXp == self.mightyCat.xp
    }
}
