
//
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class SearchAdsResultVC: UIViewController, UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate, SortViewDelegate {
    @IBOutlet weak var lblTitle: MarqueeLabel!
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var revealBtn: UIButton!
    var sellerId: String?
    var titleText: String? = ""
    @objc var paramDic = [String: Any]()
    @IBOutlet weak var viewTblView: UIView!

    @IBOutlet weak var topNaviView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private var arrAds = [Any]()
    private var isLoading = false
    private var page: Int = 0
    private var start_index: Int = 0
    private var arrSortType = [Any]()
    private var sortBy = ""
    private var sortType = ""
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    func initSortFunction() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_view_asc".localized, "sort_by_view_desc".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
    }

    func initData() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        page = 1
        start_index = 1
        sortBy = "0"
        sortType = "0"
        viewTblView.layer.masksToBounds = true
        tableView.layer.masksToBounds = false
    }

    func initLoadmoreAndPullToRefresh() {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        if titleText != "" {
            lblTitle.text = titleText
        }
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        initData()
        initSortFunction()
        initLoadmoreAndPullToRefresh()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: false)
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
        paramDic["sortBy"] = sortBy
        paramDic["sortType"] = sortType
        paramDic["page"] = "\(start_index)"
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        ModelManager.searchAds(withParam: paramDic, withSuccess: { (successDic) in
            
            if let dicReturn = successDic as? [String : Any] {
            if self.start_index == 1 {
                    self.arrAds.removeAll()
            }
            self.page = Int(dicReturn["allpage"] as! Int)
            self.arrAds.append(contentsOf: dicReturn["arrAds"] as! [Ads])
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
                self.tableView.reloadData()
            })
        }) { (err) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.topRefreshTable?.endRefreshing()
                self.tableView.bottomRefreshControl.endRefreshing()
                self.isLoading = false
                MBProgressHUD.hideAllHUDs(for: self.viewTblView, animated: true)
                self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
            })
        }
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: viewTblView, animated: true)
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = false
        // [_tableView reloadData];
    }

// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        var index: Int? = 0
        if button?.tag != nil {
            index = Int(Validator.getSafeInt(button?.tag))
        }
        let est = arrAds[index!] as? Ads
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
    }

    func customTexts() {
        lblTitle.text = "rs_title".localized
    }
}
