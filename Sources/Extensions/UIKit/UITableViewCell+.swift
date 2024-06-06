import UIKit


public extension UITableViewCell {

    var sk_identifier: String {
        let classNameString = NSStringFromClass(Self.self)
        return classNameString.components(separatedBy: ".").last!
    }
}


public extension UITableViewCell {

    func sk_findTableView() -> UITableView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

public extension UITableViewCell {
    typealias Associatedtype = UITableViewCell

    override class func `default`() -> Associatedtype {
        let cell = UITableViewCell()
        return cell
    }
}

public extension UITableViewCell {

    @discardableResult
    func sk_selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = style
        return self
    }
}
