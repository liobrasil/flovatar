
import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace, FlovatarDustCollectible, FlovatarDustCollectibleAccessory, FlovatarDustCollectibleTemplate from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address, accessoryId:UInt64) : FlovatarDustCollectibleAccessory.CollectibleAccessoryData? {
    // get the accounts' public address objects
    return FlovatarDustCollectibleAccessory.getAccessory(address: address, componentId: accessoryId)
}
