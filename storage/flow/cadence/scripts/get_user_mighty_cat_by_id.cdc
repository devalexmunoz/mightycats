import "NonFungibleToken"
import "MetadataViews"
import "MightyCat"

pub struct MightyCatNft {
    pub let version: UInt64
    pub let nickname: String
    pub let gender: String
    pub let about: String

    pub let xp: UInt64
    pub let level: UInt8
    pub let levelProgress: UInt64

    pub let thumbnail: String
    pub let itemID: UInt64
    pub let resourceID: UInt64
    pub let owner: Address

    init(
        version: UInt64,
        nickname: String,
        gender: String,
        about: String,

        xp: UInt64,
        level: UInt8,
        levelProgress: UInt64,

        thumbnail: String,
        itemID: UInt64,
        resourceID: UInt64,
        owner: Address,
    ) {
        self.version = version
        self.nickname = nickname
        self.gender = gender
        self.about = about

        self.xp = xp
        self.level = level
        self.levelProgress = levelProgress

        self.thumbnail = thumbnail
        self.itemID = itemID
        self.resourceID = resourceID
        self.owner = owner
    }
}

pub fun main(address: Address, itemID: UInt64): MightyCatNft? {
    let account = getAccount(address)

    let collectionRef = account.getCapability(MightyCat.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    if let collection = account
        .getCapability<&MightyCat.Collection{NonFungibleToken.CollectionPublic, MightyCat.MightyCatCollectionPublic}>(MightyCat.CollectionPublicPath)
        .borrow() {
        if let item = collection.borrowMightyCat(id: itemID) {
            if let view = item.resolveView(Type<MetadataViews.Display>()) {
                let display = view as! MetadataViews.Display
                let owner: Address = item.owner!.address!
                let thumbnail = display.thumbnail as! MetadataViews.HTTPFile

                return MightyCatNft(
                    version: item.version,
                    nickname: item.nickname,
                    gender: item.gender,
                    about: item.about,

                    xp: item.xp,
                    level: item.level(),
                    levelProgress: item.levelProgress(),

                    thumbnail: thumbnail.url,
                    itemID: itemID,
                    resourceID: item.uuid,
                    owner: address,
                )
            }
        }
    }

    return nil
}
