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

// MARK: - 静态方法
public extension WKWebView {
    /// `WKWebViewConfiguration`默认配置
    static var defaultConfiguration: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.selectionGranularity = .dynamic
        config.preferences = WKPreferences()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        if #available(iOS 14, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            config.preferences.javaScriptEnabled = true
        }
        return config
    }
}

// MARK: - load方法
public extension WKWebView {
    /// 以`URL`加载网页
    /// - Parameters:
    ///   - url: `URL`
    ///   - headers: 头信息
    ///   - timeout: 超时时间
    /// - Returns: `WKNavigation?`
    @discardableResult
    func load(_ url: URL?, headers: [String: Any]? = nil, timeout: TimeInterval? = nil) -> WKNavigation? {
        guard let url else { return nil }

        // cookie JS脚本代码
        let cookieSourceCode = "document.cookie = 'user=\("userValue")';"
        let cookieScript = WKUserScript(source: cookieSourceCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(cookieScript)
        configuration.userContentController = userContentController

        var request = URLRequest(url: url)
        if let headFields: [AnyHashable: Any] = request.allHTTPHeaderFields {
            if headFields["user"] != nil {
            } else {
                request.addValue("user=\("userValue")", forHTTPHeaderField: "Cookie")
            }
        }

        // 添加headers
        headers?.forEach { key, value in
            let valueString = (value as? String) ?? ""
            request.addValue(valueString, forHTTPHeaderField: key)
        }

        // 超时时间
        if let timeout {
            request.timeoutInterval = timeout
        }
        return load(request as URLRequest)
    }
}

// MARK: - 脚本
public extension WKWebView {
    /// 向`WKWebView`注入`javascript`代码
    /// - Parameter script: 要注册的脚本
    func injection(_ script: String) {
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
    }

    /// 在`WKWebView`执行`javascript`代码
    /// - Parameters:
    ///   - script: 要执行的`JS`脚本
    ///   - completion: 完成回调
    func evaluate(_ script: String, completion: ((Any?, Error?) -> Void)? = nil) {
        evaluateJavaScript(script, completionHandler: completion)
    }

    /// 文字大小调整
    /// - Parameter ratio: 比例
    func textSizeAdjust(_ ratio: CGFloat) {
        let scriptCode = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        evaluate(scriptCode)
    }

    /// 适配手机(网页显示不正常)
    func fitMobile() {
        let scriptCode = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        evaluate(scriptCode)
    }
}

// MARK: - 链式语法
public extension WKWebView {
    /// 设置导航代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    func pd_navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    func pd_uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        uiDelegate = delegate
        return self
    }
}
