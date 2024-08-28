
import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)struct Collections {

  pub(set) var address: Address
  pub(set) var flovatars: [Flovatar.FlovatarData]
  pub(set) var flovatarSales: [FlovatarMarketplace.FlovatarSaleData]
  init (_ address:Address) {
    self.address = address
    self.flovatars = []
    self.flovatarSales = []
  }
}

access(all)fun main(address:Address) : Collections {
    let status = Collections(address)

    status.flovatars = Flovatar.getFlovatars(address: address)
    status.flovatarSales = FlovatarMarketplace.getFlovatarSales(address: address)

    return status
}