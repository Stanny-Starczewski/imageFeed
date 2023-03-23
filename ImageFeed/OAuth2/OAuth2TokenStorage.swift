import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let defaults = UserDefaults.standard
    private let keychainStorage = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            loadKeychainWrapper(for: .token, as: String.self)
        }
        set {
            saveKeychainWrapper(value: newValue, at: .token)
        }
    }
    
    private func loadKeychainWrapper<T: Codable>(for key: Keys, as dataType: T.Type) -> T? {
        guard let data = keychainStorage.data(forKey: key.rawValue),
              let count = try? JSONDecoder().decode(dataType.self, from: data) else {
            return nil
        }
        return count
    }
    
    private func saveKeychainWrapper<T: Codable>(value: T, at key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else {
            print("Failed save data to KeychainWrapper")
            return
        }
        let isSuccess = keychainStorage.set(data, forKey: key.rawValue)
        guard isSuccess else {
            print("Failed save data to KeychainWrapper")
            return
        }
    }
}


