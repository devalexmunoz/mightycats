import "FungibleToken"
import "FlowToken"

transaction(
    address: Address,
    initialFundingAmount: UFix64,
) {
    prepare(adminAccount: AuthAccount) {
        let custodialAccount = getAccount(address)

        // Add some initial funds to the custodial account, pulled from the admin account.  Amount determined by initialFundingAmount
        let custodialAccountFlowTokenBalance = custodialAccount
            .getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/flowTokenBalance)
            .borrow()!
            .balance

        if custodialAccountFlowTokenBalance < 1.0 {
            custodialAccount.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
            .borrow()!
            .deposit(
                from: <- adminAccount.borrow<&{
                    FungibleToken.Provider
                }>(
                    from: /storage/flowTokenVault
                )!.withdraw(amount: initialFundingAmount)
            )
        }
    }
}
