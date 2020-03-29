
//
//  AllAgentViewController.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import DateToolsSwift
import UIKit

class AllAgentViewController: UIViewController, SortViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTblView: UIView!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet weak var segmentSellerContact: UISegmentedControl!
    @IBOutlet weak var btnSort: UIButton!

    @IBOutlet weak var topNaviView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFatherSearch: UIView!
    @IBOutlet weak var constraintViewFatherSearch: NSLayoutConstraint!
    var numberPage = ""
    @IBOutlet weak var lbl_s: UITextField!

    private var searchText = ""
    private var arrNews = [User]()
    private var arrRecentMess = [Any]()
    private var allPage: Int = 0
    private var currentPage: Int = 0
    private var isLoading = false
    private var sortType = ""
    private var sortBy = ""
    private var arrSortType = [Any]()
    private var arrSortRecentMassage = [Any]()

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        text()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        viewSearch.clipsToBounds = true
        viewSearch.layer.cornerRadius = 6
        viewSearch.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        viewSearch.layer.borderWidth = 0.5
        setupPullToRefresh()
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_verified_first".localized, "sort_by_un_verified_first".localized, "sort_by_number_asc".localized, "sort_by_number_desc".localized, "sort_by_individual_first".localized, "sort_by_company_first".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
        searchTextField.delegate = self
        topNaviView.backgroundColor = Helper.COLOR_DARK_PR_MARY
        tableView.register(UINib(nibName: "RecentContactTbCell2", bundle: nil), forCellReuseIdentifier: "RecentContactTbCell2")
        var nib = UINib(nibName: "MyAgentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyAgentCell")
        nib = UINib(nibName: "MyNothingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyNothingTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //  [_indicator startAnimating];
        indicator.isHidden = true
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AllAgentViewController.onSearch(_:)), userInfo: nil, repeats: false)
        //    [self getListRecentMessage];
    }
   
   
   override func viewWillAppear(_ animated: Bool) {
      if GlobalVar.shareInstance.gSeller != nil {
         for (index, element) in self.arrNews.enumerated() {
            if element.usId == GlobalVar.shareInstance.gSeller?.usId{
               self.arrNews[index].usIsFollow = GlobalVar.shareInstance.gSeller?.usIsFollow ?? false
               GlobalVar.shareInstance.gSeller = nil
               self.tableView.reloadData()
            }
         }

      }
   }

    func setupPullToRefresh() {
        currentPage = 1
        allPage = 1
        sortBy = "0"
        sortType = "0"
        isLoading = false
        topNaviView.backgroundColor = Helper.COLOR_DARK_PR_MARY
        topRefreshTable = UIRefreshControl()
        topRefreshTable?.attributedTitle = NSAttributedString(string: "table_top_refresh".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT] )
        topRefreshTable?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        topRefreshTable?.addTarget(self, action: #selector(self.onRefreshData), for: .valueChanged)
        if let aTable = topRefreshTable {
            tableView.addSubview(aTable)
        }
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "table_bot_loadmore".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT])
        // refreshControl.triggerVerticalOffset = 60;
        refreshControl.addTarget(self, action: #selector(self.onLoadmore), for: .valueChanged)
        refreshControl.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        tableView.bottomRefreshControl = refreshControl
    }

    @objc func onRefreshData() {
        if isLoading {
            return
        } else {
            currentPage = 1
        }
        isLoading = true
        if segmentSellerContact.selectedSegmentIndex == 1 {
            getDataFollowed()
        } else {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
        }
    }

    @objc func onLoadmore() {
        if isLoading {
            return
        } else {
            isLoading = true
        }
        if currentPage == allPage {
            view.makeToast("msg_no_more_seller".localized, duration: 2.0, position: CSToastPositionCenter)
            finishLoading()
            return
        }
        currentPage += 1
        if segmentSellerContact.selectedSegmentIndex == 1 {
            getDataFollowed()
        } else {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
        }
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        indicator.stopAnimating()
        indicator.isHidden = true
        isLoading = false
    }

// MARK: - Handle action
    @IBAction func actionSort(_ sender: Any) {
        let sortVC = SortViewController(nibName: "SortViewController", bundle: nil)
        sortVC.delegate = self
        sortVC.arrDataSource = arrSortType
        sortVC.present(inParentViewController: self)
    }

    @IBAction func actionLeftMenu(_ sender: Any) {
        revealViewController().revealToggle(sender)
    }

    @IBAction func onSearch(_ sender: Any) {
        searchTextField.resignFirstResponder()
        currentPage = 1
        if segmentSellerContact.selectedSegmentIndex == 1 {
            getDataFollowed()
        } else {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
        }
    }

    func getDataFollowed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ModelManager.getListSellerFollowed(withPage: "\(currentPage)", sortType: sortType, sortBy: sortBy, searchKey: searchTextField.text, withSuccess: {(_ dicReturn: Any?) -> Void in
            if self.currentPage == 1 {
                self.arrNews.removeAll()
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                if let dicReturn = dicReturn as? [String: Any] {
                if let aReturn = dicReturn["arrAcc"] as? [User] {
                    self.arrNews.append(contentsOf: aReturn)
                }
                    self.allPage = Int(dicReturn["allpage"] as! Int)
                self.finishLoading()
                self.tableView.reloadData()
                }
            })
        
        }, failure: {(_ error: String?) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
                self.view.makeToast(error, duration: 2.0, position: CSToastPositionCenter)
            })
        
        })
    }

    @objc func getData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ModelManager.getListSeller(withPage: "\(currentPage)", sortType: sortType, sortBy: sortBy, searchKey: searchTextField.text, withSuccess: {(_ dicReturn: Any?) -> Void in
            if self.currentPage == 1 {
                self.arrNews.removeAll()
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                if let dicReturn = dicReturn as? [String: Any] {
                if let aReturn = dicReturn["arrAcc"] as? [User] {
                    self.arrNews.append(contentsOf: aReturn)
                }
                self.allPage = Int(dicReturn["allpage"] as! Int)
                self.finishLoading()
                self.tableView.reloadData()
                }
            })
        
        }, failure: {(_ error: String?) -> Void in
            
            if self.currentPage == 1 {
                self.arrNews.removeAll()
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
                self.tableView.reloadData()
                self.view.makeToast(error, duration: 2.0, position: CSToastPositionCenter)
            })
        
        })
    }

// MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrNews.count == 0 {
            return 44
        } else {
            return 130
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrNews.count == 0 {
            return 1
        } else {
            return arrNews.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrNews.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyNothingTableViewCell") as? MyNothingTableViewCell
         //   cell?.lblTitle.text = "sl_text_no_seller".localized
            cell?.backgroundColor = UIColor.clear
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAgentCell") as? MyAgentCell
            cell?.selectionStyle = .none
            let userObj = arrNews[indexPath.row]
            cell?.configureCell(forSeller: userObj)
            cell?.thumnails.setImageWith(URL(string: userObj.usImage ?? ""), placeholderImage: Helper.IMAGE_HODER)
            cell?.btnContact.tag = indexPath.row
            cell?.btnContact.addTarget(self, action: #selector(AllAgentViewController.onContact(_:)), for: .touchUpInside)
            cell?.btnAds.tag = indexPath.row
            cell?.btnAds.addTarget(self, action: #selector(AllAgentViewController.onAds(_:)), for: .touchUpInside)
            cell?.backgroundColor = UIColor.clear
            cell?.userObj = userObj
            if userObj.usIsFollow {
                cell?.btnAds.isSelected = true
                cell?.btnAds.backgroundColor = UIColor.white
                cell?.btnAds.layer.borderColor = Helper.COLOR_BTN_SMALL.cgColor
                cell?.btnAds.layer.borderWidth = 1
            } else {
                cell?.btnAds.isSelected = false
                cell?.btnAds.backgroundColor = Helper.COLOR_BTN_SMALL
            }
            if (userObj.usIsverified == "1") {
                cell?.imgVerified.isHidden = false
            } else {
                cell?.imgVerified.isHidden = true
            }
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrNews.count < 1 {
            return
        }
        let objSeller = arrNews[indexPath.row]
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
            return
        }
        let allAdsVC = ProfileAgentViewController(nibName: "ProfileAgentViewController", bundle: nil)
        allAdsVC.sellerId = objSeller.usId
        allAdsVC.seller = objSeller
        allAdsVC.stringTitle = "sl_text_profile".localized
        navigationController?.pushViewController(allAdsVC, animated: true)
    }

    @IBAction func onContact(_ sender: Any) {
        //now is onChat
        if (login_already == "1") || (login_already == "2") {
            let objSeller = arrNews[(sender as AnyObject).tag]
            let contactVC = ChatVC(nibName: "ChatVC", bundle: nil)
            contactVC.seller = objSeller
            navigationController?.pushViewController(contactVC, animated: true)
        } else {
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
        }
    }

    @IBAction func onAds(_ sender: Any) {
        //NOW IS favorite
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        onSearch(UIButton())
        return true
    }

    func sortViewDidSelectedItem(at rowSelected: Int32) {
        switch rowSelected {
            case 0:
                sortBy = SORT_BY_NAME
                sortType = SORT_TYPE_ASC
            case 1:
                sortBy = SORT_BY_NAME
                sortType = SORT_TYPE_DESC
            case 2:
                sortBy = SORT_BY_REGISTERED_DATE
                sortType = SORT_TYPE_ASC
            case 3:
                sortBy = SORT_BY_REGISTERED_DATE
                sortType = SORT_TYPE_DESC
            case 4:
                sortBy = SORT_BY_VERIFIED
                sortType = SORT_TYPE_ASC
            case 5:
                sortBy = SORT_BY_VERIFIED
                sortType = SORT_TYPE_DESC
            case 6:
                sortBy = SORT_BY_NUMBER_OF_ADS
                sortType = SORT_TYPE_ASC
            case 7:
                sortBy = SORT_BY_NUMBER_OF_ADS
                sortType = SORT_TYPE_DESC
            case 8:
                sortBy = SORT_BY_INDIVIDUAL
                sortType = SORT_TYPE_NORMAL
            case 9:
                sortBy = SORT_BY_COMPANY
                sortType = SORT_TYPE_NORMAL
            default:
                break
        }
        currentPage = 1
        isLoading = true
        if segmentSellerContact.selectedSegmentIndex == 1 {
            getDataFollowed()
        } else {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
        }
        indicator.startAnimating()
        indicator.isHidden = false
    }

    @IBAction func sementSellerContactChange(_ sender: Any) {
        if (login_already == "1") || (login_already == "2") {
            if segmentSellerContact.selectedSegmentIndex == 1 {
                onRefreshData()
            } else {
                getData()
            }
        } else {
            segmentSellerContact.selectedSegmentIndex = 0
            Util.showMessage("msg_login_to_use".localized, withTitle: APP_NAME)
        }
    }

    func text() {
        segmentSellerContact.setTitle( "sl_btn_seller".localized, forSegmentAt: 0)
        segmentSellerContact.setTitle( "sl_btn_follow".localized, forSegmentAt: 1)
        searchTextField.placeholder = "sl_tf_search".localized
    }
}
