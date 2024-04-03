//
//  PDWebViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit
import WebKit

open class PDWebViewController: PDViewController {
    /// webView配置文件
    lazy var webViewConfig: WKWebViewConfiguration = {
        let config = WKWebView.defaultConfig
        config.userContentController = WKUserContentController()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 12
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        return config
    }()

    /// web浏览器视图
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds, configuration: webViewConfig)
            .pd_uiDelegate(self)
            .pd_navigationDelegate(self)
        return webView
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.webView.add2(self.view)
        self.webView.pd_frame(CGRect(
            x: 0,
            y: self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height,
            width: self.view.pd_width,
            height: self.view.pd_height - (self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height)
        ))
    }
}

// MARK: - WKNavigationDelegate
extension PDWebViewController: WKNavigationDelegate {}

// MARK: - WKUIDelegate
extension PDWebViewController: WKUIDelegate {}

// MARK: - WKScriptMessageHandler
extension PDWebViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {}
}
