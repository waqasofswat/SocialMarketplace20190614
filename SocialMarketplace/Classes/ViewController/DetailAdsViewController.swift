
//
//  DetailAdsViewController.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailAdsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @objc var objAds: Ads?
    @objc var adsId = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topNaviView: UIView!

    private var listPhotos = [ImageObj]()
    private var currentColor: UIColor?
    private var user: User?
    private var imgObj: ImageObj?
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
    }

    func getDetailObj() {
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        ModelManager.getAdsDetailbyId(adsId, withSuccess: {(_ adsDetail: Any?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.tableView, animated: true)
            self.objAds = adsDetail as? Ads
            
            self.listPhotos = [ImageObj]()
            self.imgObj = ImageObj()
            self.imgObj?.imgId = "0"
            self.imgObj?.imgName = self.objAds?.adsImage
            if let anObj = self.imgObj {
                self.listPhotos.append(anObj)
            }
            if let aGallery = self.objAds?.adsGallery {
                self.listPhotos.append(contentsOf: aGallery as! [ImageObj])
            }
            self.tableView.reloadData()
            self.getSellerDetail()
        }, failure: {(_ err: String?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.tableView, animated: true)
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
        })
    }

    func getSellerDetail() {
        MBProgressHUD.showAdded(to: tableView, animated: true)
        ModelManager.getSellerDetail(withId: objAds?.adsAccountId, withSuccess: {(_ successObj: Any?) -> Void in
            self.user = successObj as? User
            DispatchQueue.main.async(execute: {() -> Void in
                //   NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:1];
                
                self.tableView.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.tableView, animated: true)
            
            })
        }, failure: {(_ err: String?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.tableView, animated: true)
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
        })
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func initLayout() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        if adsId == "" {
            adsId = objAds?.adsId ?? ""
        }
        DispatchQueue.global(qos: .default).async(execute: {(_: Void) -> Void in
            ModelManager.increaseViewAdsCount(self.adsId, withSuccess: {(_ succ: String?) -> Void in
            }, failure: {(_ err: String?) -> Void in
                
            })
        })
        getDetailObj()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        topNaviView.backgroundColor = Helper.COLOR_DARK_PR_MARY
        var nib = UINib(nibName: "DetailAdsPhotoViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailAdsPhotoViewCell")
        nib = UINib(nibName: "DetailAdsThumnailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailAdsThumnailCell")
        nib = UINib(nibName: "BtnReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BtnReportTableViewCell")
        nib = UINib(nibName: "DetailAdsMainInfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailAdsMainInfoCell")
        nib = UINib(nibName: "DetailAdsInfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailAdsInfoCell")
        nib = UINib(nibName: "DetailAdsAgentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailAdsAgentCell")
        user = User()
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTest(_:)) , name: Notification.Name(kNotifiAdsDetailComment), object: nil)
    }

    func inCreaseViewAdsCount() {
        ModelManager.increaseViewAdsCount(objAds?.adsId, withSuccess: {(_ succ: String?) -> Void in
        }, failure: {(_ err: String?) -> Void in
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAdsThumnailCell") as? DetailAdsThumnailCell
            cell?.thumbnail.backgroundColor = currentColor
            cell?.thumbnail.setImageWith(URL(string: objAds?.adsImage ?? ""), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
            })
            cell?.arrPhoto = listPhotos
            cell?.thumbnail.setImageWith(URL(string: imgObj?.imgName ?? ""), placeholderImage: Helper.IMAGE_HODER)
    
            if (objAds?.adsPrice == "3") {
                if let anUnit = objAds?.adsPriceUnit {
                    cell?.feeLabel.text = "$\(Util.convertPriceString(objAds?.adsPriceValue) as String) /\(anUnit)"
                }
            }
            if (objAds?.adsPrice == "1") {
                cell?.feeLabel.text = "text_free".localized
            }
            if (objAds?.adsPrice == "2") {
                cell?.feeLabel.text = "text_negotiate".localized
            }
            if (objAds?.adsIsAvailable == "1") {
                cell?.lblAvailable.isHidden = true
            } else if (objAds?.adsIsAvailable == "0") {
                if (objAds?.adsForRent == "1") {
                    cell?.lblAvailable.text = "text_rented".localized
                } else if (objAds?.adsForSale == "1") {
                    cell?.lblAvailable.text = "text_sold".localized
                }
            }
            cell?.lblAvailable.transform = CGAffineTransform(rotationAngle: -.pi / 4)
            cell?.setupData(with: objAds)
            cell?.awakeFromNib()
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAdsMainInfoCell") as? DetailAdsMainInfoCell
            cell?.titleLabel.text = objAds?.adsTitle
            cell?.categoryLabel.text = objAds?.adsCategory
            cell?.lblSubcat.text = objAds?.adsSub
            if objAds?.adsSub.count == 0 {
                //            cell.widthNavSub.constant = 0;
            } else {
                //            cell.widthNavSub.constant = 9;
                cell?.categoryLabel.text = objAds?.adsSub
                cell?.lblSubcat.text = objAds?.adsCategory
            }
            if (objAds?.adsCategoryId == "0") {
                cell?.categoryLabel.text = "text_all_category".localized
            }
            if (objAds?.adsSubCatId == "0") {
                cell?.lblSubcat.text = "text_all_sub_category".localized
            }
            if (objAds?.adsForSale == "1") {
                cell?.typeLabel.text = "text_for_sale".localized
            } else {
                cell?.typeLabel.text = "text_for_rent".localized
            }
            cell?.locationLabel.text = objAds?.adsCity
             if let adsDateValue = objAds?.adsDateCreated, let adsDateDouble = Double(adsDateValue) {
            let _interval = TimeInterval(adsDateDouble)
            let date = Date(timeIntervalSince1970: _interval)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            cell?.postedLabel.text = formatter.string(from: date)
            }
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAdsInfoCell") as? DetailAdsInfoCell
            
//            var str: String? = nil
//            if let aDescription = objAds?.adsDescription {
//                str = "<div style=\"font-size: \(14); font-family: \("helvetica");color:#555555 \">\(aDescription)</div>"
//            }
//            var attrStr: NSAttributedString? = nil
//            if let anEncoding = str?.data(using: .unicode) {
//                attrStr = try? NSAttributedString(data: anEncoding, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//            }
            if let des = objAds?.adsDescription, des.count > 0 {
                cell?.detailLabel1.text = "\(objAds?.adsDescription ?? "") xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx xxxxxxx xxxxx xxxxxx xxxxxx xxxxxx"
            } else {
                cell?.detailLabel1.text = objAds?.adsDescription
            }
            
            cell?.tf_Description.text = objAds?.adsDescription
            
            if let adsLat = objAds?.adsLat, let adsLatDouble = Double(adsLat) , let adsLon = objAds?.adsLng, let adsLongDouble = Double(adsLon)  {
            cell?.setupMapview(with: GMSMarker(position: CLLocationCoordinate2DMake(adsLatDouble , adsLongDouble)))
            }
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAdsAgentCell") as? DetailAdsAgentCell
            if (objAds?.adsAccountType == "0") {
                cell?.agentIndividualLabel.text = "text_individual".localized
            } else {
                cell?.agentIndividualLabel.text = "text_company".localized
            }
            cell?.agentNameLabel.text = user?.usName
            if user != nil {
                cell?.thumnails.setImageWith(URL(string: user?.usImage ?? ""), placeholderImage: Helper.IMAGE_HODER)
            } else {
                cell?.thumnails.backgroundColor = UIColor.lightGray
            }
            if let userDateValue = user?.usDateCreated, let userDateDouble = Double(userDateValue) {
            let _interval = TimeInterval(userDateDouble)
            let date = Date(timeIntervalSince1970: _interval)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            cell?.agentTimeStaredLabel.text = formatter.string(from: date)
            }
            cell?.btnContact.addTarget(self, action: #selector(self.onContact), for: .touchUpInside)
            cell?.btnAds.addTarget(self, action: #selector(self.onAds), for: .touchUpInside)
            if let userGlobal = gUser, (userGlobal.usId == user?.usId) {
                cell?.btnContact.isHidden =  true
            }else{
                 cell?.btnContact.isHidden = false
            }
           
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BtnReportTableViewCell") as? BtnReportTableViewCell
            cell?.btnReport.addTarget(self, action: #selector(self.onReport), for: .touchUpInside)
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    @objc func onReport() {
        let contacVC = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        contacVC.strTitle = CONTACT_REPORT_ADS
        //contacVC.strContent = [NSString stringWithFormat:@"%@%@%@%@",@"Ads ID : ",_objAds.adsId,@", name: ",_objAds.adsTitle];
        if let anId = user?.usId, let aName = user?.usName {
            contacVC.strContent = "\("dt_txt_seller_id".localized)\(" : ")\(anId)\(", \("dt_text_name".localized): ")\(aName)"
        }
        navigationController?.pushViewController(contacVC, animated: true)
    }

    @objc func onAds() {
        let allAdsVC = AllAdsViewController(nibName: "AllAdsViewController", bundle: nil)
        allAdsVC.sellerId = (objAds?.adsAccountId)!
        if let aName = objAds?.adsAccountName {
            allAdsVC.stringTitle = "\(aName) \("dt_text_ads".localized)"
        }
        navigationController?.pushViewController(allAdsVC, animated: true)
    }

    @objc func onContact() {
        //    ContactViewController *contactVC = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
        //    contactVC.adsId = _objAds.adsId;
        //    if (user) {
        //        contactVC.seller = user;
        //    }else{
        //        contactVC.sellerId = _objAds.adsAccountId;
        //    }
        //    [self.navigationController pushViewController:contactVC animated:YES];
        
        //now is onChat
        
        if (login_already == "1") || (login_already == "2") {
                //        User *objSeller = arrNews[[sender tag]];
            let contactVC = ChatVC(nibName: "ChatVC", bundle: nil)
            contactVC.seller = user
            navigationController?.pushViewController(contactVC, animated: true)
        } else {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        //    if (![login_already isEqualToString:@"0"]) {
        //    NSString *type =@"";
        //    if (_btnFavourite.selected) {
        //        type =@"1";
        //    }else{
        //    type =@"2";
        //    }
        //        [ModelManager bookmarkClickWithUserId:gUser.usId adsId:_objAds.adsId type:type withSuccess:^(NSString *strSuccess) {
        //    
        //        } failure:^(NSString *err) {
        //    
        //        }];
        //    }
    }

    @objc func receiveTest(_ notification: Notification?) {
        if ((notification?.name)!.rawValue == kNotifiAdsDetailComment) {
            
            guard let userInfo = notification?.userInfo else {
                return
            }
            let adsId = Validator.getSafeString(userInfo["adsId"])
            let commentVC = CommentVC(nibName: "CommentVC", bundle: nil)
            commentVC.adsId = adsId
            navigationController?.pushViewController(commentVC, animated: true)
        }
    }

    func text() {
        lblTitle.text = "dt_title".localized
    }
}
