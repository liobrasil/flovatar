
import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address, componentId: UInt64) : FlovatarComponent.ComponentData? {
    // get the accounts' public address objects
    return FlovatarComponent.getComponent(address: address, componentId: componentId)
}