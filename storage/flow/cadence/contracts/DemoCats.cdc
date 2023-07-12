import "NonFungibleToken"
import "MetadataViews"

// The DemoCats contract containing sub-types and their specification:
//
// - Events
// - The DemoCat NFT Resource
// - MetadataViews that it supports, and their content
// - The Collection Resource
// - Minter Resource
// - init() function
pub contract DemoCats: NonFungibleToken {

    // totalSupply
    // The total number of DemoCats that have been minted
    //
    pub var totalSupply: UInt64

    // Events
    //
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64, component: CatComponent)

    // Named Paths
    //
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let MinterStoragePath: StoragePath

    pub struct CatComponent {
        pub var version: Int

        init(version: Int) {
            self.version = version
        }
    }

    pub fun componentToString(_ component: CatComponent): String {
        return component.version.toString()
    }

    // A Cat Item as an NFT
    //
    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64

        pub fun name(): String {
            return "Demo Cats"
                .concat(" #")
                .concat(self.id.toString())
        }

        pub fun description(): String {
            return "Demo Cat"
                .concat(" with serial number #")
                .concat(self.id.toString())
        }

        pub fun thumbnail(): MetadataViews.HTTPFile {
          return MetadataViews.HTTPFile(url: "http://localhost/storage/app/nft/".concat(DemoCats.componentToString(self.component)))
        }

        access(self) let royalties: [MetadataViews.Royalty]
        access(self) let metadata: {String: AnyStruct}

        init(
            royalties: [MetadataViews.Royalty],
            metadata: {String: AnyStruct},
            component: DemoCats.CatComponent,
        ) {
            self.id = self.uuid
            self.royalties = royalties
            self.metadata = metadata
            self.component = component
        }

        pub let component: DemoCats.CatComponent

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>(),
                Type<MetadataViews.Royalties>(),
                Type<MetadataViews.Editions>(),
                Type<MetadataViews.ExternalURL>(),
                Type<MetadataViews.NFTCollectionData>(),
                Type<MetadataViews.NFTCollectionDisplay>(),
                Type<MetadataViews.Serial>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    return MetadataViews.Display(
                        name: self.name(),
                        description: self.description(),
                        thumbnail: self.thumbnail()
                    )
                case Type<MetadataViews.Editions>():
                    // There is no max number of NFTs that can be minted from this contract
                    // so the max edition field value is set to nil
                    let editionInfo = MetadataViews.Edition(name: "Demo Cats Edition", number: self.id, max: nil)
                    let editionList: [MetadataViews.Edition] = [editionInfo]
                    return MetadataViews.Editions(
                        editionList
                    )
                case Type<MetadataViews.Serial>():
                    return MetadataViews.Serial(
                        self.id
                    )
                case Type<MetadataViews.Royalties>():
                    return MetadataViews.Royalties(
                        self.royalties
                    )
                case Type<MetadataViews.ExternalURL>():
                    return MetadataViews.ExternalURL("http://localhost/nft/".concat(self.id.toString()))
                case Type<MetadataViews.NFTCollectionData>():
                    return MetadataViews.NFTCollectionData(
                        storagePath: DemoCats.CollectionStoragePath,
                        publicPath: DemoCats.CollectionPublicPath,
                        providerPath: /private/demoCatsCollection,
                        publicCollection: Type<&DemoCats.Collection{DemoCats.DemoCatsCollectionPublic}>(),
                        publicLinkedType: Type<&DemoCats.Collection{DemoCats.DemoCatsCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver,MetadataViews.ResolverCollection}>(),
                        providerLinkedType: Type<&DemoCats.Collection{DemoCats.DemoCatsCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Provider,MetadataViews.ResolverCollection}>(),
                        createEmptyCollectionFunction: (fun (): @NonFungibleToken.Collection {
                            return <-DemoCats.createEmptyCollection()
                        })
                    )
                case Type<MetadataViews.NFTCollectionDisplay>():
                    let media = MetadataViews.Media(
                        file: MetadataViews.HTTPFile(
                            url: "https://assets.website-files.com/5f6294c0c7a8cdd643b1c820/5f6294c0c7a8cda55cb1c936_Flow_Wordmark.svg"
                        ),
                        mediaType: "image/svg+xml"
                    )
                    return MetadataViews.NFTCollectionDisplay(
                        name: "The Demo Cats Collection",
                        description: "This collection is used as a demo.",
                        externalURL: MetadataViews.ExternalURL("http://localhost"),
                        squareImage: media,
                        bannerImage: media,
                        socials: {
                            "twitter": MetadataViews.ExternalURL("https://twitter.com/flow_blockchain")
                        }
                    )
            }
            return nil
        }
    }

    // This is the interface that users can cast their DemoCats Collection as
    // to allow others to deposit DemoCats into their Collection. It also allows for reading
    // the details of DemoCats in the Collection.
    pub resource interface DemoCatsCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowDemoCat(id: UInt64): &DemoCats.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow DemoCats reference: the ID of the returned reference is incorrect"
            }
        }
    }

    // Collection
    // A collection of DemoCats NFTs owned by an account
    //
    pub resource Collection: DemoCatsCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        //
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // initializer
        //
        init () {
            self.ownedNFTs <- {}
        }

        // withdraw
        // removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        // deposit
        // takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @DemoCats.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs
        // returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT
        // gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        // borrowDemoCat
        // Gets a reference to an NFT in the collection as a DemoCat,
        // exposing all of its fields (including the typeID & rarityID).
        // This is safe as there are no functions that can be called on the DemoCat.
        //
        pub fun borrowDemoCat(id: UInt64): &DemoCats.NFT? {
            if self.ownedNFTs[id] != nil {
                // Create an authorized reference to allow downcasting
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &DemoCats.NFT
            }

            return nil
        }

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let demoCat = nft as! &DemoCats.NFT
            return demoCat as &AnyResource{MetadataViews.Resolver}
        }

        // destructor
        destroy() {
            destroy self.ownedNFTs
        }
    }

    // createEmptyCollection
    // public function that anyone can call to create a new empty collection
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // NFTMinter
    // Resource that an admin or something similar would own to be
    // able to mint new NFTs
    //
    pub resource NFTMinter {
        // mintAndReturnNFT
        // mints a new NFT and returns it
        //
        pub fun mintAndReturnNFT(
            component: DemoCats.CatComponent,
            royalties: [MetadataViews.Royalty]
        ): @DemoCats.NFT {
            let metadata: {String: AnyStruct} = {}
            metadata["version"] = component.version

            return <- create NFT(
                royalties: royalties,
                metadata: metadata,
                component: component,
            )
        }

        // mintNFT
        // Mints a new NFT with a new ID
        // and deposit it in the recipients collection using their collection reference
        pub fun mintNFT(
            recipient: &{NonFungibleToken.CollectionPublic},
            component: DemoCats.CatComponent,
            royalties: [MetadataViews.Royalty]
        ) {
            let metadata: {String: AnyStruct} = {}
            metadata["version"] = component.version

            // create a new NFT
            var newNFT <- create DemoCats.NFT(
                royalties: royalties,
                metadata: metadata,
                component: component,
            )

            let mintedID = newNFT.id

            // deposit it in the recipient's account using their reference
            recipient.deposit(token: <-newNFT)

            emit Minted(
                id: mintedID,
                component: component,
            )

            DemoCats.totalSupply = DemoCats.totalSupply + UInt64(1)
        }
    }

    // fetch
    // Get a reference to a DemoCats from an account's Collection, if available.
    // If an account does not have a DemoCats.Collection, panic.
    // If it has a collection but does not contain the itemID, return nil.
    // If it has a collection and that collection contains the itemID, return a reference to that.
    //
    pub fun fetch(_ from: Address, itemID: UInt64): &DemoCats.NFT? {
        let collection = getAccount(from)
            .getCapability(DemoCats.CollectionPublicPath)!
            .borrow<&DemoCats.Collection{DemoCats.DemoCatsCollectionPublic}>()
            ?? panic("Couldn't get collection")
        // We trust DemoCats.Collection.borowDemoCat to get the correct itemID
        // (it checks it before returning it).
        return collection.borrowDemoCat(id: itemID)
    }

    init() {
        // Initialize the total supply
        self.totalSupply = 0

        // Set the named paths
        self.CollectionStoragePath = /storage/demoCatsCollection
        self.CollectionPublicPath = /public/demoCatsCollection
        self.MinterStoragePath = /storage/demoCatsMinter

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.save(<-collection, to: self.CollectionStoragePath)

        // create a public capability for the collection
        self.account.link<&DemoCats.Collection{NonFungibleToken.CollectionPublic, DemoCats.DemoCatsCollectionPublic, MetadataViews.ResolverCollection}>(
            self.CollectionPublicPath,
            target: self.CollectionStoragePath
        )

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()
        self.account.save(<-minter, to: self.MinterStoragePath)

        emit ContractInitialized()
    }
}
