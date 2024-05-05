//
//  WKWebView+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import WebKit

// MARK: - Defaultable
public extension WKWebView {
    typealias Associatedtype = WKWebView

    override class func `default`() -> Associatedtype {
        let webView = WKWebView(frame: .zero, configuration: WKWebView.defaultConfiguration)
        return webView
    }
}

// MARK: - 静态
public extension WKWebView {
    /// `WKWebViewConfiguration`默认配置
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

// MARK: - 链式语法
public extension WKWebView {
    /// 设置导航代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func pd_navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func pd_uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        uiDelegate = delegate
        return self
    }
}

// MARK: - load方法
public extension WKWebView {
    /// 使用`URL`字符串加载网页
    /// - Parameter string: `URL`字符串
    /// - Returns: `Self`
    @discardableResult
    func pd_load(_ string: String) -> Self {
        if let url = URL(string: string) {
            self.pd_load(url)
        }
        return self
    }

    /// 使用`URL`对象加载网页
    /// - Parameter string: `URL`对象
    /// - Returns: `Self`
    @discardableResult
    func pd_load(_ url: URL) -> Self {
        let request = URLRequest(url: url)
        self.load(request)
        return self
    }
}

// MARK: - 脚本
public extension WKWebView {
    /// 向`WKWebView`注入`javascript`代码
    /// - Parameter script: 要注册的脚本
    /// - Returns: `Self`
    @discardableResult
    func pd_injection(script: String) -> Self {
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        self.configuration.userContentController.addUserScript(userScript)
        return self
    }

    /// 在`WKWebView`执行`javascript`代码
    /// - Parameters:
    ///   - script: 要执行的`JS`脚本
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func pd_evaluate(script: String, completion: ((Any?, Error?) -> Void)? = nil) -> Self {
        self.evaluateJavaScript(script, completionHandler: completion)
        return self
    }

    /// 文字大小调整
    /// - Parameter ratio: 比例
    /// - Returns: `Self`
    @discardableResult
    func pd_textSizeAdjust(_ ratio: CGFloat) -> Self {
        let script = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        self.pd_evaluate(script: script)
        return self
    }

    /// 适配手机(网页显示不正常)
    /// - Returns: `Self`
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
