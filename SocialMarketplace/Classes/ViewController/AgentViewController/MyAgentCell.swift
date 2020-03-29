
//
//  MyAgentCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class MyAgentCell: UITableViewCell {
    @IBOutlet weak var thumnails: UIImageView!
    @IBOutlet weak var agentNameLabel: UILabel!
    @IBOutlet weak var agentDateLabel: UILabel!
    @IBOutlet weak var agentInfoLabel: UILabel!
    @IBOutlet weak var btnContact: DButtonAcviewDefault!
    @IBOutlet weak var btnAds: UIButton!
    var userObj: User?
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var lblMenberSince: UILabel!

    func configureCell(forSeller seller: User?) {
        agentNameLabel.text = seller?.usName!
        let _interval = TimeInterval((seller?.usDateCreated.doubleValue)!)
        let date = Date(timeIntervalSince1970: _interval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        agentDateLabel.text = formatter.string(from: date)
        if (seller?.usIndividual == "1") {
            agentInfoLabel.text = "text_individual".localized
        } else {
            agentInfoLabel.text = "text_company".localized
        }
    }

    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        thumnails.contentMode = .scaleAspectFill
        thumnails.clipsToBounds = true
        viewCell.layer.cornerRadius = 6
        viewCell.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        viewCell.clipsToBounds = true
        viewCell.layer.borderWidth = 0.5
        btnAds.layer.cornerRadius = 4
      self.btnAds.layer.borderColor = Helper.COLOR_BTN_SMALL.cgColor
      self.btnAds.layer.borderWidth = 1
        btnContact.setTitle("sl_btn_chat".localized, for: .normal)
        btnAds.setTitle("sl_btn_follow_cell".localized, for: .normal)
        btnAds.setTitle("sl_btn_followed_cell".localized, for: .selected)
        lblMenberSince.text = "sl_lbl_menber_since".localized
    }

    @IBAction func actionContact(_ sender: Any) {
    }

    @IBAction func actionAds(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
            return
        }
        let follow = btnAds.isSelected ? "0" : "1"
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.follow(withAgentId: self.userObj?.usId, type: follow, success: {(_ strStatus: String?) -> Void in
                //
            }, failure: {(_ err: String?) -> Void in
                //
            })
        })
        btnAds.isSelected = !btnAds.isSelected
        if btnAds.isSelected {
            self.userObj?.usIsFollow = true
            btnAds.backgroundColor = UIColor.white
        } else {
         self.userObj?.usIsFollow = false
            btnAds.backgroundColor = Helper.COLOR_BTN_SMALL
        }
    }
}
