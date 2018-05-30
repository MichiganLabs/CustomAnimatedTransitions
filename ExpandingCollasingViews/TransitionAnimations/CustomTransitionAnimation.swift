import UIKit

class CustomTransitionAnimation: NSObject {
    fileprivate let operationType: UINavigationControllerOperation
    fileprivate let positioningDuration: TimeInterval
    fileprivate let resizingDuration: TimeInterval

    init(
        operation: UINavigationControllerOperation,
        positioningDuration: TimeInterval,
        resizingDuration: TimeInterval
    ) {
        self.operationType = operation
        self.positioningDuration = positioningDuration
        self.resizingDuration = resizingDuration
    }
}

extension CustomTransitionAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return max(self.resizingDuration, self.positioningDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.operationType == .push {
            self.presentTransition(transitionContext)
        } else if self.operationType == .pop {
            self.dismissTransition(transitionContext)
        }
    }
}

/// Perform custom presentation and dismiss animations
extension CustomTransitionAnimation {
    // Custom push animations
    internal func presentTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        // ===========================================================
        // Step 1: Get the views we are animating
        // ===========================================================

        // Views we are animating FROM
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromContainer = fromVC.containerView,
            let fromChild = fromVC.childView
        else {
            return
        }

        // Views we are animating TO
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }

        // Preserve the original frame of the toView
        let originalFrame = toView.frame

        container.addSubview(toView)

        // ===========================================================
        // Step 2: Determine start and end points for animation
        // ===========================================================

        // Get the coordinates of the view inside the container
        let originFrame = CGRect(
            origin: fromContainer.convert(fromChild.frame.origin, to: container),
            size: fromChild.frame.size
        )
        let destinationFrame = toView.frame

        toView.frame = originFrame
        toView.layoutIfNeeded()

        fromChild.isHidden = true

        // ===========================================================
        // Step 3: Perform the animation
        // ===========================================================

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        // For the duration of the animation, we are moving the frame. Therefore we have a separate animator
        // to just control the Y positioning of the views. We will also use this animator to determine when
        // all of our animations are done.

        // Animate the card's vertical position
        let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            toView.transform = CGAffineTransform(translationX: 0, y: yDiff)
        }

        // Animate the card's size
        let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
        sizeAnimator.addAnimations {
            // Animate the size of the Card View
            toView.frame.size = destinationFrame.size
            toView.layoutIfNeeded()

            // Move the view in the X direction. We concatenate here because we do not want to overwrite our
            // previous transformation
            toView.transform = toView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        // Call the animation delegate
        toVC.presentingView(
            sizeAnimator: sizeAnimator,
            positionAnimator: positionAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        // Animation completion.
        let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
            toView.transform = .identity
            toView.frame = originalFrame

            toView.layoutIfNeeded()

            fromChild.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        // Put the completion handler on the longest lasting animator
        if (self.positioningDuration > self.resizingDuration) {
            positionAnimator.addCompletion(completionHandler)
        } else {
            sizeAnimator.addCompletion(completionHandler)
        }

        // Kick off the two animations
        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
    }

    // Custom pop animations
    internal func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        // ===========================================================
        // Step 1: Get the views we are animating
        // ===========================================================

        // Views we are animating FROM
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromView = transitionContext.view(forKey: .from)
        else {
            return
        }

        // Views we are animating TO
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to),
            let toContainer = toVC.containerView,
            let toChild = toVC.childView
        else {
            return
        }

        container.addSubview(toView)
        container.addSubview(fromView)

        // ===========================================================
        // Step 2: Determine start and end points for animation
        // ===========================================================

        // Get the coordinates of the view inside the container
        let originFrame = fromView.frame
        let destinationFrame = CGRect(
            origin: toContainer.convert(toChild.frame.origin, to: container),
            size: toChild.frame.size
        )

        toChild.isHidden = true

        // ===========================================================
        // Step 3: Perform the animation
        // ===========================================================

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        // For the duration of the animation, we are moving the frame. Therefore we have a separate animator
        // to just control the Y positioning of the views. We will also use this animator to determine when
        // all of our animations are done.
        let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            fromView.transform = CGAffineTransform(translationX: 0, y: yDiff)
        }

        let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
        sizeAnimator.addAnimations {
            fromView.frame.size = destinationFrame.size
            fromView.layoutIfNeeded()

            // Move the view in the X direction. We concatinate here because we do not want to overwrite our
            // previous transformation
            fromView.transform = fromView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        // Call the animation delegate
        fromVC.dismissingView(
            sizeAnimator: sizeAnimator,
            positionAnimator: positionAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        // Animation completion.
        let completionHandler: (UIViewAnimatingPosition) -> Void = { _ in
            fromView.removeFromSuperview()
            toChild.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        // Put the completion handler on the longest lasting animator
        if (self.positioningDuration > self.resizingDuration) {
            positionAnimator.addCompletion(completionHandler)
        } else {
            sizeAnimator.addCompletion(completionHandler)
        }

        // Kick off the two animations
        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
    }
}

