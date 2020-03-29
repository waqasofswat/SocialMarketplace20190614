//
//  ChatTableViewCell.swift
//  SocialMarketplace
//
//  Created by Waqas on 26/03/2020.
//  Copyright © 2020 Logan CP. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var labeldateguest: UILabel!
    @IBOutlet weak var labeldatehost: UILabel!
    @IBOutlet weak var btnhost: UIButton!
    @IBOutlet weak var imghost: UIImageView!
    @IBOutlet weak var btnguest: UIButton!
    @IBOutlet weak var imgguest: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
