import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimation(operation: operation, positioningDuration: 1, resizingDuration: 0.5)
    }
}
