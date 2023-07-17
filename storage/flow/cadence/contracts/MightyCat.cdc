/*
*
*  This contract defines the MightyCat NFT and the collection to manage them.
*
*/

import NonFungibleToken from "NonFungibleToken"
import MetadataViews from "MetadataViews"

pub contract MightyCat: NonFungibleToken {

    /// Total supply of MightyCats in existence
    pub var totalSupply: UInt64

    /// Events
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    /// Storage and Public Paths
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let MinterStoragePath: StoragePath

    /// The core resource that represents a Non Fungible Token.
    /// New instances will be created using the NFTMinter resource
    /// and stored in the Collection resource
    ///
    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {

        /// The unique ID of the NFT
        pub let id: UInt64

        /// Metadata fields
        pub let version: UInt64
        pub let nickname: String
        pub let gender: String
        pub let about: String
        pub var xp: UInt64

        access(self) let levelMap: {UInt8: UInt64}

        access(self) let royalties: [MetadataViews.Royalty]

        init(
            id: UInt64,
            version: UInt64,
            nickname: String,
            gender: String,
            about: String,
            royalties: [MetadataViews.Royalty],
        ) {
            self.id = id
            self.version = version
            self.nickname = nickname
            self.gender = gender
            self.about = about
            self.royalties = royalties
            self.xp = 0
            self.levelMap = {
                5: 5000,
                4: 3000,
                3: 1500,
                2: 500,
                1: 0
            }
        }

        pub fun name(): String {
            return "Mighty Cat #"
                .concat(self.id.toString())
        }

        pub fun description(): String {
           return "Mighty Cat with serial number #"
                .concat(self.id.toString())
        }

        pub fun thumbnail(): MetadataViews.HTTPFile {
          return MetadataViews.HTTPFile(url: "http://localhost/storage/app/nft/".concat(self.version.toString()))
        }

        pub fun level(): UInt8 {
            let levelMap = self.levelMap
            let xp = self.xp

            var level: UInt8 = 0
            levelMap.forEachKey(fun (key: UInt8): Bool {
                if(xp >= levelMap[key]!){
                    level = key
                }

                // Continue searching if level has not been found
                return level == 0
            })

            return level
        }

        pub fun levelProgress(): UInt64  {
            let level = self.level()
            // NFT has reached maximum level
            if(!self.levelMap.containsKey(level + 1)){
                return 0
            }

            let currentLevelMinXp = self.levelMap[level]!
            let nextLevelMinXP = self.levelMap[level + 1]!
            let progress = (self.xp - currentLevelMinXp) * 100 / (nextLevelMinXP - currentLevelMinXp)

            return progress
        }

        access(contract) fun updateXp(xp: UInt64): UInt64 {
            self.xp = self.xp + xp
            return self.xp
        }


        /// Function that returns all the implemented Metadata Views
        ///
        /// @return An array of Types defining the implemented views.
        ///
        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>(),
                Type<MetadataViews.Royalties>(),
                Type<MetadataViews.Editions>(),
                Type<MetadataViews.ExternalURL>(),
                Type<MetadataViews.NFTCollectionData>(),
                Type<MetadataViews.NFTCollectionDisplay>(),
                Type<MetadataViews.Serial>(),
                Type<MetadataViews.Traits>()
            ]
        }

        /// Function that resolves a metadata view for this token.
        ///
        /// @param view: The Type of the desired view.
        /// @return A structure representing the requested view.
        ///
        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    return MetadataViews.Display(
                        name: self.name(),
                        description: self.description(),
                        thumbnail: self.thumbnail(),
                    )
                case Type<MetadataViews.Editions>():
                    let editionInfo = MetadataViews.Edition(name: "Mighty Cats", number: self.id, max: nil)
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
                    return MetadataViews.ExternalURL("https://mightycats.io/cat/".concat(self.id.toString()))
                case Type<MetadataViews.NFTCollectionData>():
                    return MetadataViews.NFTCollectionData(
                        storagePath: MightyCat.CollectionStoragePath,
                        publicPath: MightyCat.CollectionPublicPath,
                        providerPath: /private/MightyCatCollection,
                        publicCollection: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic}>(),
                        publicLinkedType: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver,MetadataViews.ResolverCollection}>(),
                        providerLinkedType: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Provider,MetadataViews.ResolverCollection}>(),
                        createEmptyCollectionFunction: (fun (): @NonFungibleToken.Collection {
                            return <-MightyCat.createEmptyCollection()
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
                        name: "Mighty Cats",
                        description: "Save a cat in the real world and rescue a Mighty Cat.",
                        externalURL: MetadataViews.ExternalURL("https://example-nft.onflow.org"),
                        squareImage: media,
                        bannerImage: media,
                        socials: {
                            "twitter": MetadataViews.ExternalURL("https://twitter.com/flow_blockchain")
                        }
                    )
                case Type<MetadataViews.Traits>():
                    let traits = {
                        "nickname": self.nickname,
                        "gender": self.gender,
                        "about": self.about,
                        "xp": self.xp,
                        "level": self.level()
                    }

                    let traitsView = MetadataViews.dictToTraits(dict: traits, excludedNames: nil)

                    return traitsView
            }
            return nil
        }
    }

    /// Defines the methods that are particular to this NFT contract collection
    ///
    pub resource interface MightyCatCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowMightyCat(id: UInt64): &MightyCat.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow MightyCat reference: the ID of the returned reference is incorrect"
            }
        }
    }

    /// The resource that will be holding the NFTs inside any account.
    /// In order to be able to manage NFTs any account will need to create
    /// an empty collection first
    ///
    pub resource Collection: MightyCatCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {
        // Dictionary of NFT conforming tokens
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        /// Removes an NFT from the collection and moves it to the caller
        ///
        /// @param withdrawID: The ID of the NFT that wants to be withdrawn
        /// @return The NFT resource that has been taken out of the collection
        ///
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        /// Adds an NFT to the collection and adds the ID to the id array
        ///
        /// @param token: The NFT resource to be included in the collection
        ///
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @MightyCat.NFT

            let id: UInt64 = token.id

            // Add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        /// Helper method for getting the collection IDs
        ///
        /// @return An array containing the IDs of the NFTs in the collection
        ///
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        /// Gets a reference to an NFT in the collection so that
        /// the caller can read its metadata and call its methods
        ///
        /// @param id: The ID of the wanted NFT
        /// @return A reference to the wanted NFT resource
        ///
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        /// Gets a reference to an NFT in the collection so that
        /// the caller can read its metadata and call its methods
        ///
        /// @param id: The ID of the wanted NFT
        /// @return A reference to the wanted NFT resource
        ///
        pub fun borrowMightyCat(id: UInt64): &MightyCat.NFT? {
            if self.ownedNFTs[id] != nil {
                // Create an authorized reference to allow downcasting
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &MightyCat.NFT
            }

            return nil
        }

        /// Gets a reference to the NFT only conforming to the `{MetadataViews.Resolver}`
        /// interface so that the caller can retrieve the views that the NFT
        /// is implementing and resolve them
        ///
        /// @param id: The ID of the wanted NFT
        /// @return The resource reference conforming to the Resolver interface
        ///
        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let MightyCat = nft as! &MightyCat.NFT
            return MightyCat as &AnyResource{MetadataViews.Resolver}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    /// Allows anyone to create a new empty collection
    ///
    /// @return The new Collection resource
    ///
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    /// Resource that an admin or something similar would own to be
    /// able to mint new NFTs
    ///
    pub resource NFTMinter {

        /// Mints a new NFT with a new ID and deposit it in the
        /// recipients collection using their collection reference
        ///
        /// @param recipient: A capability to the collection where the new NFT will be deposited
        /// @param name: The name for the NFT metadata
        /// @param description: The description for the NFT metadata
        /// @param thumbnail: The thumbnail for the NFT metadata
        /// @param royalties: An array of Royalty structs, see MetadataViews docs
        ///
        pub fun mintNFT(
            version: UInt64,
            nickname: String,
            gender: String,
            about: String,
            recipient: &{NonFungibleToken.CollectionPublic},
            royalties: [MetadataViews.Royalty],
        ) {
            // create a new NFT
            var newNFT <- create NFT(
                id: MightyCat.totalSupply + UInt64(1),
                version: version,
                nickname: nickname,
                gender: gender,
                about: about,
                royalties: royalties,
            )

            // deposit it in the recipient's account using their reference
            recipient.deposit(token: <-newNFT)

            MightyCat.totalSupply = MightyCat.totalSupply + UInt64(1)
        }

        pub fun updateMightyCatXp(
            mightyCat: &MightyCat.NFT,
            xp: UInt64
        ) : UInt64 {
           return  mightyCat.updateXp(xp: xp)
        }
    }

    /// Function that resolves a metadata view for this contract.
    ///
    /// @param view: The Type of the desired view.
    /// @return A structure representing the requested view.
    ///
    pub fun resolveView(_ view: Type): AnyStruct? {
        switch view {
            case Type<MetadataViews.NFTCollectionData>():
                return MetadataViews.NFTCollectionData(
                    storagePath: MightyCat.CollectionStoragePath,
                    publicPath: MightyCat.CollectionPublicPath,
                    providerPath: /private/MightyCatCollection,
                    publicCollection: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic}>(),
                    publicLinkedType: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver,MetadataViews.ResolverCollection}>(),
                    providerLinkedType: Type<&MightyCat.Collection{MightyCat.MightyCatCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Provider,MetadataViews.ResolverCollection}>(),
                    createEmptyCollectionFunction: (fun (): @NonFungibleToken.Collection {
                        return <-MightyCat.createEmptyCollection()
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
                    name: "The Example Collection",
                    description: "This collection is used as an example to help you develop your next Flow NFT.",
                    externalURL: MetadataViews.ExternalURL("https://example-nft.onflow.org"),
                    squareImage: media,
                    bannerImage: media,
                    socials: {
                        "twitter": MetadataViews.ExternalURL("https://twitter.com/flow_blockchain")
                    }
                )
        }
        return nil
    }

    /// Function that returns all the Metadata Views implemented by a Non Fungible Token
    ///
    /// @return An array of Types defining the implemented views. This value will be used by
    ///         developers to know which parameter to pass to the resolveView() method.
    ///
    pub fun getViews(): [Type] {
        return [
            Type<MetadataViews.NFTCollectionData>(),
            Type<MetadataViews.NFTCollectionDisplay>()
        ]
    }

    init() {
        // Initialize the total supply
        self.totalSupply = 0

        // Set the named paths
        self.CollectionStoragePath = /storage/MightyCatCollection
        self.CollectionPublicPath = /public/MightyCatCollection
        self.MinterStoragePath = /storage/MightyCatMinter

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.save(<-collection, to: self.CollectionStoragePath)

        // Create a public capability for the collection
        self.account.link<&MightyCat.Collection{NonFungibleToken.CollectionPublic, MightyCat.MightyCatCollectionPublic, MetadataViews.ResolverCollection}>(
            self.CollectionPublicPath,
            target: self.CollectionStoragePath
        )

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()
        self.account.save(<-minter, to: self.MinterStoragePath)

        emit ContractInitialized()
    }
}
