
//
//  MyAdsCellEdit.swift
//  Real Ads
//
//  Created by Hicom Solutions on 1/24/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class MyAdsCellEdit: UITableViewCell {
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet var uvConten: UIView!
    @IBOutlet var lblTitle: CBAutoScrollLabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblRentOrSale: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblPosted: UILabel!
    @IBOutlet var lblAvaiable: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var imageAds: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusValue: UILabel!
    @IBOutlet weak var isFeatured: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblPrice.backgroundColor = Helper.COLOR_BTN_SMALL
        imageAds.contentMode = .scaleAspectFill
        imageAds.clipsToBounds = true
        imgBackGround.layer.cornerRadius = 6
        imgBackGround.clipsToBounds = true
        //self.imgBackGround.layer.shadowColor = [UIColor clearColor].CGColor;
        //self.imgBackGround.layer.borderColor = [UIColor blackColor].CGColor;;
        //self.imgBackGround.layer.borderWidth = 0.5;
        //    self.imgBackGround.layer.shadowOffset = CGSizeMake(0 ,1);
        //    self.imgBackGround.layer.shadowOpacity = 0.5;
        lblTitle.font = UIFont(name: "OpenSans-Semibold", size: 18)
        uvConten.layer.cornerRadius = 6
        uvConten.clipsToBounds = true
        uvConten.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        uvConten.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
