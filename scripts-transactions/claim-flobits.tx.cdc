import Flovatar, FlovatarComponent, FlovatarComponentTemplate, FlovatarPack, FlovatarMarketplace, FlovatarDustToken, FlovatarInbox from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

//this transaction will claim all content of the Inbox
transaction() {

    let flovatarCollection: &Flovatar.Collection
    let address: Address

    prepare(account: AuthAccount) {
        self.flovatarCollection = account.borrow<&Flovatar.Collection>(from: Flovatar.CollectionStoragePath)!
        self.address = account.address

    }

    execute {


        FlovatarInbox.withdrawWalletComponent(address: self.address)

        var count: UInt32 = 0
        for id in self.flovatarCollection.getIDs() {
             if(FlovatarInbox.getFlovatarComponentIDs(id: id).length > Int(0) && count < UInt32(20)){
                FlovatarInbox.withdrawFlovatarComponent(id: id, address: self.address)
                count = count + UInt32(1)
            }
        }
    }
}