import FungibleToken from "./FungibleToken.cdc"
import Toucans from "./toucans/Toucans.cdc"
import FlovatarDustToken from "./FlovatarDustToken.cdc"

access(all)
contract DummyDustTokenMinter{ 
	access(all)
	resource DummyMinter: Toucans.Minter{ 
		access(all)
		fun mint(amount: UFix64): @FlovatarDustToken.Vault{ 
			return <-FlovatarDustToken.createEmptyVault(vaultType: Type<@FlovatarDustToken.Vault>())
		}
	}
	
	access(all)
	fun createMinter(): @DummyMinter{ 
		return <-create DummyMinter()
	}
	
	init(){} 
}
