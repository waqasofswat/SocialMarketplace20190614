//
//  NewsTableViewCell2.swift
//  SocialMarketplace
//
//  Created by Waqas on 26/03/2020.
//  Copyright © 2020 Logan CP. All rights reserved.
//

import UIKit

class NewsTableViewCell2: UITableViewCell {
    @IBOutlet weak var lblSmall: UILabel!
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        // Initialization code
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        viewCell.layer.cornerRadius = 6
        //_ViewCell.layer.shadowColor = [[UIColor blackColor] CGColor];
        //_ViewCell.layer.shadowOffset = CGSizeMake(0, 1);
        //_ViewCell.layer.shadowOpacity = 0.5;
        viewCell.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        viewCell.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
