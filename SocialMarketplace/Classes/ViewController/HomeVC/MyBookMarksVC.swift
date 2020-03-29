
import UIKit

class MyBookMarksVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SortViewDelegate {
    @IBOutlet var revealBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var viewTblView: UIView!
    @IBOutlet weak var lbl_my__book: UILabel!

    @IBOutlet weak var imgNaviBg: UIImageView!

    var start_index: Int = 0
    var page: Int = 0

    private var arrAds = [Any]()
    private var isLoading = false
    private var arrSortType = [Any]()
    private var sortBy = ""
    private var sortType = ""

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        initData()
        initLoadmoreAndPullToRefresh()
        setRevealBtn()
    }

    override func viewWillAppear(_ animated: Bool) {
        //    _activityIndicator.hidden = NO;
        //    [_activityIndicator startAnimating];
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: false)
    }

    func initData() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_view_asc".localized, "sort_by_view_desc".localized]
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.layer.masksToBounds = false
        viewTblView.layer.masksToBounds = true
        page = 1
        start_index = 1
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
        if let user = gUser {
            print(user)
            MBProgressHUD.showAdded(to: viewTblView, animated: true)
            ModelManager.getBookmarksAds(byUserId: gUser.usId, andPage: "\(start_index)", sortType: sortType, sortBy: sortBy, withSuccess: {(_ dicReturn: [AnyHashable: Any]?) -> Void in
                if self.start_index == 1 {
                    self.arrAds.removeAll()
                }
                if let dicReturn = dicReturn as? [String: Any] {
                self.page = Int(dicReturn["allpage"] as! Int)
                if let aReturn = dicReturn["arrAds"] as? [Any] {
                    self.arrAds.append(contentsOf: aReturn)
                }
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                    self.tableView.reloadData()
                })
            }, failure: {(_ error: String?) -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                })
                self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
            })
        } else {
            finishLoading()
            view.makeToast("msg_login_to_use".localized, duration: 2.0, position: CSToastPositionCenter)
        }
        //
        //    } failure:^(NSString *error) {
        //
        //    }];
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: viewTblView, animated: true)
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = false
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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

    func text() {
        lbl_my__book.text = "rv_menu_favorite".localized
    }
}

