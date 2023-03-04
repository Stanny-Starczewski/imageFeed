import UIKit
import WebKit

private struct APIConstants {
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let code = "code"
    static let authorizationPath = "/oauth/authorize/native"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
        updateProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(from: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var components = URLComponents(string: APIConstants.authorizeURLString)
        components?.queryItems = [URLQueryItem(name: "client_id", value: AccessKey),
                                  URLQueryItem(name: "redirect_uri", value: RedirectURI),
                                  URLQueryItem(name: "response_type", value: APIConstants.code),
                                  URLQueryItem(name: "scope", value: AccessScope)]
        if let url = components?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func fetchCode(from url: URL?) -> String? {
        if let url = url,
           let components = URLComponents(string: url.absoluteString),
           components.path == APIConstants.authorizationPath,
           let codeItem = components.queryItems?.first(where: { $0.name == APIConstants.code }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
