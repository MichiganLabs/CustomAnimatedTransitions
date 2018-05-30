import UIKit

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )

    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    )
}

/// Default implementations
extension Animatable {
    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    ) {}

    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    ) {}
}
