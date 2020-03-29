//
//  Detailsadscollectioncalling2.swift
//  SocialMarketplace
//
//  Created by Waqas on 26/03/2020.
//  Copyright © 2020 Logan CP. All rights reserved.
//

import UIKit

class Detailsadscollectioncalling2: UICollectionViewCell {

    @IBOutlet weak var imagecell: UIImageView!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    override func awakeFromNib() {
        // Initialization code
        imagecell.contentMode = .scaleAspectFill
        imagecell.clipsToBounds = true
    }

    
}
