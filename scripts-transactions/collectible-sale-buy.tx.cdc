import FungibleToken from 0xFungible
import NonFungibleToken from 0xNonFungible
import FlowToken from 0xFlowToken
import NFTStorefrontV2 from 0xStorefront2
import MetadataViews from 0xMetadataViews
import FlovatarDustCollectible from 0xFlovatar

transaction(storefrontAddress: Address, listingResourceID: UInt64, expectedPrice: UFix64, commissionRecipient: Address) {
    let paymentVault: @FungibleToken.Vault
    let buyerFlovatarCollection: &FlovatarDustCollectible.Collection{NonFungibleToken.Receiver}
    let storefront: &NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}
    let listing: &NFTStorefrontV2.Listing{NFTStorefrontV2.ListingPublic}
    let balanceBeforeTransfer: UFix64
    let mainFlowVault: &FlowToken.Vault
    let commissionRecipientCap: Capability<&{FungibleToken.Receiver}>

    prepare(buyer: AuthAccount) {

        // Initialize the buyer's account if it is not already initialized
        let flovatarCap = buyer.getCapability<&{FlovatarDustCollectible.CollectionPublic}>(FlovatarDustCollectible.CollectionPublicPath)
        if(!flovatarCap.check()) {
            buyer.save<@NonFungibleToken.Collection>(<- FlovatarDustCollectible.createEmptyCollection(), to: FlovatarDustCollectible.CollectionStoragePath)
            buyer.link<&FlovatarDustCollectible.Collection{FlovatarDustCollectible.CollectionPublic, NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(FlovatarDustCollectible.CollectionPublicPath, target: FlovatarDustCollectible.CollectionStoragePath)
        }

        // Fetch the storefront where the listing exists
        self.storefront = getAccount(storefrontAddress)
              .getCapability<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(
                  NFTStorefrontV2.StorefrontPublicPath
              )!
              .borrow()
              ?? panic("Could not borrow Storefront from provided address")

        // Fetch the listing from the storefront by ID
        self.listing = self.storefront.borrowListing(listingResourceID: listingResourceID)
            ?? panic("No Offer with that ID in Storefront")

        // Get access to Flow Token vault
        let salePrice = self.listing.getDetails().salePrice
        self.mainFlowVault = buyer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FlowToken vault from dapper storage")

        // Withdraw the appropriate amount of DUC from the vault
        self.balanceBeforeTransfer = self.mainFlowVault.balance
        self.paymentVault <- self.mainFlowVault.withdraw(amount: salePrice)

        // Check that the price is what we expect
        if (expectedPrice != salePrice) {
            panic("Expected price does not match sale price")
        }

        self.buyerFlovatarCollection = buyer
            .getCapability<&FlovatarDustCollectible.Collection{NonFungibleToken.Receiver}>(FlovatarDustCollectible.CollectionPublicPath)
            .borrow()
            ?? panic("Cannot borrow Dust Collectible collection receiver from buyer")

        // Access the capability to receive the commission.
        self.commissionRecipientCap = getAccount(commissionRecipient).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
        assert(self.commissionRecipientCap.check(), message: "Commission Recipient doesn't have flowtoken receiving capability")
    }

    execute {
        let item <- self.listing.purchase(
            payment: <-self.paymentVault,
            commissionRecipient: self.commissionRecipientCap
        )

        self.buyerFlovatarCollection.deposit(token: <-item)
    }

    post {

    }
}