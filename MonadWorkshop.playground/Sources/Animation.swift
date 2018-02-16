import UIKit

public extension UIView {
    public func animate(duration: TimeInterval, animation: @escaping (UIView) -> Void) -> Promise<UIView> {
        return Promise<UIView> { aC in
            UIView.animate(withDuration: duration, animations: {
                animation(self)
            }) { finished in
                if finished {
                    aC?(self)
                }
            }
        }
    }
}


public extension Promise where T == UIView {

    public func animate(with duration: TimeInterval, animation: @escaping (UIView) -> Void) -> Promise<UIView> {
        return self.bind { view in
            view.animate(duration: duration, animation: animation)
        }
    }

}
