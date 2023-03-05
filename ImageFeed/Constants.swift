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
