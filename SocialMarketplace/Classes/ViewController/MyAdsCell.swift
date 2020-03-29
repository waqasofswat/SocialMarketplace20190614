
import UIKit

class MyAdsCell: UITableViewCell {
    @IBOutlet weak var thumnails: UIImageView!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var availbleLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var btnEdit: UIButton!

    override func awakeFromNib() {
        btnEdit.layer.cornerRadius = 4
        btnEdit.clipsToBounds = true
        btnEdit.layer.shadowColor = UIColor.black.cgColor
        btnEdit.layer.shadowOffset = CGSize(width: 3, height: 3)
        btnEdit.layer.shadowOpacity = 0.5
        btnEdit.backgroundColor = Helper.COLOR_PRIMARY_DEFAULT
        availbleLable.layer.masksToBounds = true
        feeLabel.layer.masksToBounds = true
        feeLabel.layer.cornerRadius = 10
        availbleLable.layer.cornerRadius = 10
        thumnails.layer.borderColor = UIColor.black.cgColor
        thumnails.layer.borderWidth = 0.5
        thumnails.contentMode = .scaleAspectFill
        thumnails.clipsToBounds = true
    }
}
