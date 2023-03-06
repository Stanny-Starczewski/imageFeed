import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let defaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            defaults.string(forKey: Keys.token.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}


