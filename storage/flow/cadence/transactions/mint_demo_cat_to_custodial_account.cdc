import "NonFungibleToken"
import "DemoCats"
import "MetadataViews"

// This transction uses the NFTMinter resource to mint a new NFT.
//
// It must be run with the account that has the minter resource
// stored at path /storage/NFTMinter.

transaction(
    version: Int,
) {
    // local variable for storing the minter reference
    let minter: &DemoCats.NFTMinter

    /// Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.CollectionPublic}

    /// Previous NFT ID before the transaction executes
    let mintingIDBefore: UInt64

    prepare(minterAccount: AuthAccount, recipientAccount: AuthAccount) {
        // Get reference to last ID
        self.mintingIDBefore = DemoCats.totalSupply

        // Borrow a reference to the NFTMinter resource in storage
        self.minter = minterAccount.borrow<&DemoCats.NFTMinter>(from: DemoCats.MinterStoragePath)
            ?? panic("Could not borrow a reference to the NFT minter")

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = recipientAccount
            .getCapability(DemoCats.CollectionPublicPath)
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        if self.recipientCollectionRef.getIDs().length > 0 {
            panic("Reached max number of NFTs in collection")
        }
    }

    execute {
        let component = DemoCats.CatComponent(version: version)

        // TODO: Add royalty feature?
        let royalties: [MetadataViews.Royalty] = []

        // mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(
            recipient: self.recipientCollectionRef,
            component: component,
            royalties: royalties
        )
    }

    post {
        DemoCats.totalSupply == self.mintingIDBefore + 1: "The total supply should have been increased by 1"
    }
}
