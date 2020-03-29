
//
//  NewsViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/10/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SortViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var revealBtn: UIButton!
    var numPage = ""
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet var viewSearch: UIView!
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var viewTblView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lbl_new: UILabel!
    @IBOutlet weak var imgNaviBg: UIImageView!
    
    private var arrNews = [News]()
    private var allPage: Int = 0
    private var currentPage: Int = 0
    private var isLoading = false
    private var sortType = ""
    private var sortBy = ""
    private var arrSortType = [Any]()
   
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
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        setRevealBtn()
        setupPullToRefresh()
        initSortFunction()
        indicator.isHidden = true
        indicator.startAnimating()
        viewSearch.clipsToBounds = true
        viewSearch.layer.cornerRadius = 6
        viewSearch.layer.borderColor = Helper.COLOR_DEVIDER.cgColor
        viewSearch.layer.borderWidth = 0.5
        //_viewSearch.layer.shadowColor = [[UIColor blackColor] CGColor];
        //_viewSearch.layer.shadowOffset = CGSizeMake(0, 2);
        //_viewSearch.layer.shadowOpacity = 0.5;
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.onSearch(_:)), userInfo: nil, repeats: false)
    }
    
    func initSortFunction() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
    }
    
    @IBAction func onSort(_ sender: Any) {
        let sortVC = SortViewController(nibName: "SortViewController", bundle: nil)
        sortVC.delegate = self
        sortVC.arrDataSource = arrSortType
        sortVC.present(inParentViewController: self)
    }
    
    func setupPullToRefresh() {
        currentPage = 1
        allPage = 1
        sortType = "0"
        sortBy = sortType
        isLoading = false
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
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
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.onSearch(_:)), userInfo: nil, repeats: false)
    }
    
    @objc func onLoadmore() {
        if isLoading {
            return
        } else {
            isLoading = true
        }
        if currentPage == allPage {
            view.makeToast("msg_loadmore".localized, duration: 2.0, position: CSToastPositionCenter)
            finishLoading()
            return
        }
        currentPage += 1
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.onSearch(_:)), userInfo: nil, repeats: false)
    }
    
    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }
    
    //Table News
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNews.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell2") as? NewsTableViewCell2
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NewsTableViewCell2", owner: nil, options: nil)?[0] as? NewsTableViewCell2
        }
        let n = arrNews[indexPath.row]
        cell?.lblDesc.text = n.newsTitle
        cell?.img.setImageWith(URL(string: n.newsImage!), placeholderImage: Helper.IMAGE_HODER)
        cell?.img.clipsToBounds = true
        let _interval = TimeInterval((n.newsDateCreated?.doubleValue)!)
        let date = Date(timeIntervalSince1970: _interval)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        cell?.lblSmall.text = "\("ne_lbl_poster".localized) \(formatter.string(from: date))"
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n  = arrNews[indexPath.row]
        let vc = WebViewViewController(nibName: "WebViewViewController", bundle: nil)
        vc.newss = n
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        view.endEditing(true)
        currentPage = 1
        getDataWithSearch()
    }
    
    func getDataWithSearch() {
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        ModelManager.getListNewsInpage("\(currentPage)", sortType: sortType, sortBy: sortBy, searchKey: tfSearch.text, withSuccess: {(_ dicReturn: Any?) -> Void in
            if self.currentPage == 1 {
                self.arrNews.removeAll()
            }
            if let dicReturn = dicReturn as? [String : Any]{
                if let aReturn = dicReturn["arrNews"] as? [News] {
                    self.arrNews.append(contentsOf: aReturn)
                }
                self.allPage = Int(dicReturn["allpage"] as! Int)
                
            }
            self.tableView.reloadData()
            self.finishLoading()
            
        }, failure: {(_ error: String?) -> Void in
            
            self.view.makeToast(error, duration: 2.0, position: CSToastPositionCenter)
            self.finishLoading()
            
        })
    }
    
    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: viewTblView, animated: true)
        // [_tableView reloadData];
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        currentPage = 1
        getDataWithSearch()
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
            sortBy = SORT_BY_POSTED_DATE
            sortType = SORT_TYPE_ASC
        case 3:
            sortBy = SORT_BY_POSTED_DATE
            sortType = SORT_TYPE_DESC
        default:
            break
        }
        currentPage = 1
        getDataWithSearch()
    }
    
    func text() {
        lbl_new.text = "ne_lbl_title".localized
        tfSearch.placeholder = "ne_tf_search".localized
    }
}
