import "CustodialAccountDirectory"
import "MightyCatsGame"
import "NonFungibleToken"
import "MightyCat"
import "MetadataViews"
import "FungibleToken"
import "FlowToken"

/// This transaction creates a custodial account from the given public key with the admin account as the
/// account's payer, it then stores the reference to the new account address in the admin's AccountDirectory and
/// additionally funds the new account with the specified amount of Flow from the admin's account.
/// The custodial account is then configured with an empty MightyCat Collection
///
transaction(
    publicKey: String,
    initialFundingAmount: UFix64,
) {
    prepare(adminAccount: auth(Storage, Capabilities, AccountCreator) &Account) {
        /* --- Fetch admin's account directory --- */
        //
        // Ensure resource is saved where expected
        if adminAccount.storage.borrow<&CustodialAccountDirectory.Directory>(from: CustodialAccountDirectory.DirectoryStoragePath) == nil {
            adminAccount.storage.save(
                <-CustodialAccountDirectory.createNewDirectory(),
                to: CustodialAccountDirectory.DirectoryStoragePath
            )
        }
        // Ensure public Capability is linked
        if !adminAccount.capabilities.exists(CustodialAccountDirectory.DirectoryPublicPath) {
            let cap = adminAccount.capabilities.storage.issue<&CustodialAccountDirectory.Directory>(CustodialAccountDirectory.DirectoryStoragePath)
            adminAccount.capabilities.publish(cap, at: CustodialAccountDirectory.DirectoryPublicPath)
        }
        // Get a reference to the client's AccountDirectory.Directory
        let directoryRef = adminAccount.storage.borrow<&CustodialAccountDirectory.Directory>(from: CustodialAccountDirectory.DirectoryStoragePath)
            ?? panic("No AccountDirectory in admin's account!")

        let gameAdminRef = adminAccount.storage.borrow<&MightyCatsGame.Admin>(from: MightyCatsGame.AdminStoragePath)
            ?? panic("Could not borrow a reference to the game admin resource")

        /* --- Account Creation --- */
        //
        // Create the child account, funding via the admin
        let custodialAccount = AuthAccount(payer: adminAccount)
        // Create a public key for the new account from string value in the provided arg
        let key = PublicKey(
            publicKey: publicKey.decodeHex(),
            signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
        )
        // Add the key to the new account
        custodialAccount.keys.add(
            publicKey: key,
            hashAlgorithm: HashAlgorithm.SHA2_256,
            weight: 1000.0
        )
        // Store new account in admin's custodial accounts directory
        directoryRef.storeNewAccount(
            publicKey: publicKey,
            accountAddress: custodialAccount.address
        )

        /* --- Account Funding --- */
        //
        // Fund the new account if specified
        if initialFundingAmount > 0.0 {
            let fundingProvider = adminAccount.storage.borrow<&FlowToken.Vault{FungibleToken.Provider}>(from: /storage/flowTokenVault)
                ?? panic("Could not borrow FlowToken provider")

            let recipientCap = custodialAccount.capabilities.get<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
            let recipient = recipientCap.borrow() ?? panic("Could not borrow receiver")

            recipient.deposit(from: <-fundingProvider.withdraw(amount: initialFundingAmount))
        }

        /* --- Set up MightyCat.Collection --- */
        //
        // create & save it to the account
        custodialAccount.storage.save(<-MightyCat.createEmptyCollection(), to: MightyCat.CollectionStoragePath)

        // create a public capability for the collection
        let collectionCap = custodialAccount.capabilities.storage.issue<&MightyCat.Collection>(MightyCat.CollectionStoragePath)
        custodialAccount.capabilities.publish(collectionCap, at: MightyCat.CollectionPublicPath)

        /* --- Set up User Gameplay --- */
        //
        gameAdminRef.createUserGameplay(user: custodialAccount.address)
    }
}
