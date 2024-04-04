//
//  UIImageView+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - 方法
public extension UIImageView {
    /// 添加模糊效果
    /// - Parameter style:模糊效果的样式
    func blur(with style: UIBlurEffect.Style = .light) {
        // 模糊效果
        let blurEffect = UIBlurEffect(style: style)
        // 效果View
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 设置效果view的尺寸
        blurEffectView.frame = bounds
        // 支持设备旋转
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 添加效果到图片
        addSubview(blurEffectView)
    }

    /// 修改图像的颜色
    /// - Parameter color:要修改成的颜色
    func image(with color: UIColor) {
        // .automatic 根据图片的使用环境和所处的绘图上下文自动调整渲染模式.
        // .alwaysOriginal 始终绘制图片原始状态,不使用Tint Color.
        // .alwaysTemplate 始终根据Tint Color绘制图片,忽略图片的颜色信息.
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}

// MARK: - 加载图片
public extension UIImageView {
    /// 从`URL`下载网络图片并设置到`UIImageView`
    /// - Parameters:
    ///   - url:图片URL地址
    ///   - contentMode:图片视图内容模式
    ///   - placeholder:占位图片
    ///   - completionHandler:完成回调
    func loadImage(form url: URL,
                   contentMode: UIView.ContentMode = .scaleAspectFill,
                   placeholder: UIImage? = nil,
                   completionHandler: ((UIImage?) -> Void)? = nil)
    {
        image = placeholder
        self.contentMode = contentMode

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data,
                let image = UIImage(data: data)
            else {
                completionHandler?(nil)
                return
            }

            DispatchQueue.async_execute_on_main {
                self.image = image
                completionHandler?(image)
            }
        }.resume()
    }

    /// 加载本地`Gif`图片的名称
    /// - Parameter name:图片名称
    func loadGifWith(imageNamed: String) {
        DispatchQueue.async_execute_on_global {
            let image = UIImage.loadImageWithGif(name: imageNamed)
            DispatchQueue.async_execute_on_main {
                self.image = image
            }
        }
    }

    /// 加载`Asset`中的`Gif`图片
    /// - Parameter asset:`asset`中的图片名称
    func loadGifWith(asset: String) {
        DispatchQueue.async_execute_on_global {
            let image = UIImage.loadImageWithGif(asset: asset)
            DispatchQueue.async_execute_on_main {
                self.image = image
            }
        }
    }

    /// 加载网络`URL`的`Gif`图片
    /// - Parameter url:`Gif`图片URL地址
    @available(iOS 9.0, *)
    func loadGifWith(url: String) {
        DispatchQueue.async_execute_on_global {
            let image = UIImage.loadImageWithGif(url: url)
            DispatchQueue.async_execute_on_main {
                self.image = image
            }
        }
    }
}

// MARK: - Defaultable
public extension UIImageView {
    typealias Associatedtype = UIImageView

    override class func `default`() -> Associatedtype {
        let imageView = UIImageView()
        return imageView
    }
}

// MARK: - 链式语法
public extension UIImageView {
    /// 设置图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// 设置高亮状态的图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func pd_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// 设置模糊效果
    /// - Parameter style:模糊效果样式
    /// - Returns:`Self`
    @discardableResult
    func pd_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        blur(with: style)
        return self
    }
}
