import FlovatarInbox from "../contracts/FlovatarInbox.cdc"

access(all)fun main() : UFix64 {

    return FlovatarInbox.getCommunityDustBalance()
}