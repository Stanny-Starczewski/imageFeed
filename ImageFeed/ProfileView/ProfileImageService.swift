import Foundation
import UIKit

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let storageToken = OAuth2TokenStorage().token
    private (set) var avatarURL: String?
    
    private enum NetworkError: Error {
         case codeError
     }

     func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
         assert(Thread.isMainThread)
         if lastCode == token { return }
         task?.cancel()
         lastCode = token
         let request = makeRequest(token: token, username: username)
         let session = URLSession.shared
         let task = session.dataTask(with: request) { (data, response, error) in
             DispatchQueue.main.async {
                 if let error = error {
                     completion(.failure(error))
                     return
                 }
                 if let response = response as? HTTPURLResponse,
                    !(200...299).contains(response.statusCode) {
                     completion(.failure(NetworkError.codeError))
                     return
                 }
                 if let data = data {
                     do {
                         let decodedData = try JSONDecoder().decode(UserResult.self, from: data)
                         let avatarURL = ProfileImage(decodedData: decodedData)
                         self.avatarURL = avatarURL.profileImage["small"]
                         print("avatarURL", self.avatarURL!)
                         completion(.success(self.avatarURL!))
                         NotificationCenter.default.post(
                                 name: ProfileImageService.DidChangeNotification,
                                 object: self,
                                 userInfo: ["URL": self.avatarURL!])
                         self.task = nil
                         if error != nil {
                             self.lastCode = nil
                         }
                     } catch let error {
                         completion(.failure(error))
                     }
                 } else {
                     return
                 }
             }
         }
         self.task = task
         task.resume()
     }

     private func makeRequest(token: String, username: String) -> URLRequest {
         guard let url = URL(string: "\(APIConstants.defaultBaseURL)" + "/users/" + username) else { fatalError("Failed to create URL") }
         var request = URLRequest(url: url)
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         return request
     }
 }

struct UserResult: Codable {
    let profileImage: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let profileImage: [String:String]
    
    init(decodedData: UserResult) {
        self.profileImage = decodedData.profileImage
    }
}

