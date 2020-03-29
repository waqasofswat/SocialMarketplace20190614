
//
//  ManagePropertionTableViewCell.swift
//  Real Ads
//
//  Created by hieund@wirezy on 4/22/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class ManagePropertionTableViewCell: UITableViewCell {
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imageVi: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var descriptionScrollLabel: UILabel!
    @IBOutlet weak var detailScrollLabel: CBAutoScrollLabel!
    @IBOutlet weak var addressScrollLabel: UILabel!
    @IBOutlet weak var expiredScrollLabel: UILabel!
    @IBOutlet weak var imgBookMark: UIImageView!

    override func awakeFromNib() {
        imageVi.contentMode = .scaleAspectFill
        imageVi.clipsToBounds = true
        // Initialization code
        viewCell.layer.cornerRadius = 6
        viewCell.clipsToBounds = true
        viewCell.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        viewCell.layer.borderWidth = 0.5
        layoutView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func layoutView() {
    }
}
