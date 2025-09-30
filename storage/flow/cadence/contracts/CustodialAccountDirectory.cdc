access(all) contract CustodialAccountDirectory {

    /* Canonical paths */
    //
    access(all) let DirectoryStoragePath: StoragePath
    access(all) let DirectoryPublicPath: PublicPath

    /* Events */
    //
    access(all) event AccountStored(directoryAddress: Address?, directoryUUID: UInt64, storedAccount: Address, publicKey: String)

    /* --- Directory --- */
    //
    access(all) resource interface DirectoryPublic {
        access(all) fun getAddressFromPublicKey(publicKey: String): Address?
        access(all) fun getAllStoredAddresses(): [Address]
    }

    /// Anyone holding this resource can store new accounts, keeping a mapping of each account's originating public
    /// keys to their addresses.
    ///
    access(all) resource Directory : DirectoryPublic {

        /// mapping of public_key: address
        access(self) let storedAccounts: {String: Address}

        init () {
            self.storedAccounts = {}
        }

        access(all) view fun getAddressFromPublicKey(publicKey: String): Address? {
            return self.storedAccounts[publicKey]
        }

        access(all) view fun getAllStoredAddresses(): [Address] {
            return self.storedAccounts.values
        }

        /// Stores a new account, adding the provided public key which indexes
        /// the new account address in this Directory's mapping
        ///
        /// @param publicKey: The public key to add to the new account, for which it's assumed a pairwise
        ///         private key is being managed by the caller
        /// @param accountAddress: The account address associated to the public key
        ///
        /// @return true on success
        ///
        access(all) fun storeNewAccount(
            publicKey: String,
            accountAddress: Address
        ): Bool {
            pre {
                !self.storedAccounts.containsKey(publicKey):
                    "Key has already been used to store an account in this Directory!"
            }

            self.storedAccounts.insert(key:publicKey, accountAddress)
            emit AccountStored(directoryAddress: self.owner?.address, directoryUUID: self.uuid, storedAccount: accountAddress, publicKey: publicKey)
            return true
        }
    }

    access(all) fun createNewDirectory(): @Directory {
        return <-create Directory()
    }

    init() {
        self.DirectoryStoragePath = /storage/CustodialAccountDirectory
        self.DirectoryPublicPath = /public/CustodialAccountDirectoryPublic
    }
}
