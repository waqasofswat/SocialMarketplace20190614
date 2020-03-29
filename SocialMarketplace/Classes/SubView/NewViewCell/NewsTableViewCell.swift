
//
//  NewsTableViewCell.swift
//  Real Ads
//
//  Created by De Papier on 4/10/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageNew1: UIImageView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var lblPosted: UILabel!

    override func awakeFromNib() {
        // Initialization code
        imageNew1.contentMode = .scaleAspectFill
        imageNew1.clipsToBounds = true
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
