import "CustodialAccountDirectory"
import "NonFungibleToken"
import "DemoCats"
import "MetadataViews"
import "FungibleToken"
import "FlowToken"

/// This transaction creates a custodial account from the given public key with the admin account as the
/// account's payer, it then stores the reference to the new account address in the admin's AccountDirectory and
/// additionally funds the new account with the specified amount of Flow from the admin's account.
/// The custodial account is then configured with an empty DemoCats Collection
///
transaction(
    publicKey: String,
    initialFundingAmount: UFix64,
) {
    prepare(adminAccount: AuthAccount) {
        /* --- Fetch admin's account directory --- */
        //
        // Ensure resource is saved where expected
        if adminAccount.type(at: CustodialAccountDirectory.DirectoryStoragePath) == nil {
            adminAccount.save(
                <-CustodialAccountDirectory.createNewDirectory(),
                to: CustodialAccountDirectory.DirectoryStoragePath
            )
        }
        // Ensure public Capability is linked
        if !adminAccount.getCapability<&CustodialAccountDirectory.Directory{CustodialAccountDirectory.DirectoryPublic}>(
            CustodialAccountDirectory.DirectoryPublicPath).check() {
            // Link the public Capability
            adminAccount.unlink(CustodialAccountDirectory.DirectoryPublicPath)
            adminAccount.link<&CustodialAccountDirectory.Directory{CustodialAccountDirectory.DirectoryPublic}>(
                CustodialAccountDirectory.DirectoryPublicPath,
                target: CustodialAccountDirectory.DirectoryStoragePath
            )
        }
        // Get a reference to the client's AccountDirectory.Directory
        let directoryRef = adminAccount.borrow<&CustodialAccountDirectory.Directory>(
                from: CustodialAccountDirectory.DirectoryStoragePath
            ) ?? panic("No AccountDirectory in admin's account!")

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
            // Get a vault to fund the new account
            let fundingProvider = adminAccount.borrow<&FlowToken.Vault{FungibleToken.Provider}>(
                    from: /storage/flowTokenVault
                )!
            // Fund the new account with the initialFundingAmount specified
            custodialAccount.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
                .borrow()!
                .deposit(
                    from: <-fundingProvider.withdraw(
                        amount: initialFundingAmt
                    )
                )
        }

        /* --- Set up DemoCats.Collection --- */
        //
        // create & save it to the account
        custodialAccount.save(<-DemoCats.createEmptyCollection(), to: custodialAccount.CollectionStoragePath)

        // create a public capability for the collection
        custodialAccount.link<&DemoCats.Collection{NonFungibleToken.CollectionPublic, DemoCats.DemoCatsCollectionPublic, MetadataViews.ResolverCollection}>(DemoCats.CollectionPublicPath, target: DemoCats.CollectionStoragePath)
    }
}
