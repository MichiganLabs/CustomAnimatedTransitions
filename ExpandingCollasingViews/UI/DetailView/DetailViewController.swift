import Foundation
import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var closeButton: UIButton!

    // Constraint from the top of the CommonView to the top of the MaskView
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    // Height constraint for the CommonView
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func asCard(_ value: Bool) {
        if value {
            // Round the corners
            self.maskView.layer.cornerRadius = 10
        } else {
            // Round the corners
            self.maskView.layer.cornerRadius = 0
        }
    }
}
