
import UIKit


public extension UISearchBar {

    var pd_textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        let subViews = subviews.flatMap(\.subviews)
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }


    var pd_trimmedText: String? {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


public extension UISearchBar {

    func pd_clear() {
        self.text = ""
    }
}


public extension UISearchBar {
    typealias Associatedtype = UISearchBar

    @objc override class func `default`() -> Associatedtype {
        let searchBar = UISearchBar()
        return searchBar
    }
}


public extension UISearchBar {}
