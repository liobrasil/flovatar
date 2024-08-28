import FungibleToken from 0xFungible
import NonFungibleToken from 0xNonFungible
import Flovatar, FlovatarComponent from 0xFlovatar

transaction(
    componentId: UInt64,
    address: Address) {

    let flovatarComponentCollection: &FlovatarComponent.Collection
    let flovatarComponentReceiverCollection: Capability<&{FlovatarComponent.CollectionPublic}>

    prepare(account: AuthAccount) {
        self.flovatarComponentCollection = account.borrow<&FlovatarComponent.Collection>(from: FlovatarComponent.CollectionStoragePath)!


        let receiverAccount = getAccount(address)
        self.flovatarComponentReceiverCollection = receiverAccount.getCapability<&{FlovatarComponent.CollectionPublic}>(FlovatarComponent.CollectionPublicPath)
    }

    execute {
        let component <- self.flovatarComponentCollection.withdraw(withdrawID: componentId)
        if(component == nil){
            panic("Component not found!")
        }
        self.flovatarComponentReceiverCollection.borrow()!.deposit(token: <-component)
    }
}