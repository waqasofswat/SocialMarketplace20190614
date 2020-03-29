
//
//  MySubscriptionTableViewCell.swift
//  Real Ads
//
//  Created by hieund@wirezy on 4/22/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class MySubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var descriptionScrollLabel: UILabel!
    @IBOutlet weak var fromScrollLabel: UILabel!
    @IBOutlet weak var reachScrollLabel: CBAutoScrollLabel!
    @IBOutlet weak var spentScrollLabel: CBAutoScrollLabel!

    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        imgCell.contentMode = .scaleAspectFill
        imgCell.clipsToBounds = true
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
        let color_Dack: UIColor? = UIColor.darkGray
        descriptionScrollLabel.textColor = UIColor.darkText
        if let aDack = color_Dack {
            fromScrollLabel.textColor = aDack
        }
        fromScrollLabel.font = UIFont.systemFont(ofSize: 14)
        reachScrollLabel.textColor = color_Dack
        reachScrollLabel.font = UIFont.systemFont(ofSize: 14)
        spentScrollLabel.textColor = color_Dack
        spentScrollLabel.font = UIFont.systemFont(ofSize: 14)
    }
}
