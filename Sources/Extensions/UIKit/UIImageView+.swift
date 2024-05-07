
import UIKit

public extension UIImageView {

    func pd_blur(with style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }


    func pd_image(with color: UIColor) {
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

public extension UIImageView {

    func pd_loadImage(form url: URL,
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

            DispatchQueue.pd_async_execute_on_main {
                self.image = image
                completionHandler?(image)
            }
        }.resume()
    }

    func pd_loadGifWith(imageNamed: String) {
        DispatchQueue.pd_async_execute_on_global {
            let image = UIImage.pd_loadImageWithGif(name: imageNamed)
            DispatchQueue.pd_async_execute_on_main {
                self.image = image
            }
        }
    }

    func pd_loadGifWith(asset: String) {
        DispatchQueue.pd_async_execute_on_global {
            let image = UIImage.pd_loadImageWithGif(asset: asset)
            DispatchQueue.pd_async_execute_on_main {
                self.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    func pd_loadGifWith(url: String) {
        DispatchQueue.pd_async_execute_on_global {
            let image = UIImage.pd_loadImageWithGif(url: url)
            DispatchQueue.pd_async_execute_on_main {
                self.image = image
            }
        }
    }
}

extension UIImageView {
    public typealias Associatedtype = UIImageView

    @objc override open class func `default`() -> Associatedtype {
        let imageView = UIImageView()
        return imageView
    }
}

public extension UIImageView {

    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    func pd_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    @discardableResult
    func pd_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.pd_blur(with: style)
        return self
    }
}
