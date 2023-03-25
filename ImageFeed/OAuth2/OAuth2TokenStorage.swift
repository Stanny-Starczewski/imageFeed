import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keychainStorage = KeychainWrapper.standard

    private enum Keys: String {
        case token
    }

    var token: String? {
        get {
            keychainStorage.string(forKey: "bearerToken")
        }
        set {
            if let token = newValue {
                keychainStorage.set(token, forKey: "bearerToken")
            } else {
                keychainStorage.removeObject(forKey: "bearerToken")
            }
        }
    }
}



