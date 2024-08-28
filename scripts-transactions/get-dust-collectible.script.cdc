
import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace, FlovatarDustCollectible, FlovatarDustCollectibleAccessory, FlovatarDustCollectibleTemplate from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address, collectibleId:UInt64) : FlovatarDustCollectible.FlovatarDustCollectibleData? {
    // get the accounts' public address objects
    return FlovatarDustCollectible.getCollectible(address: address, collectibleId: collectibleId)
}