import FungibleToken from "FungibleToken"
import NonFungibleToken from "NonFungibleToken"
import FlowUtilityToken from "FlowUtilityToken"
import FlowToken from "FlowToken"
import NFTStorefrontV2 from "NFTStorefrontV2"
import MetadataViews from "MetadataViews"
import TokenForwarding from "TokenForwarding"
import Flovatar from "Flovatar"
import FlovatarComponent from "FlovatarComponent"
import FlovatarComponentTemplate from "FlovatarComponentTemplate"
import FlovatarPack from "FlovatarPack"
import FlovatarMarketplace from "FlovatarMarketplace"
import Flobot from "Flobot"
import FlovatarDustToken from "FlovatarDustToken"
import FlovatarDustCollectible from "FlovatarDustCollectible"
import FlovatarDustCollectibleAccessory from "FlovatarDustCollectibleAccessory"
import FlovatarDustCollectibleTemplate from "FlovatarDustCollectibleTemplate"



/*

 The contract that defines the Dust Collectible NFT and a Collection to manage them


This contract contains also the Admin resource that can be used to manage and generate the Dust Collectible Templates.

 */

access(all) contract FlovatarUtils {


    access(all) event ContractInitialized()

    access(all) fun initAccount(account: AuthAccount) {

        self.initAccountShared(account: account)

        let marketplaceCap = account.getCapability<&{FlovatarMarketplace.SalePublic}>(FlovatarMarketplace.CollectionPublicPath)
        if(!marketplaceCap.check()) {
            let wallet =  account.getCapability<&FlowToken.Vault>(/public/flowTokenReceiver)

            // store an empty Sale Collection in account storage
            account.save<@FlovatarMarketplace.SaleCollection>(<- FlovatarMarketplace.createSaleCollection(ownerVault: wallet), to:FlovatarMarketplace.CollectionStoragePath)

            // publish a capability to the Collection in storage
            account.link<&{FlovatarMarketplace.SalePublic}>(FlovatarMarketplace.CollectionPublicPath, target: FlovatarMarketplace.CollectionStoragePath)
        }

        let dustTokenCap = account.getCapability<&FlovatarDustToken.Vault>(FlovatarDustToken.VaultReceiverPath)
        if(!dustTokenCap.check()) {
            let vault <- FlovatarDustToken.createEmptyVault()
            // Store the vault in the account storage
            account.save<@FlovatarDustToken.Vault>(<-vault, to: FlovatarDustToken.VaultStoragePath)
            // Create a public Receiver capability to the Vault
            account.link<&FlovatarDustToken.Vault>(FlovatarDustToken.VaultReceiverPath, target: FlovatarDustToken.VaultStoragePath)
            account.link<&FlovatarDustToken.Vault>(FlovatarDustToken.VaultBalancePath, target: FlovatarDustToken.VaultStoragePath)
        }

    }


    access(all) fun initAccountDapper(account: AuthAccount) {

        self.initAccountShared(account: account)


        // If the account doesn't already have a Storefront
        if account.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath) == nil {

            // Create a new empty Storefront
            let storefront <- NFTStorefrontV2.createStorefront() as! @NFTStorefrontV2.Storefront

            // save it to the account
            account.save(<-storefront, to: NFTStorefrontV2.StorefrontStoragePath)

            // create a public capability for the Storefront
            account.link<&NFTStorefrontV2.Storefront>(NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
        }

        if account.borrow<&{FungibleToken.Receiver}>(from: /storage/flowUtilityTokenReceiver) == nil {
            //TODO REPLACE WITH MAINNET BEFORE GOING LIVE!!!!
            let dapper = getAccount(0x82ec283f88a62e65)
            //TODO REPLACE WITH MAINNET BEFORE GOING LIVE!!!!

            let dapperFUTReceiver = dapper.capabilities.get<&{FungibleToken.Receiver}>(/public/flowUtilityTokenReceiver)!!

            // Create a new Forwarder resource for FUT and store it in the new account's storage
            let futForwarder <- TokenForwarding.createNewForwarder(recipient: dapperFUTReceiver)
            account.save(<-futForwarder, to: /storage/flowUtilityTokenReceiver)

            // Publish a Receiver capability for the new account, which is linked to the FUT Forwarder
            account.link<&FlowUtilityToken.Vault>(
                /public/flowUtilityTokenReceiver,
                target: /storage/flowUtilityTokenReceiver
            )
        }

    }


    access(all) fun initAccountShared(account: AuthAccount) {
        let flovatarCap = account.getCapability<&{Flovatar.CollectionPublic}>(Flovatar.CollectionPublicPath)
        if(!flovatarCap.check()) {
            account.save<@NonFungibleToken.Collection>(<- Flovatar.createEmptyCollection(), to: Flovatar.CollectionStoragePath)
            account.link<&Flovatar.Collection>(Flovatar.CollectionPublicPath, target: Flovatar.CollectionStoragePath)
        }
        let flovatarCapMeta = account.getCapability<&Flovatar.Collection>(Flovatar.CollectionPublicPath)
        if(!flovatarCapMeta.check()) {
            account.unlink(Flovatar.CollectionPublicPath)
            account.link<&Flovatar.Collection>(Flovatar.CollectionPublicPath, target: Flovatar.CollectionStoragePath)
        }

        let flobotCap = account.getCapability<&{Flobot.CollectionPublic}>(Flobot.CollectionPublicPath)
        if(!flobotCap.check()) {
            account.save<@NonFungibleToken.Collection>(<- Flobot.createEmptyCollection(), to: Flobot.CollectionStoragePath)
            account.link<&Flobot.Collection>(Flobot.CollectionPublicPath, target: Flobot.CollectionStoragePath)
        }

        let flovatarComponentCap = account.getCapability<&{FlovatarComponent.CollectionPublic}>(FlovatarComponent.CollectionPublicPath)
        if(!flovatarComponentCap.check()) {
            account.save<@NonFungibleToken.Collection>(<- FlovatarComponent.createEmptyCollection(), to: FlovatarComponent.CollectionStoragePath)
            account.link<&FlovatarComponent.Collection>(FlovatarComponent.CollectionPublicPath, target: FlovatarComponent.CollectionStoragePath)
        }
        let flovatarComponentCapMeta = account.getCapability<&FlovatarComponent.Collection>(FlovatarComponent.CollectionPublicPath)
        if(!flovatarComponentCapMeta.check()) {
            account.unlink(FlovatarComponent.CollectionPublicPath)
            account.link<&FlovatarComponent.Collection>(FlovatarComponent.CollectionPublicPath, target: FlovatarComponent.CollectionStoragePath)
        }

        let flovatarPackCap = account.getCapability<&{FlovatarPack.CollectionPublic}>(FlovatarPack.CollectionPublicPath)
        if(!flovatarPackCap.check()) {
            let wallet =  account.getCapability<&FlowToken.Vault>(/public/flowTokenReceiver)
            account.save<@FlovatarPack.Collection>(<- FlovatarPack.createEmptyCollection(ownerVault: wallet), to: FlovatarPack.CollectionStoragePath)
            account.link<&{FlovatarPack.CollectionPublic}>(FlovatarPack.CollectionPublicPath, target: FlovatarPack.CollectionStoragePath)
        }

        let marketplaceCap = account.getCapability<&{FlovatarMarketplace.SalePublic}>(FlovatarMarketplace.CollectionPublicPath)
        if(!marketplaceCap.check()) {
            let wallet =  account.getCapability<&FlowToken.Vault>(/public/flowTokenReceiver)

            // store an empty Sale Collection in account storage
            account.save<@FlovatarMarketplace.SaleCollection>(<- FlovatarMarketplace.createSaleCollection(ownerVault: wallet), to:FlovatarMarketplace.CollectionStoragePath)

            // publish a capability to the Collection in storage
            account.link<&{FlovatarMarketplace.SalePublic}>(FlovatarMarketplace.CollectionPublicPath, target: FlovatarMarketplace.CollectionStoragePath)
        }

        let flovatarCollectibleCap = account.getCapability<&{FlovatarDustCollectible.CollectionPublic}>(FlovatarDustCollectible.CollectionPublicPath)
        if(!flovatarCollectibleCap.check()) {
            account.save<@NonFungibleToken.Collection>(<- FlovatarDustCollectible.createEmptyCollection(), to: FlovatarDustCollectible.CollectionStoragePath)
            account.link<&FlovatarDustCollectible.Collection>(FlovatarDustCollectible.CollectionPublicPath, target: FlovatarDustCollectible.CollectionStoragePath)
        }

        let flovatarAccessoryCap = account.getCapability<&{FlovatarDustCollectibleAccessory.CollectionPublic}>(FlovatarDustCollectibleAccessory.CollectionPublicPath)
        if(!flovatarAccessoryCap.check()) {
            account.save<@NonFungibleToken.Collection>(<- FlovatarDustCollectibleAccessory.createEmptyCollection(), to: FlovatarDustCollectibleAccessory.CollectionStoragePath)
            account.link<&FlovatarDustCollectibleAccessory.Collection>(FlovatarDustCollectibleAccessory.CollectionPublicPath, target: FlovatarDustCollectibleAccessory.CollectionStoragePath)
        }

    }



	init() {
        emit ContractInitialized()
	}
}
