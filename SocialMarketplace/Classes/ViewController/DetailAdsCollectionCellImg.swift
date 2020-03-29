
//
//  DetailAdsCollectionCellImg.swift
//  Real Estate
//
//  Created by Hicom on 3/21/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class DetailAdsCollectionCellImg: UICollectionViewCell {
    @IBOutlet weak var imgInCell: UIImageView!

    override func awakeFromNib() {
        // Initialization code
        imgInCell.contentMode = .scaleAspectFill
        imgInCell.clipsToBounds = true
    }
}
