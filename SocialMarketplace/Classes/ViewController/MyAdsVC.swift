
import UIKit

class MyAdsVC: UIViewController, UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate, SortViewDelegate, EditAdsDelegate {
    @IBOutlet weak var lblTitle: MarqueeLabel!
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var revealBtn: UIButton!
    var sellerId = ""
    @IBOutlet weak var viewTblView: UIView!

    @IBOutlet weak var topNaviView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private var arrAds = [Any]()
    private var isLoading = false
    private var arrSortType = [Any]()
    private var sortBy = ""
    private var sortType = ""
    private var page: Int = 0
    private var start_index: Int = 0
    let STATUS_ACTIVE = "1"
    let STATUS_INACTIVE = "0"
    let STATUS_DRAFT = "2"
    let STATUS_EXPIRED = "3"
   
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        lblTitle.text = "rv_menu_my_ads".localized
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        topNaviView.backgroundColor = Helper.COLOR_DARK_PR_MARY
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.layer.masksToBounds = false
        viewTblView.layer.masksToBounds = true
        page = 1
        start_index = 1
        initLoadmoreAndPullToRefresh()
        initSortFunction()
        setRevealBtn()
        refreshData()
        activityIndicator.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        //    [self.activityIndicator startAnimating];
        //    self.activityIndicator.hidden = NO;
        //[self performSelectorInBackground:@selector(refreshData) withObject:nil];
    }

    func initSortFunction() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_view_asc".localized, "sort_by_view_desc".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
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
        var refreshControl = UIRefreshControl()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "table_bot_loadmore".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT])
        // refreshControl.triggerVerticalOffset = 60;
        refreshControl.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
        refreshControl.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        tableView.bottomRefreshControl = refreshControl
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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
        if start_index >= page {
            view.makeToast("msg_loadmore".localized, duration: 2.0, position: CSToastPositionCenter)
            finishLoading()
            return
        }
        start_index += 1
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
    }

    @objc func getData() {
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        
      ModelManager.getAdsByUserId(gUser.usId, typeUser: "1", andPage: "\(start_index)", sortType: sortType, sortBy: sortBy, withSuccess: { (dicReturn) in
            
            if self.start_index == 1 {
                self.arrAds.removeAll()
            }
            DispatchQueue.main.async(execute: {() -> Void in
                if let dicReturn = dicReturn as? [String : Any]{
                self.page = Int(dicReturn["allpage"] as! Int)
                    if let aAds = dicReturn["arrAds"] as? [Ads]{
                    self.arrAds.append(contentsOf: aAds)
                    }
                self.tableView.reloadData()
                self.finishLoading()
                }
            })
            
        }) { (err) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
            })
        }
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: viewTblView, animated: true)
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = false
    }

    //
    //-(void)setRevealBtn{
    //    SWRevealViewController *revealController = self.revealViewController;
    //    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    //    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //
    //}
    
// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyAdsCellEdit") as? MyAdsCellEdit
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyAdsCellEdit", owner: nil, options: nil)?[0] as? MyAdsCellEdit
        }
        let est = arrAds[indexPath.row] as? Ads
        cell?.lblTitle.text = est?.adsTitle
        cell?.imageAds.setImageWith(URL(string: est?.adsImage ?? ""), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
        })
        //cell.imageView3.imageURL = [NSURL URLWithString:est.image];
        if (est?.adsPrice == "3") {
            if let aValue = est?.adsPriceValue, let anUnit = est?.adsPriceUnit {
                cell?.lblPrice.text = "$\(aValue)/\(anUnit)"
            }
        }
        if (est?.adsPrice == "1") {
            cell?.lblPrice.text = "text_free".localized
        }
        if (est?.adsPrice == "2") {
            cell?.lblPrice.text = "text_negotiate".localized
        }
        cell?.lblAvaiable.isHidden = false
        cell?.lblAvaiable.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        if (est?.adsIsAvailable == "1") {
            cell?.lblAvaiable.isHidden = true
        } else if (est?.adsIsAvailable == "0") {
            if (est?.adsForRent == "1") {
                cell?.lblAvaiable.text = "text_rented".localized
            } else if (est?.adsForSale == "1") {
                cell?.lblAvaiable.text = "text_sold".localized
            }
        }
        cell?.imageAds.contentMode = .scaleAspectFill
        cell?.imageAds.clipsToBounds = true
        if (est?.adsForRent == "1") {
            cell?.lblRentOrSale.text = "text_for_rent".localized
        }
        if (est?.adsForSale == "1") {
            cell?.lblRentOrSale.text = "text_for_sale".localized
        }
        if est?.adsCategory != nil {
            cell?.lblCategory.text = est?.adsCategory
        } else {
            cell?.lblCategory.text = "text_all_category".localized
        }
        if est?.adsSub != nil {
            cell?.lblSubCat.text = est?.adsSub
        } else {
            cell?.lblSubCat.text = "text_all_sub_category".localized
        }
        if est?.adsCity != nil {
            cell?.lblCity.text = est?.adsCity
        } else {
            cell?.lblCity.text = "text_all_cities".localized
        }
        if (est?.adsStatus == STATUS_DRAFT) {
            cell?.lblStatusValue.text = "text_draft".localized
        }
        if (est?.adsStatus == STATUS_ACTIVE) {
            cell?.lblStatusValue.text = "text_active".localized
        }
        if (est?.adsStatus == STATUS_EXPIRED) {
            cell?.lblStatusValue.text = "text_expried".localized
        }
        if (est?.adsStatus == STATUS_INACTIVE) {
            cell?.lblStatusValue.text = "text_inactive".localized
        }
        cell?.lblPosted.text = est?.adsDateCreated.substring(with: NSRange(location: 0, length: 10))
        
        if (est?.adsIsFeatured == "1") {
            cell?.isFeatured.isHidden = false
        } else {
            cell?.isFeatured.isHidden = true
        }
        cell?.selectionStyle = .none
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let est = arrAds[indexPath.row] as? Ads
        let VC = EditAdsVC(nibName: "EditAdsVC", bundle: nil)
        VC.adsObj = est
        VC.delegate = self
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

    func didDeleteAds(_ adsObj: Any?) {
        if let anObj = adsObj {
            let arrA: NSArray = arrAds as NSArray
            let indexS = arrA.index(of: anObj)
            arrAds.remove(at: indexS)
        }
        tableView.reloadData()
    }
}
