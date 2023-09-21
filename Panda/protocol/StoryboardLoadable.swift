//
//  StoryboardLoadable.swift
//  xcode15-demo
//
//  Created by 奥尔良小短腿 on 2023/9/21.
//

import UIKit

// MARK: - Xib加载
public protocol StoryBoardLoadable {}

public extension StoryBoardLoadable where Self: UIViewController {
    
    
    /// 加载UIMainStoryboard中的控制器
    /// - Parameters:
    ///   - name: 要加载的控制器(跟UIMainStoryboard中Identifier一致)
    ///   - bundle: UIMainStoryboard所在bundle(不传默认main)
    ///   - sbFileName: UIMainStoryboard文件名称
    /// - Returns: 指定控制器
    static func loadSB(withClass name: Self.Type, in bundle: Bundle? = nil, sbFileName: String? = nil) -> Self? {
        let bundle = bundle ?? Bundle.main
        guard let sbFileName = sbFileName ?? bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        let sb = UIStoryboard(name: sbFileName, bundle: bundle)
        return sb.instantiateViewController(withIdentifier: String(describing: name)) as? Self
    }
}

