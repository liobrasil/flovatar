import FungibleToken from "./../../standardsV1/FungibleToken.cdc"

import Toucans from "../0x577a3c409c5dcb5e/Toucans.cdc"

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
