
import UIKit

public extension UIImageView {

    func sk_blur(with style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }


    func sk_image(with color: UIColor) {
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

public extension UIImageView {

    func sk_loadImage(form url: URL,
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

            DispatchQueue.sk_async_execute_on_main {
                self.image = image
                completionHandler?(image)
            }
        }.resume()
    }

    func sk_loadGifWith(imageNamed: String) {
        DispatchQueue.sk_async_execute_on_global {
            let image = UIImage.sk_loadImageWithGif(name: imageNamed)
            DispatchQueue.sk_async_execute_on_main {
                self.image = image
            }
        }
    }

    func sk_loadGifWith(asset: String) {
        DispatchQueue.sk_async_execute_on_global {
            let image = UIImage.sk_loadImageWithGif(asset: asset)
            DispatchQueue.sk_async_execute_on_main {
                self.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    func sk_loadGifWith(url: String) {
        DispatchQueue.sk_async_execute_on_global {
            let image = UIImage.sk_loadImageWithGif(url: url)
            DispatchQueue.sk_async_execute_on_main {
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
    func sk_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    func sk_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    @discardableResult
    func sk_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        self.sk_blur(with: style)
        return self
    }
}
