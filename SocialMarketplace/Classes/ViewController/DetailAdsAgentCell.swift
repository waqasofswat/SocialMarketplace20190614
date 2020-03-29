
//
//  DetailAdsAgentCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class DetailAdsAgentCell: UITableViewCell {
    @IBOutlet weak var thumnails: UIImageView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var agentTimeStaredLabel: UILabel!
    @IBOutlet weak var agentIndividualLabel: UILabel!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnAds: UIButton!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lbl_member: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumnails.contentMode = .scaleAspectFill
        thumnails.clipsToBounds = true
        viewCell.layer.cornerRadius = 6
        viewCell.layer.borderColor = UIColor.lightGray.cgColor
        viewCell.layer.borderWidth = 0.5
        btnAds.setTitle("dt_btn_ads".localized, for: .normal)
        btnContact.setTitle("dt_btn_chat".localized, for: .normal)
        lbl_member.text = "dt_lbl_menber_joined".localized
    }
}
