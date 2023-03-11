import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        if lastCode == code {return}
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    private func makeRequest(code: String) -> URLRequest {
        guard let url = URL(string: "...\(code)") else {fatalError("Faild to create URL")}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

private func authTokenRequest(code: String) -> URLRequest {
    URLRequest.makeHTTPRequest(
        path: "/oauth/token"
        + "?client_id=\(APIConstants.accessKey)"
        + "&&client_secret=\(APIConstants.secretKey)"
        + "&&redirect_uri=\(APIConstants.redirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code",
        httpMethod: "POST",
        baseURL: URL(string: "\(APIConstants.baseURL)")!
    )}

// MARK: - Decoding

struct OAuthTokenResponseBody: Decodable {
    let accessToken, tokenType, scope: String
    let createdAt: Date
   
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

// MARK: - URLSession

extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping(Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        return urlSession.data(for: request, completion: {(result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = APIConstants.defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}



// MARK: - Network Connection

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}



