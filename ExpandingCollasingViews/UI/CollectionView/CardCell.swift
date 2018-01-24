import UIKit

class CardCell: UICollectionViewCell, NibReusable {

    @IBOutlet fileprivate weak var commonView: CommonView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Round the corners
        self.commonView.layer.cornerRadius = 10
        self.commonView.layer.masksToBounds = true
    }
}
