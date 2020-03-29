
//
//  DetailAdsMainInfoCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class DetailAdsMainInfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var lblSubcat: UILabel!
    @IBOutlet weak var widthNavSub: NSLayoutConstraint!
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_posted: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_type.text = "dt_lbl_type".localized
        lbl_location.text = "dt_lbl_address".localized
        lbl_posted.text = "dt_lbl_poster".localized
    }
}
