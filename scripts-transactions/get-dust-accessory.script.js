import * as fcl from "@onflow/fcl"
import * as t from "@onflow/types"

export async function getDustAccessoryScript(address, accessoryId) {
    if (address == null) return null

    return await fcl
        .query({
            cadence: `
import "Flovatar"
import "FlovatarComponent" 
import "FlovatarComponentTemplate"
import "FlovatarPack"
import "FlovatarMarketplace"
import "FlovatarDustCollectible"
import "FlovatarDustCollectibleAccessory"
import "FlovatarDustCollectibleTemplate"import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(address:Address, accessoryId:UInt64) : FlovatarDustCollectibleAccessory.CollectibleAccessoryData? {
    // get the accounts' public address objects
    return FlovatarDustCollectibleAccessory.getAccessory(address: address, componentId: accessoryId)
}
`,
            args: (arg, t) => [
                arg(address, t.Address),
                arg(''+accessoryId, t.UInt64)
            ],
        });

}
