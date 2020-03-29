
//
//  AllAdsViewController.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class AllAdsViewController: UIViewController, UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate, SortViewDelegate {

    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var revealBtn: UIButton!
    var sellerId = ""
    var stringTitle: String?
    @IBOutlet weak var viewTblView: UIView!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    
    @IBOutlet weak var topNaviView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private var arrAds = [Any]()
    private var arrSortType = [Any]()
    private var isLoading = false
    private var page: Int = 0
    private var start_index: Int = 0
    private var sortType = ""
    private var sortBy = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        topNaviView.backgroundColor = Helper.COLOR_DARK_PR_MARY
        tableView.layer.masksToBounds = false
        viewTblView.layer.masksToBounds = true
        page = 1
        start_index = 1
        initSortFunction()
        initLoadmoreAndPulltoRefresh()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        Timer.scheduledTimer(timeInterval: 01.0, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
    }

    func initSortFunction() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_view_asc".localized, "sort_by_view_desc".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
    }

    func initLoadmoreAndPulltoRefresh() {
        isLoading = false
        topRefreshTable = UIRefreshControl()
        topRefreshTable?.attributedTitle = NSAttributedString(string: "table_top_refresh".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT] )
        topRefreshTable?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        topRefreshTable?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        if let aTable = topRefreshTable {
            tableView.addSubview(aTable)
        }
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "table_bot_loadmore".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT])
        // refreshControl.triggerVerticalOffset = 60;
        refreshControl.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
        refreshControl.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        tableView.bottomRefreshControl = refreshControl
    }

    @objc func refreshData() {
        if isLoading {
            return
        } else {
            start_index = 1
        }
        isLoading = true
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
    }

    @objc func loadMore() {
        if isLoading {
            return
        } else {
            isLoading = true
        }
        if start_index == page {
            view.makeToast("msg_loadmore".localized, duration: 2.0, position: CSToastPositionCenter)
            finishLoading()
            return
        }
        start_index += 1
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
    }

    @objc func getData() {
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        
      ModelManager.getAdsByUserId(sellerId, typeUser: "2", andPage: "\(start_index)", sortType: sortType, sortBy: sortBy, withSuccess: {(dicReturn) -> Void in
            if self.start_index == 1 {
                self.arrAds.removeAll()
            }
            DispatchQueue.main.async(execute: {() -> Void in
                guard let dicThump = dicReturn as? [String: Any] else{
                    self.finishLoading()
                    self.tableView.reloadData()
                    return
                }
                self.page = Int(Validator.getSafeInt(dicThump["allpage"]))
                if let aReturn = dicThump["arrAds"] as? [Ads] {
                    self.arrAds.append(contentsOf: aReturn)
                }
                self.finishLoading()
                self.tableView.reloadData()
            })
        
        }, failure: {(_ error: String?) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
                self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
            })
        
        })
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: viewTblView, animated: true)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = false
    }

// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //  if (!((indexPath.row == estateArr.count)&&(estateArr.count == start_index))) {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell") as? HomeViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HomeViewCell", owner: nil, options: nil)?[0] as? HomeViewCell
        }
        let est = arrAds[indexPath.row] as? Ads
        cell?.setupData(with: est)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let est = arrAds[indexPath.row] as? Ads
        let VC = DetailAdsViewController(nibName: "DetailAdsViewController", bundle: nil)
        VC.objAds = est
        navigationController?.pushViewController(VC, animated: true)
    }

    func readMore(_ button: UIButton?) {
        var index: Int = 0
        if button?.tag != nil {
            index = Int(Validator.getSafeInt(button?.tag))
        }
        let est = arrAds[index] as? Ads
        let VC = DetailAdsViewController(nibName: "DetailAdsViewController", bundle: nil)
        VC.objAds = est
        navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onSort(_ sender: Any) {
        let sortVC = SortViewController(nibName: "SortViewController", bundle: nil)
        sortVC.delegate = self
        sortVC.arrDataSource = arrSortType
        sortVC.present(inParentViewController: self)
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
        case 4:
            sortBy = SORT_BY_VIEW
            sortType = SORT_TYPE_ASC
        case 5:
            sortBy = SORT_BY_VIEW
            sortType = SORT_TYPE_DESC
        default:
            break
        }
        start_index = 1
        isLoading = true
        getData()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func text() {
        self.lblTitle.text = stringTitle;
    }
}
