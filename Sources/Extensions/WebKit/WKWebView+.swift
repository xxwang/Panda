
import WebKit

public extension WKWebView {
    typealias Associatedtype = WKWebView

    override class func `default`() -> Associatedtype {
        let webView = WKWebView(frame: .zero, configuration: WKWebView.defaultConfiguration)
        return webView
    }
}

public extension WKWebView {
    static var defaultConfiguration: WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.selectionGranularity = .dynamic
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false

        if #available(iOS 14, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        return configuration
    }
}

public extension WKWebView {

    @discardableResult
    func pd_navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        navigationDelegate = delegate
        return self
    }

    @discardableResult
    func pd_uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        uiDelegate = delegate
        return self
    }
}

public extension WKWebView {
    @discardableResult
    func pd_load(_ string: String) -> Self {
        if let url = URL(string: string) {
            self.pd_load(url)
        }
        return self
    }

    @discardableResult
    func pd_load(_ url: URL) -> Self {
        let request = URLRequest(url: url)
        self.load(request)
        return self
    }
}

public extension WKWebView {

    @discardableResult
    func pd_injection(script: String) -> Self {
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.configuration.userContentController.addUserScript(userScript)
        return self
    }

    @discardableResult
    func pd_evaluate(script: String, completion: ((Any?, Error?) -> Void)? = nil) -> Self {
        self.evaluateJavaScript(script, completionHandler: completion)
        return self
    }

    @discardableResult
    func pd_textSizeAdjust(_ ratio: CGFloat) -> Self {
        let script = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        self.pd_evaluate(script: script)
        return self
    }

    @discardableResult
    func pd_fitMobile() -> Self {
        let script = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width');
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        self.pd_evaluate(script: script)
        return self
    }
}
