import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let defaults = UserDefaults.standard
    
    var token: String? {
        get {
            defaults.string(forKey: "bearerToken")
        }
        set {
            if let token = newValue {
                defaults.set(newValue, forKey: "bearerToken")
            } else {
                defaults.removeObject(forKey: "bearerToken")
            }
        }
    }
}
