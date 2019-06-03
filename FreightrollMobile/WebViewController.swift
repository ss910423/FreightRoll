import UIKit
import WebKit
import NVActivityIndicatorView

// WKWebView has a bug in iOS < 11 and needs to be added programatically
// https://stackoverflow.com/questions/46793618/ios-wkwebview-vs-uiwebview?noredirect=1&lq=1
class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var activityIndicator: NVActivityIndicatorView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    // Assign in sub-classes as needed
    var url = "https://www.freightroll.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 30, y: 80, width: 60, height: 60), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.app_grey, padding: 0)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("loading")
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
  
}

