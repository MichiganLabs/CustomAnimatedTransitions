import UIKit

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowOpacity = 0.25
        self.layer.masksToBounds = false
    }
}
