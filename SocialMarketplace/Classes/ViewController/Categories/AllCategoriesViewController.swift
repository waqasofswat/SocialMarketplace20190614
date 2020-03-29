
//
//  AllCategoriesViewController.swift
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//
import GoogleMobileAds

import UIKit

class AllCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var tableView: UITableView!

    private var listCategories = [Any]()
    private var arrParent = [Any]()
    private var arrsubCate = [Any]()
   
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   var bannerView: GADBannerView!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        lblTitle.text = "ac_title".localized
        self.view.backgroundColor = UIColor.white
        let view = UIView(frame: CGRect.zero)
        tableView.tableFooterView = view
        listCategories = [Any]()
        arrsubCate = [Any]()
        arrParent = [Any]()
        let cateOne = CategoryPr()
        cateOne.categoryId = "0"
        cateOne.categoryName = "text_all_category".localized
        cateOne.categoryParentId = "0"
        arrParent.append(cateOne)
        indicator.startAnimating()
        initData()
            // In this case, we instantiate the banner with desired ad size.
                 bannerView = GADBannerView(adSize: kGADAdSizeBanner)

               bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                        bannerView.rootViewController = self
               bannerView.load(GADRequest())
        addBannerViewToView(bannerView)

           }
           func addBannerViewToView(_ bannerView: GADBannerView) {
              bannerView.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(bannerView)
              view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
             }
           
    func initData() {
        ModelManager.getListCategory(success: {(_ arrCategory: [Any]?) -> Void in
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            if let aCategory = arrCategory {
                self.listCategories = aCategory
            }
            for cateObj in (self.listCategories as? [CategoryPr])! {
                if (Validator.getSafeString(cateObj.categoryParentId) == "0") {
                    self.arrParent.append(cateObj)
                }
            }
            self.tableView.reloadData()
        }, failure: {(_ err: String?) -> Void in
            
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
        
        })
    }

    @IBAction func toggleMenu(_ sender: Any) {
        revealViewController().revealToggle(sender)
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrParent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CategoriesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? CategoriesCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CategoriesCell", owner: nil, options: nil)?[0] as? CategoriesCell
        }
        let item = arrParent[indexPath.row] as? CategoryPr
        if let aName = item?.categoryName {
            cell?.lbltitle.text = "\(aName)"
        }
        if arrParent.count == 1 {
            cell?.lbltitle.text = "text_no_available_category".localized
        }
        arrsubCate.removeAll()
        for cate in (listCategories as? [CategoryPr])! {
            if (Validator.getSafeString(cate.categoryParentId) == item?.categoryId) {
                arrsubCate.append(cate)
            }
        }
        if arrsubCate.count > 0 {
            if indexPath.row == 0 {
              // cell?.imgRight.isHidden = true
            } else {
              //  cell?.imgRight.isHidden = false
            }
        } else {
           // cell?.imgRight.isHidden = true
        }
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let userId = ((login_already == "1") || (login_already == "2")) ? gUser.usId : ""
            let param = ["userId": userId ?? "", "page": "1" as String, "sortBy": "" as String, "sortType": "" as String, "keyword": "" as String, "type": "" as String, "categoryId": "" as String, "subCate": "" as String, "city": "" as String, "individual": "" as String, "date": "" as String, "time_option": "" as String, "distance": "0" as String, "latitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0)" as String, "longitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0 )" as String] as [String: Any]

            let searchResultVC = SearchAdsResultVC()
            searchResultVC.paramDic = param

            searchResultVC.titleText = "ac_text_all_ads".localized
            navigationController?.pushViewController(searchResultVC, animated: true)
            return
        }
        let cateObj = arrParent[indexPath.row] as? CategoryPr
        let idParentSub = Validator.getSafeString(cateObj?.categoryId)
        arrsubCate.removeAll()
        for cate in (listCategories as? [CategoryPr])! {
            if (Validator.getSafeString(cate.categoryParentId) == idParentSub) {
                arrsubCate.append(cate)
            }
        }
        if arrsubCate.count == 0 {
            let userId = ((login_already == "1") || (login_already == "2")) ? gUser.usId : ""
            let param = ["userId": userId ?? "", "page": "1" as String, "sortBy": "" as String, "sortType": "" as String, "keyword": "" as String, "type": "" as String, "categoryId": idParentSub ?? "", "subCate": "" as String, "city": "" as String, "individual": "" as String, "date": "" as String, "time_option": "" as String, "distance": "0" as String, "latitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0)" as String, "longitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0 )" as String] as [String: Any]
            let searchResultVC = SearchAdsResultVC()
            searchResultVC.paramDic = param
            
            searchResultVC.titleText = cateObj?.categoryName
            navigationController?.pushViewController(searchResultVC, animated: true)
            return
        }
        let controller = AllSubCategoriesViewController(nibName: "AllSubCategoriesViewController", bundle: nil)
        controller.listSubCategories = arrsubCate
        let item = arrParent[indexPath.row] as? CategoryPr
        if let aName = item?.categoryName {
            controller.strTitle = "\(aName)"
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
