
//
//  AllSubCategoriesViewController.swift
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class AllSubCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var listSubCategories = [Any]()
    @IBOutlet weak var lblSubCate: UILabel!
    var strTitle: String?

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        self.view.backgroundColor = UIColor.white
        lblSubCate.text = strTitle
        let view = UIView(frame: CGRect.zero)
        tableView.tableFooterView = view
    }

    @IBAction func toggleMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listSubCategories.count == 0 {
            return 1
        } else {
            return listSubCategories.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CategoriesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? CategoriesCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CategoriesCell", owner: nil, options: nil)?[0] as? CategoriesCell
        }
       // cell?.imgRight.isHidden = true
        if listSubCategories.count == 0 {
            cell?.lbltitle.text = "sc_no_subcategories".localized
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else {
            let item = listSubCategories[indexPath.row] as? CategoryPr
            if let aName = item?.categoryName {
                cell?.lbltitle.text = "\(aName)"
            }
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listSubCategories.count == 0 {
            return
        }
        let cate = listSubCategories[indexPath.row] as? CategoryPr
        let userId = ((login_already == "1") || (login_already == "2")) ? gUser.usId : ""
        
         let param = ["userId": userId ?? "", "page": "1" as String, "sortBy": "" as String, "sortType": "" as String, "keyword": "" as String, "type": "" as String, "categoryId": Validator.getSafeString(cate?.categoryParentId) ?? "", "subCate": Validator.getSafeString(cate?.categoryId) ?? "", "city": "" as String, "individual": "" as String, "date": "" as String, "time_option": "" as String, "distance": "0" as String, "latitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0)" as String, "longitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0 )" as String] as [String: Any]
        
        let searchResultVC = SearchAdsResultVC()
        searchResultVC.paramDic = param
        searchResultVC.titleText = cate?.categoryName
        navigationController?.pushViewController(searchResultVC, animated: true)
    }
}
