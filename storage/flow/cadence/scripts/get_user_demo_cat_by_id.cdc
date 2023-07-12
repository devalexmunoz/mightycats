import "NonFungibleToken"
import "MetadataViews"
import "DemoCats"

pub struct DemoCat {
    pub let name: String
    pub let description: String
    pub let thumbnail: String
    pub let itemID: UInt64
    pub let resourceID: UInt64
    pub let owner: Address
    pub let component: DemoCats.CatComponent

    init(
        name: String,
        description: String,
        thumbnail: String,
        itemID: UInt64,
        resourceID: UInt64,
        owner: Address,
        component: DemoCats.CatComponent
    ) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.itemID = itemID
        self.resourceID = resourceID
        self.owner = owner
        self.component = component
    }
}

pub fun main(address: Address, itemID: UInt64): DemoCat? {
    let account = getAccount(address)

    let collectionRef = account.getCapability(DemoCats.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    if let collection = account
        .getCapability<&DemoCats.Collection{NonFungibleToken.CollectionPublic, DemoCats.DemoCatsCollectionPublic}>(DemoCats.CollectionPublicPath)
        .borrow() {
        if let item = collection.borrowDemoCat(id: itemID) {
            if let view = item.resolveView(Type<MetadataViews.Display>()) {
                let display = view as! MetadataViews.Display
                let owner: Address = item.owner!.address!
                let thumbnail = display.thumbnail as! MetadataViews.HTTPFile

                return DemoCat(
                    name: display.name,
                    description: display.description,
                    thumbnail: thumbnail.url,
                    itemID: itemID,
                    resourceID: item.uuid,
                    owner: address,
                    component: item.component
                )
            }
        }
    }

    return nil
}
