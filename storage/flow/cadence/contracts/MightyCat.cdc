/*
*
*  This contract defines the MightyCat NFT and the collection to manage them.
*
*/

import "NonFungibleToken"
import "ViewResolver"
import "MetadataViews"

access(all) contract MightyCat: NonFungibleToken {

    /// Total supply of MightyCats in existence
    access(all) var totalSupply: UInt64

    /// Events
    access(all) event ContractInitialized()
    access(all) event Withdraw(id: UInt64, from: Address?)
    access(all) event Deposit(id: UInt64, to: Address?)

    /// Storage and Public Paths
    access(all) let CollectionStoragePath: StoragePath
    access(all) let CollectionPublicPath: PublicPath
    access(all) let MinterStoragePath: StoragePath

    /// The core resource that represents a Non Fungible Token.
    /// New instances will be created using the NFTMinter resource
    /// and stored in the Collection resource
    ///
    access(all) resource NFT: NonFungibleToken.NFT, ViewResolver.Resolver {

        /// The unique ID of the NFT
        access(all) let id: UInt64



        /// Metadata fields
        access(all) let name: String
        access(all) let description: String
        access(all) let thumbnail: String
        access(all) let version: UInt64
        access(all) let nickname: String
        access(all) let gender: String
        access(all) let about: String
        access(all) var xp: UInt64

        access(self) let levelMap: {UInt8: UInt64}

        access(self) let royalties: [MetadataViews.Royalty]

        init(
            id: UInt64,
            name: String,
            description: String,
            thumbnail: String,
            version: UInt64,
            nickname: String,
            gender: String,
            about: String,
            royalties: [MetadataViews.Royalty],
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.thumbnail = thumbnail
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

        /// createEmptyCollection creates an empty Collection
        /// and returns it to the caller so that they can own NFTs
        /// @{NonFungibleToken.Collection}
        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- MightyCat.createEmptyCollection(nftType: Type<@MightyCat.NFT>())
        }

        access(all) fun level(): UInt8 {
            let levelMap = self.levelMap
            let xp = self.xp

            var level: UInt8 = 0
            var found = false
            levelMap.forEachKey(fun (key: UInt8): Bool {
                if(xp >= levelMap[key]! && key > level){
                    level = key
                }

                // Iterate over all keys
                return true
            })

            return level
        }

        access(all) fun levelProgress(): UInt64  {
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
        access(all) view fun getViews(): [Type] {
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
        access(all) fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    let name = "Mighty Cat #".concat(self.id.toString())
                    let description = "Mighty Cat with serial number #".concat(self.id.toString())

                    let thumbnailURL = "http://localhost/storage/app/nft/".concat(self.version.toString())
                    let thumbnail = MetadataViews.HTTPFile(url: thumbnailURL)
                    return MetadataViews.Display(
                        name: name,
                        description: description,
                        thumbnail: thumbnail
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
                    return MightyCat.resolveContractView(resourceType: Type<@MightyCat.NFT>(), viewType: Type<MetadataViews.NFTCollectionData>())
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

    /// The resource that will be holding the NFTs inside any account.
    /// In order to be able to manage NFTs any account will need to create
    /// an empty collection first
    ///
   access(all) resource Collection: NonFungibleToken.Collection, ViewResolver.ResolverCollection {
        // Dictionary of NFT conforming tokens
        access(all) var ownedNFTs: @{UInt64: {NonFungibleToken.NFT}}

        init () {
            self.ownedNFTs <- {}
        }

        /// getSupportedNFTTypes returns a list of NFT types that this receiver accepts
        access(all) view fun getSupportedNFTTypes(): {Type: Bool} {
            let supportedTypes: {Type: Bool} = {}
            supportedTypes[Type<@MightyCat.NFT>()] = true
            return supportedTypes
        }

        /// Returns whether or not the given type is accepted by the collection
        /// A collection that can accept any type should just return true by default
        access(all) view fun isSupportedNFTType(type: Type): Bool {
            return type == Type<@MightyCat.NFT>()
        }

        /// Removes an NFT from the collection and moves it to the caller
        ///
        /// @param withdrawID: The ID of the NFT that wants to be withdrawn
        /// @return The NFT resource that has been taken out of the collection
        ///
        access(NonFungibleToken.Withdraw) fun withdraw(withdrawID: UInt64): @{NonFungibleToken.NFT} {

            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        /// Adds an NFT to the collection and adds the ID to the id array
        ///
        /// @param token: The NFT resource to be included in the collection
        ///
        access(all) fun deposit(token: @{NonFungibleToken.NFT}) {
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
        access(all) view fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        /// Gets a reference to an NFT in the collection so that
        /// the caller can read its metadata and call its methods
        ///
        /// @param id: The ID of the wanted NFT
        /// @return A reference to the wanted NFT resource
        ///
        access(all) view fun borrowNFT(_ id: UInt64): &{NonFungibleToken.NFT}? {
            return &self.ownedNFTs[id]
        }

        /// Gets a reference to the NFT only conforming to the `{MetadataViews.Resolver}`
        /// interface so that the caller can retrieve the views that the NFT
        /// is implementing and resolve them
        ///
        /// @param id: The ID of the wanted NFT
        /// @return The resource reference conforming to the Resolver interface
        ///
        access(all) view fun borrowViewResolver(id: UInt64): &{ViewResolver.Resolver}? {
            if let nft = &self.ownedNFTs[id] as &{NonFungibleToken.NFT}? {
                return nft as &{ViewResolver.Resolver}
            }
            return nil
        }

        /// createEmptyCollection creates an empty Collection of the same type
        /// and returns it to the caller
        /// @return A an empty collection of the same type
        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- MightyCat.createEmptyCollection(nftType: Type<@MightyCat.NFT>())
        }
    }

    /// Allows anyone to create a new empty collection
    ///
    /// @return The new Collection resource
    ///
    access(all) fun createEmptyCollection(nftType: Type): @{NonFungibleToken.Collection} {
        return <- create Collection()
    }

    /// Resource that an admin or something similar would own to be
    /// able to mint new NFTs
    ///
    access(all) resource NFTMinter {

        /// Mints a new NFT with a new ID and deposit it in the
        /// recipients collection using their collection reference
        ///
        /// @param recipient: A capability to the collection where the new NFT will be deposited
        /// @param name: The name for the NFT metadata
        /// @param description: The description for the NFT metadata
        /// @param thumbnail: The thumbnail for the NFT metadata
        /// @param royalties: An array of Royalty structs, see MetadataViews docs
        ///
        access(all) fun mintNFT(
            name: String,
            description: String,
            thumbnail: String,
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
                name: name,
                description: description,
                thumbnail: thumbnail,
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

        access(all) fun updateMightyCatXp(
            mightyCat: &MightyCat.NFT,
            xp: UInt64
        ) : UInt64 {
           return  mightyCat.updateXp(xp: xp)
        }
    }

    /// Function that returns all the Metadata Views implemented by a Non Fungible Token
    ///
    /// @return An array of Types defining the implemented views. This value will be used by
    ///         developers to know which parameter to pass to the resolveView() method.
    ///
     access(all) view fun getContractViews(resourceType: Type?): [Type] {
        return [
            Type<MetadataViews.NFTCollectionData>(),
            Type<MetadataViews.NFTCollectionDisplay>()
        ]
    }

    /// Function that resolves a metadata view for this contract.
    ///
    /// @param view: The Type of the desired view.
    /// @return A structure representing the requested view.
    ///
    access(all) fun resolveContractView(resourceType: Type?, viewType: Type): AnyStruct? {
        switch viewType {
            case Type<MetadataViews.NFTCollectionData>():
                return MetadataViews.NFTCollectionData(
                    storagePath: self.CollectionStoragePath,
                    publicPath: self.CollectionPublicPath,
                    publicCollection: Type<&MightyCat.Collection>(),
                    publicLinkedType: Type<&MightyCat.Collection>(),
                    createEmptyCollectionFunction: (fun(): @{NonFungibleToken.Collection} {
                        return <-MightyCat.createEmptyCollection(nftType: Type<@MightyCat.NFT>())
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

    init() {
        // Initialize the total supply
        self.totalSupply = 0

        // Set the named paths
        self.CollectionStoragePath = /storage/MightyCatCollection
        self.CollectionPublicPath = /public/MightyCatCollection
        self.MinterStoragePath = /storage/MightyCatMinter

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.storage.save(<-collection, to: self.CollectionStoragePath)

        // Create a public capability for the collection
        let collectionCap = self.account.capabilities.storage.issue<&MightyCat.Collection>(self.CollectionStoragePath)
        self.account.capabilities.publish(collectionCap, at: self.CollectionPublicPath)

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()
        self.account.storage.save(<-minter, to: self.MinterStoragePath)

        emit ContractInitialized()
    }
}
