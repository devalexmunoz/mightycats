import "CustodialAccountDirectory"

/// Helper method to determine if a public key is active on an account by comparing the given key against all keys
/// active on the given account.
///
/// @param publicKey: A public key as a string
/// @param address: The address of the
///
/// @return True if the key is active on the account, false otherwise (including if the given public key string was
/// invalid)
///
access(all) fun isKeyActiveOnAccount(publicKey: String, address: Address): Bool {
    // Public key strings must have even length
    if publicKey.length % 2 == 0 {
        var keyIndex = 0
        var keysRemain = true
        // Iterate over keys on given account address
        while keysRemain {
            // Get the key as byte array
            if let keyArray = getAccount(address).keys.get(keyIndex: keyIndex)?.publicKey?.publicKey {
                // Encode the key as a string and compare
                if publicKey == String.encodeHex(keyArray) {
                    return !getAccount(address).keys.get(keyIndex: keyIndex)!.isRevoked
                }
                keyIndex = keyIndex + 1
            } else {
                keysRemain = false
            }
        }
    }
    return false
}

/// Returns the child address associated with a public key if account was created by the AccountCreator.Creator at the
/// specified Address and the provided public key is still active on the account.
///
access(all) view fun main(adminAddress: Address, publicKey: String): Address? {
    let account = getAccount(adminAddress)

    let cap = account
        .capabilities.get<&CustodialAccountDirectory.Directory>(
            CustodialAccountDirectory.DirectoryPublicPath
        )

    if let directoryRef = cap.borrow<&{CustodialAccountDirectory.DirectoryPublic}>() {
        if let address = directoryRef.getAddressFromPublicKey(publicKey: publicKey) {
            // Also check that the given key has not been revoked
            if isKeyActiveOnAccount(publicKey: publicKey, address: address) {
                return address
            }
        }
    }

    return nil
}
