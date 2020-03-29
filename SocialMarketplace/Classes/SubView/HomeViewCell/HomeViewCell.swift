
//
//  HomeViewCell.swift
//  Real Ads
//
//  Created by Hicom Solutions on 1/24/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit
import DateToolsSwift

let kNotiOnComment = "NOTI_ON_COMMENT"
class HomeViewCell: UITableViewCell {
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet var uvConten: UIView!
    @IBOutlet var lblTitle: CBAutoScrollLabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblRentOrSale: UILabel!
    @IBOutlet var lblAvaiable: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var imageAds: UIImageView!
    @IBOutlet weak var isFeatured: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    @IBOutlet weak var lblNumberOfComments: UILabel!
    @IBOutlet weak var lblNumberOfFavourites: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var widthNavSub: NSLayoutConstraint!
    var objAds: Ads?

    @objc public func setupData(with adsObj: Ads?) {
        objAds = adsObj
        lblTitle.text = adsObj?.adsTitle
        
        imageAds.setImageWith(URL(string: adsObj?.adsImage ?? ""), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
        })
//        imageAds.kf.setImage(with: (URL(string: adsObj!.adsImage)))

        //    if([_objAds.adsSub length] == 0){
        //        _widthNavSub.constant = 0;
        //    }else{
        //        _widthNavSub.constant = 9;
        //    }
        if (adsObj?.adsPrice == "3") {
            if let anUnit = adsObj?.adsPriceUnit {
                lblPrice.text = "$\(Util.convertPriceString(adsObj?.adsPriceValue) as String) /\(anUnit)"
            }
        }
        if (adsObj?.adsPrice == "1") {
            lblPrice.text = "Free"
        }
        if (adsObj?.adsPrice == "2") {
            lblPrice.text = "Negotiate"
        }
        lblAvaiable.isHidden = false
        lblAvaiable.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        if (adsObj?.adsIsAvailable == "1") {
            lblAvaiable.isHidden = true
        } else if (adsObj?.adsIsAvailable == "0") {
            if (adsObj?.adsForRent == "1") {
                lblAvaiable.text = "RENTED"
            } else if (adsObj?.adsForSale == "1") {
                lblAvaiable.text = "SOLD"
            }
        }
        imageAds.contentMode = .scaleAspectFill
        imageAds.clipsToBounds = true
        if (adsObj?.adsForRent == "1") {
            lblRentOrSale.text = "For rent"
        }
        if (adsObj?.adsForSale == "1") {
            lblRentOrSale.text = "For sale"
        }
        if adsObj?.adsCategory != nil {
            lblCategory.text = adsObj?.adsCategory
        } else {
            lblCategory.text = "All Categories"
        }
        if adsObj?.adsSub != nil {
            lblSubCat.text = adsObj?.adsSub
        } else {
            lblSubCat.text = "All Sub Categories"
        }
        if adsObj?.adsSub.count == 0 {
            lblSubCat.text = adsObj?.adsSub
            lblCategory.text = adsObj?.adsCategory
        }
        imgAvatar.setImageWith(URL(string: adsObj?.adsImgAvatar ?? ""), placeholderImage: UIImage(named: "avatar_default-1.png"))
        lblUserName.text = adsObj?.adsAccountName
        if adsObj?.likeCount == 1 {
            if let aCount = adsObj?.likeCount {
                lblNumberOfLikes.text = "\(aCount) Like"
            }
        } else {
            if let aCount = adsObj?.likeCount {
                lblNumberOfLikes.text = "\(aCount) Likes"
            }
        }
        if adsObj?.commentCount == 1 {
            if let aCount = adsObj?.commentCount {
                lblNumberOfComments.text = "\(aCount) Comment"
            }
        } else {
            if let aCount = adsObj?.commentCount {
                lblNumberOfComments.text = "\(aCount) Comments"
            }
        }
        if adsObj?.favouriteCount == 1 {
            if let aCount = adsObj?.favouriteCount {
                lblNumberOfFavourites.text = "\(aCount) Favorite"
            }
        } else {
            if let aCount = adsObj?.favouriteCount {
                lblNumberOfFavourites.text = "\(aCount) Favorites"
            }
        }
        if let adsDateValue = adsObj?.adsDateCreated, let adsDateDouble = Double(adsDateValue) {
            var timeStr = Date(timeIntervalSince1970: TimeInterval(adsDateDouble)).timeAgoSinceNow
            let date = Date(timeIntervalSince1970: TimeInterval(adsDateDouble))
            let gregorian = Calendar.current
            var dateComponents: DateComponents? = gregorian.dateComponents([.day,.month,.year], from: date, to: Date())
            let totalMonths: Int? = dateComponents?.month
            if (totalMonths ?? 0) > 1 {
                let _interval = TimeInterval(adsDateDouble)
                let date = Date(timeIntervalSince1970: _interval)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy"
                timeStr = formatter.string(from: date)
            }
            if let aCity = adsObj?.adsCity != nil ? adsObj?.adsCity : "All Cities" {
                lblLocation.text = "\(timeStr), \(aCity)"
            }
        }
        
        
        
        btnLike.isSelected = adsObj?.isLiked ?? false
        btnFavorite.isSelected = adsObj?.isFavorite ?? false
        imgFavorite.image = (adsObj?.isFavorite)! ? UIImage(named: "ic_favoriteSelected") : UIImage(named: "ic_favoriteUnselect.png")
        selectionStyle = .none
        if (adsObj?.adsIsFeatured == "1") {
            isFeatured.isHidden = false
        } else {
            isFeatured.isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblPrice.backgroundColor = Helper.COLOR_BTN_SMALL
        imageAds.contentMode = .scaleAspectFill
        imageAds.clipsToBounds = true
        imgBackGround.layer.cornerRadius = 6
        imgBackGround.clipsToBounds = true
        lblTitle.font = UIFont(name: "OpenSans-Semibold", size: 18)
        uvConten.layer.cornerRadius = 6
        uvConten.clipsToBounds = true
        uvConten.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        uvConten.layer.borderWidth = 0.5
        imgAvatar.layer.cornerRadius = 19.5
        imgAvatar.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func onLike(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("Please login to use this function!", withTitle: APP_NAME)
            return
        }
        btnLike.isSelected = !btnLike.isSelected
        objAds?.isLiked = btnLike.isSelected
        if btnLike.isSelected {
            objAds?.likeCount += 1
        } else {
            objAds?.likeCount -= 1
        }
        if let aCount = objAds?.likeCount {
            lblNumberOfLikes.text = "\(aCount) Likes"
        }
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.changeLikeAdsId(self.objAds?.adsId, status: self.btnLike.isSelected ? btnSelected : btnUnSelected, withSuccess: {(_ strSuccess: String?) -> Void in
            }, failure: {(_ err: String?) -> Void in
            })
        })
    }

    @IBAction func onComment(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("Please login to use this function!", withTitle: APP_NAME)
            return
        }
        let userInfo = ["adsId": objAds?.adsId]
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(kNotiOnComment), object: nil, userInfo: userInfo)
    }

    @IBAction func onFavorite(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("Please login to use this function!", withTitle: APP_NAME)
            return
        }
        btnFavorite.isSelected = !btnFavorite.isSelected
        imgFavorite.image = btnFavorite.isSelected ? UIImage(named: "ic_favoriteSelected") : UIImage(named: "ic_favoriteUnselect.png")
        objAds?.isFavorite = btnFavorite.isSelected
        if btnFavorite.isSelected {
            objAds?.favouriteCount += 1
        } else {
            objAds?.favouriteCount -= 1
        }
        if let aCount = objAds?.favouriteCount {
            lblNumberOfFavourites.text = "\(aCount) Favorites"
        }
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.bookmarkClick(withUserId: gUser.usId, adsId: self.objAds?.adsId, type: self.btnFavorite.isSelected ? btnSelected : btnUnSelected, withSuccess: { (strSuccess) in
                //
            }, failure: { (err) in
                //
            })
//            ModelManager.bookmarkClick(withUserId: gUser.usId, adsId: self.objAds?.adsId, type: self.btnFavorite.isSelected ? btnSelected : btnUnSelected, withSuccess: {(_ strSuccess: String?) -> Void in
//
//            }, failure: {(_ err: String?) -> Void in
//            })
        })
    }
}

let btnSelected = "1"
let btnUnSelected = "2"
