import Foundation
import UIKit

class CommonView: UIView, NibOwnerLoadable {

    @IBOutlet private var topConstraint: NSLayoutConstraint!
    var topConstraintValue: CGFloat {
        get { return self.topConstraint.constant }
        set { self.topConstraint.constant = newValue }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
}
