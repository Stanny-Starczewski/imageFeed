import Foundation

 struct APIConstants {
    static let accessKey = "EcpaR11Ji4Tz038kXvQV8KlBFEpB3mI5zdaBqkJ7gS0"
    static let secretKey = "w1wk2mWN6qDOBpEr9XN5R6vE-vb9f7MKpfPHgtFaZZA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let code = "code"
    static let authorizationPath = "/oauth/authorize/native"
    static let baseURL =  URL(string: "https://unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    let code: String
    let authorizationPath: String
    let baseURL: URL
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, code: String, authorizationPath: String, baseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        
        self.code = code
        self.authorizationPath = authorizationPath
        self.baseURL = baseURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: APIConstants.accessKey,
                                 secretKey: APIConstants.secretKey,
                                 redirectURI: APIConstants.redirectURI,
                                 accessScope: APIConstants.accessScope,
                                 authURLString: APIConstants.authorizeURLString,
                                 defaultBaseURL: APIConstants.defaultBaseURL,
                                 
                                 code: APIConstants.code,
                                 authorizationPath: APIConstants.authorizationPath,
                                 baseURL: APIConstants.baseURL)
    }
}
