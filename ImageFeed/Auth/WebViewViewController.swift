import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

//final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
//    var presenter: WebViewPresenterProtocol?
//    //...
//}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        //loadWebView()
        estimatedProgressObservation = webView.observe(
                     \.estimatedProgress,
                      options: [],
                      changeHandler: { [weak self] _, _ in
                          guard let self = self else { return }
                          self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
                      })
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
        func setProgressValue(_ newValue: Float) {
            progressView.progress = newValue
        }
        
        func setProgressHidden(_ isHidden: Bool) {
            progressView.isHidden = isHidden
        }
//    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

private extension WebViewViewController {
    //func loadWebView()

    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.fetchCode(from: url)
        }
        return nil
//           let components = URLComponents(string: url.absoluteString),
//           components.path == APIConstants.authorizationPath,
//           let items = components.queryItems,
//           let codeItem = items.first(where: { $0.name == APIConstants.code }) {
//            return codeItem.value
//        } else {
//            return nil
//        }
    }
}
