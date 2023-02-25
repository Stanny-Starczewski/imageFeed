import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}
