import "NonFungibleToken"
import "MetadataViews"
import "MightyCat"

access(all) struct MightyCatNft {
    access(all) let version: UInt64
    access(all) let nickname: String
    access(all) let gender: String
    access(all) let about: String

    access(all) let xp: UInt64
    access(all) let level: UInt8
    access(all) let levelProgress: UInt64

    access(all) let thumbnail: String
    access(all) let itemID: UInt64
    access(all) let resourceID: UInt64
    access(all) let owner: Address

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

access(all) fun main(address: Address, itemID: UInt64): MightyCatNft? {
    let account = getAccount(address)

    let collectionCap = account.capabilities
        .get<&MightyCat.Collection>(MightyCat.CollectionPublicPath)

    if let collection = collectionCap.borrow<&{NonFungibleToken.CollectionPublic}>() {

        if let nft = collection.borrowNFT(id: itemID) {

            if let mightyCat = nft as? &MightyCat.NFT {

                if let view = mightyCat.resolveView(Type<MetadataViews.Display>()) {
                    let display = view as! MetadataViews.Display
                    let thumbnail = display.thumbnail as! MetadataViews.HTTPFile

                    return MightyCatNft(
                        version: mightyCat.version,
                        nickname: mightyCat.nickname,
                        gender: mightyCat.gender,
                        about: mightyCat.about,
                        xp: mightyCat.xp,
                        level: mightyCat.level(),
                        levelProgress: mightyCat.levelProgress(),
                        thumbnail: thumbnail.url,
                        itemID: itemID,
                        resourceID: mightyCat.uuid,
                        owner: address
                    )
                }
            }
        }
    }

    return nil
}
