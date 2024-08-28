
import Flobot, Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address, flobotId: UInt64) : Flobot.FlobotData? {

    return Flobot.getFlobot(address: address, flobotId: flobotId)

}