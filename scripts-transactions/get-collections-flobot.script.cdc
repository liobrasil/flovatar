
import Flobot, Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)struct Collections {

  pub(set) var address: Address
  pub(set) var flobots: [Flobot.FlobotData]
  init (_ address:Address) {
    self.address = address
    self.flobots = []
  }
}

access(all)fun main(address:Address) : Collections {
    // get the accounts' public address objects
    let account = getAccount(address)
    let status = Collections(address)

    status.flobots = Flobot.getFlobots(address: address)

    return status
}