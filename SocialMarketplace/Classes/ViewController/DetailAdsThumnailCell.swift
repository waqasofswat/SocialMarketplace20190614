
//
//  DetailAdsThumnailCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class DetailAdsThumnailCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrPhoto = [Any]()
    @IBOutlet weak var lblNumberOfLikes: UILabel!
    @IBOutlet weak var lblNumberOfComments: UILabel!
    @IBOutlet weak var lblNumberOfFavourites: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgFavorite: UIImageView!
    let btnSelected = "1"
    let btnUnSelected = "2"
    var objAds: Ads?

    func setupData(with adsObj: Ads?) {
        objAds = adsObj
        if let numberLike = objAds?.likeCount {
            if numberLike > 1 {
            lblNumberOfLikes.text =  "\(numberLike as Int32)" + "dt_btn_likes".localized
            }else{
                lblNumberOfLikes.text =  "\(numberLike as Int32)" + "dt_btn_like".localized
            }
        }else{
            lblNumberOfLikes.text =  "0" + "dt_btn_like".localized
        }
        if let numberComment = objAds?.commentCount {
            if numberComment > 1 {
            lblNumberOfComments.text =  "\(numberComment as Int32)" + "dt_btn_comments".localized
            }else{
              lblNumberOfComments.text =  "\(numberComment as Int32)" + "dt_btn_comment".localized
            }
        }else{
          lblNumberOfComments.text =  "0" + "dt_btn_comment".localized
        }
        if let numberFavorite = objAds?.favouriteCount {
            if numberFavorite > 1 {
             lblNumberOfFavourites.text =  "\(numberFavorite as Int32)" + "dt_btn_favorites".localized
            }else{
             lblNumberOfFavourites.text =  "\(numberFavorite as Int32)" + "dt_btn_favorite".localized
            }
        }else{
            lblNumberOfFavourites.text =  "0" + "dt_btn_favorite".localized
        }
       
        
        btnLike.isSelected = adsObj?.isLiked ?? false
        btnFavorite.isSelected = adsObj?.isFavorite ?? false
        imgFavorite.image = adsObj?.isFavorite ?? false ? UIImage(named: "ic_favoriteSelected") : UIImage(named: "ic_favoriteUnselect.png")
    }

    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "Detailsadscollectioncalling2", bundle: nil), forCellWithReuseIdentifier: "DetailAdsCollectionCellImgcell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
        feeLabel.backgroundColor = Helper.COLOR_BTN_SMALL
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

// MARK: ==> Collectionview datasource and delegate
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhoto.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.height * 16 / 9, height: self.collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailAdsCollectionCellImgcell", for: indexPath) as? Detailsadscollectioncalling2
        if cell == nil {
            cell = Bundle.main.loadNibNamed("Detailsadscollectioncalling2", owner: self, options: nil)?[0] as? Detailsadscollectioncalling2
        }
        var imgObj = ImageObj()
        if let aRow = arrPhoto[indexPath.row] as? ImageObj {
            imgObj = aRow
        }
        cell?.imagecell.setImageWith(URL(string: imgObj.imgName), placeholderImage: Helper.IMAGE_HODER)
        if let aCell = cell {
            return aCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var objImg = ImageObj()
        if let aRow = arrPhoto[indexPath.row] as? ImageObj {
            objImg = aRow
        }
        thumbnail.setImageWith(URL(string: objImg.imgName), placeholderImage: Helper.IMAGE_HODER)
    }

    //
    @IBAction func onLike(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("msg_login_to_use".localized , withTitle: APP_NAME)
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
            if aCount > 1 {
            lblNumberOfLikes.text = "\(aCount) \("dt_btn_likes".localized)"
            }else{
            lblNumberOfLikes.text = "\(aCount) \("dt_btn_like".localized)"
            }
        }
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.changeLikeAdsId(self.objAds?.adsId, status: self.btnLike.isSelected ? self.btnSelected : self.btnUnSelected, withSuccess: {(_ strSuccess: String?) -> Void in
            }, failure: {(_ err: String?) -> Void in
            })
        })
    }

    @IBAction func onComment(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
            return
        }
        let userInfo = ["adsId": objAds?.adsId]
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name(kNotifiAdsDetailComment), object: nil, userInfo: userInfo)
    }

    @IBAction func onFavorite(_ sender: Any) {
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
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
            if aCount > 1 {
            lblNumberOfFavourites.text = "\(aCount) \("dt_btn_favorites".localized)"
            }else{
                lblNumberOfFavourites.text = "\(aCount) \("dt_btn_favorite".localized)"
            }
        }
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.bookmarkClick(withUserId: gUser.usId, adsId: self.objAds?.adsId, type: self.btnFavorite.isSelected ? self.btnSelected : self.btnUnSelected, withSuccess: {(_ strSuccess: String?) -> Void in
            }, failure: {(_ err: String?) -> Void in
            })
        })
    }
}
