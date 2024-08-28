
import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace, FlovatarDustCollectible, FlovatarDustCollectibleAccessory, FlovatarDustCollectibleTemplate from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address) : [FlovatarDustCollectibleAccessory.CollectibleAccessoryData] {
    // get the accounts' public address objects
    return FlovatarDustCollectibleAccessory.getAccessories(address: address)
}