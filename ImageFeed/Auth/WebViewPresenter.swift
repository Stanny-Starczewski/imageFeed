import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func fetchCode(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func fetchCode(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == APIConstants.authorizationPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == APIConstants.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: APIConstants.authorizeURLString)
        urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: APIConstants.accessKey),
                                     URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI),
                                     URLQueryItem(name: "response_type", value: APIConstants.code),
                                     URLQueryItem(name: "scope", value: APIConstants.accessScope)]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            
            didUpdateProgressValue(0)
            
            view?.load(request: request)
        }
    }
    
//    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
//        if let url = navigationAction.request.url,
//           let components = URLComponents(string: url.absoluteString),
//           components.path == APIConstants.authorizationPath,
//           let items = components.queryItems,
//           let codeItem = items.first(where: { $0.name == APIConstants.code }) {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
}
