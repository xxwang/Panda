
import UIKit

public extension UIRefreshControl {

    func xx_beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        assert(superview == tableView, "Refresh control does not belong to the receiving table view")

        self.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            self.sendActions(for: .valueChanged)
        }
    }

    func xx_beginRefreshing(animated: Bool, sendAction: Bool = false) {
        guard let scrollView = superview as? UIScrollView else {
            assertionFailure("Refresh control does not belong to a scroll view")
            return
        }

        beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            self.sendActions(for: .valueChanged)
        }
    }
}

public extension UIRefreshControl {
    typealias Associatedtype = UIRefreshControl

    @objc override class func `default`() -> Associatedtype {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }
}
