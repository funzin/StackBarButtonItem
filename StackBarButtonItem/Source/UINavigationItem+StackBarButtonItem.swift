import UIKit

private let _rightAssociatedKey = UnsafeMutablePointer<UInt>.allocate(capacity: 1)
private let _leftAssociatedKey = UnsafeMutablePointer<UInt>.allocate(capacity: 1)

extension UINavigationItem {
    public var right: StackBarButtonItem {
        get {
            guard let stackBarButtonItem = objc_getAssociatedObject(self, _rightAssociatedKey) as? StackBarButtonItem else {
                let stackBarButtonItem =  StackBarButtonItem(navigationItem: self, position: .right)
                objc_setAssociatedObject(self, _rightAssociatedKey, stackBarButtonItem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return stackBarButtonItem
            }
            return stackBarButtonItem
        }
    }
    
    public var left: StackBarButtonItem {
        get {
            guard let stackBarButtonItem = objc_getAssociatedObject(self, _leftAssociatedKey) as? StackBarButtonItem else {
                let stackBarButtonItem =  StackBarButtonItem(navigationItem: self, position: .left)
                objc_setAssociatedObject(self, _leftAssociatedKey, stackBarButtonItem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return stackBarButtonItem
            }
            return stackBarButtonItem
        }
    }
}
