// This transction uses the MightyCat NFTMinter resource to mint a new MightyCat NFT.
// It must be run with the account that has the minter resource
// stored at path /storage/NFTMinter.

import "NonFungibleToken"
import "MightyCat"
import "MetadataViews"

transaction(
    version: UInt64,
    nickname: String,
    gender: String,
    about: String,
) {
    // Local variable for storing the minter resource reference
    let minter: &MightyCat.NFTMinter

    // Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.CollectionPublic}

    // Previous NFT ID before the transaction executes
    let mintingIDBefore: UInt64

    prepare(minterAccount: AuthAccount, recipientAccount: AuthAccount) {
        // Get reference to last minted ID
        self.mintingIDBefore = MightyCat.totalSupply

        // Borrow a reference to the NFTMinter resource in storage
        self.minter = minterAccount.borrow<&MightyCat.NFTMinter>(from: MightyCat.MinterStoragePath)
            ?? panic("Could not borrow a reference to the NFT minter")

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = recipientAccount
            .getCapability(MightyCat.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        // Verify if the user has not minted before
        if self.recipientCollectionRef.getIDs().length > 0 {
            panic("Reached max number of NFTs in collection")
        }
    }

    execute {
        // TODO: Add royalty feature?
        let royalties: [MetadataViews.Royalty] = []

        // Mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            version: version,
            nickname: nickname,
            gender: gender,
            about: about,
            recipient: self.recipientCollectionRef,
            royalties: royalties,
        )
    }

    post {
        // Verify that the NFT was delivered and the total supply was increased
        self.recipientCollectionRef.getIDs().contains(self.mintingIDBefore + 1): "The next NFT ID should have been minted and delivered"
        MightyCat.totalSupply == self.mintingIDBefore + 1: "The total supply should have been increased by 1"
    }
}
