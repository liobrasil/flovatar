import Flobot from 0xFlovatar
import NonFungibleToken from 0xNonFungible
import FungibleToken from 0xFungible
import FlowToken from 0xFlowToken

access(all)fun main(
    body: UInt64,
    head: UInt64,
    arms: UInt64,
    legs: UInt64,
    face: UInt64) : Bool {

    return Flobot.checkCombinationAvailable(body: body, head: head, arms: arms, legs: legs, face: face)

}