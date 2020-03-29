
//
//  HomeVC.swift
//  Real Estate
//]//
//
//  HomeVC.swift
//  Real Ads
//
//  Created by Hicom Solutions on 1/24/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//
import GoogleMobileAds

import CoreLocation
import UIKit
import Kingfisher

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SortViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTableView: UIView!
    @IBOutlet var revealBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var btnRecent: UIButton!
    @IBOutlet weak var btnPopular: UIButton!
    @IBOutlet weak var btnNearBy: UIButton!
    @IBOutlet weak var btnSelectRecent: UIButton!
    @IBOutlet weak var btnSelectPopular: UIButton!
    @IBOutlet weak var btnSelectNearBy: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnSelectFollow: UIButton!

    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var imgNaviBg: UIImageView!

    var start_index: Int = 0
    var page: Int = 0

    private var refreshControl: UIRefreshControl?

    private var arrAds = [Any]()
    private var isLoading = ""
    private var lat = ""
    private var lon = ""
    private var arrSortType = [Any]()
    private var sortBy = ""
    private var sortType = ""
    private var locationManager: CLLocationManager?
   var bannerView: GADBannerView!

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }
        customTexts()
        lat = ""
        lon = ""
        initData()
        initSortFunction()
        initLoadmoreAndPullToRefresh()
        setRevealBtn()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.receiveTest(_:)), name: NSNotification.Name(rawValue: "NOTI_ON_COMMENT"), object: nil)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
       
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.getData()
    }
    

    func initSortFunction() {
        arrSortType = ["sort_by_name_asc".localized, "sort_by_name_desc".localized, "sort_by_date_asc".localized, "sort_by_date_desc".localized, "sort_by_view_asc".localized, "sort_by_view_desc".localized]
        sortBy = SORT_BY_ALL
        sortType = SORT_TYPE_NORMAL
    }

    func initData() {
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        
        
        //    _imgNaviBg.backgroundColor = COLOR_DARK_PR_MARY;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        page = 1
        start_index = 1
        btnRecent.isSelected = true
        btnSelectNearBy.isHidden = true
        btnSelectFollow.isHidden = true
        btnSelectPopular.isHidden = true
        btnSelectRecent.isHidden = false
        arrAds = [Any]()
        tableView.layer.masksToBounds = false
        tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "HomeViewCell")
        viewTableView.layer.masksToBounds = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0 {
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.startUpdatingLocation()
    }

    func initLoadmoreAndPullToRefresh() {
        isLoading = "0"
        topRefreshTable = UIRefreshControl()
    
        topRefreshTable?.attributedTitle = NSAttributedString(string: "table_top_refresh".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT] )
        topRefreshTable?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        topRefreshTable?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        if let aTable = topRefreshTable {
            tableView.addSubview(aTable)
        }
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "table_bot_loadmore".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT])
        // refreshControl.triggerVerticalOffset = 60;
        refreshControl?.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
        refreshControl?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        tableView.bottomRefreshControl = refreshControl
        
    }

    @objc func refreshData() {
        if (isLoading == "1") {
            return
        } else {
            start_index = 1
        }
        isLoading = "1"
        //    [self performSelectorInBackground:@selector(getData) withObject:nil];
        getData()
    }

    @objc func loadMore() {
        if (isLoading == "1") {
            return
        } else {
            isLoading = "1"
            if start_index == page {
                view.makeToast("msg_loadmore".localized, duration: 2.0, position: CSToastPositionCenter)
                finishLoading()
                return
            }
            start_index += 1
            self.getData()
        }
    }

    func scrollToTopTableView() {
        let top = IndexPath(row: NSNotFound, section: 0)
        tableView.scrollToRow(at: top, at: .top, animated: true)
    }

    @objc func getData() {
        if btnRecent.isSelected {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ModelManager.getAdsInPage("\(start_index)", sortType: sortType, sortBy: sortBy, screenType: "recent", withSuccess: { (arrReturn, allPage) in
                if self.start_index == 1 {
                    self.arrAds.removeAll()
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.page = Int(allPage)
                    if let aReturn = arrReturn {
                        self.arrAds.append(contentsOf: aReturn)
                    }
                    self.tableView.reloadData()
                    self.finishLoading()
                })
                
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.start_index == 1 {
                        self.scrollToTopTableView()
                    }
                })
            }, failure: {(_ error: String?) -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                    self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
                })
                
            })
            
        } else if btnPopular.isSelected {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ModelManager.getAdsInPage("\(start_index)", sortType: sortType, sortBy: sortBy, screenType: "popular", withSuccess: { (arrReturn, allPage) in
                if self.start_index == 1 {
                    self.arrAds.removeAll()
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.page = Int(allPage)
                    if let aReturn = arrReturn {
                        self.arrAds.append(contentsOf: aReturn)
                    }
                    self.tableView.reloadData()
                    self.finishLoading()
                })
                
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.start_index == 1 {
                        self.scrollToTopTableView()
                    }
                })
            }, failure: {(_ error: String?) -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                    self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
                })
                
            })
        } else if btnFollow.isSelected {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ModelManager.getAdsInPage("\(start_index)", sortType: sortType, sortBy: sortBy, screenType: "followed", withSuccess: { (arrReturn, allPage) in
                if self.start_index == 1 {
                    self.arrAds.removeAll()
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.page = Int(allPage)
                    if let aReturn = arrReturn {
                        self.arrAds.append(contentsOf: aReturn)
                    }
                    self.tableView.reloadData()
                    self.finishLoading()
                })
                
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.start_index == 1 {
                        self.scrollToTopTableView()
                    }
                })
            }, failure: {(_ error: String?) -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                    self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
                })
                
            })
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ModelManager.getAdsInPageWithNear(by: "\(start_index)", lat: lat, lon: lon, withSuccess: {( arrReturn,allPage) -> Void in
                if self.start_index == 1 {
                    self.arrAds.removeAll()
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.page = Int(allPage)
                    if let aReturn = arrReturn {
                        self.arrAds.append(contentsOf: aReturn)
                    }
                    self.tableView.reloadData()
                    self.finishLoading()
                })
                
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.start_index == 1 {
                        self.scrollToTopTableView()
                    }
                })
            }, failure: {(_ error: String?) -> Void in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.finishLoading()
                    self.view.makeToast(error, duration: 3.0, position: CSToastPositionCenter)
                })
                
            })

        }
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        topRefreshTable?.endRefreshing()
        tableView.bottomRefreshControl.endRefreshing()
        isLoading = "0"
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell") as? HomeViewCell
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
        isLoading = "1"
        getData()
    }


    @objc func receiveTest(_ notification: Notification?) {
        if ((notification?.name)!.rawValue == kNotiOnComment) {
            let userInfo = notification?.userInfo
            let adsId = Validator.getSafeString(userInfo!["adsId"])
            let commentVC = CommentVC(nibName: "CommentVC", bundle: nil)
            commentVC.adsId = adsId
            navigationController?.pushViewController(commentVC, animated: true)
        }
    }

// MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateToLocation: \(String(describing: locations.last))")
        let currentLocation: CLLocation? = locations.last
        if currentLocation != nil {
            lon = String(format: "%.8f", (currentLocation?.coordinate.longitude)!)
            lat = String(format: "%.8f", (currentLocation?.coordinate.latitude)!)
            locationManager?.stopUpdatingLocation()
        }
    }


    @IBAction func onRecent(_ sender: Any) {
        if btnRecent.isSelected {
            return
        }
        btnSort.isHidden = false
        btnSelectNearBy.isHidden = true
        btnSelectPopular.isHidden = true
        btnSelectFollow.isHidden = true
        btnSelectRecent.isHidden = false
        btnFollow.isSelected = false
        btnRecent.isSelected = true
        btnNearBy.isSelected = false
        btnPopular.isSelected = false
        refreshData()
    }

    @IBAction func onPopular(_ sender: Any) {
        if btnPopular.isSelected {
            return
        }
        btnSort.isHidden = false
        btnSelectNearBy.isHidden = true
        btnSelectPopular.isHidden = false
        btnSelectRecent.isHidden = true
        btnSelectFollow.isHidden = true
        btnFollow.isSelected = false
        btnPopular.isSelected = true
        btnNearBy.isSelected = false
        btnRecent.isSelected = false
        refreshData()
    }

    @IBAction func onFollow(_ sender: Any) {
        guard let userId = gUser else {
            view.makeToast("msg_login_to_use".localized , duration: 2.0, position: CSToastPositionCenter)
            return
        }
        print(userId)
        if btnFollow.isSelected {
            return
        }
        btnSort.isHidden = false
        btnSelectNearBy.isHidden = true
        btnSelectPopular.isHidden = true
        btnSelectRecent.isHidden = true
        btnSelectFollow.isHidden = false
        btnFollow.isSelected = true
        btnPopular.isSelected = false
        btnNearBy.isSelected = false
        btnRecent.isSelected = false
        refreshData()
    }

    @IBAction func onNear(by sender: Any) {
        if btnNearBy.isSelected {
            return
        }
        if lon.count == 0 || lat.count == 0 {
            view.makeToast("msg_location_not_determiner".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        btnSort.isHidden = true
        btnSelectNearBy.isHidden = false
        btnSelectPopular.isHidden = true
        btnSelectRecent.isHidden = true
        btnSelectFollow.isHidden = true
        btnFollow.isSelected = false
        btnNearBy.isSelected = true
        btnRecent.isSelected = false
        btnPopular.isSelected = false
        refreshData()
    }

    func customTexts() {
        lblTitle.text = "ho_title".localized
        btnRecent.setTitle("ho_btn_recent".localized, for: .normal)
        btnRecent.setTitle("ho_btn_recent".localized, for: .selected)
        
        btnPopular.setTitle("ho_btn_popular".localized, for: .normal)
        btnPopular.setTitle("ho_btn_popular".localized, for: .selected)
        
        btnFollow.setTitle("ho_btn_followed".localized, for: .normal)
        btnFollow.setTitle("ho_btn_followed".localized, for: .selected)
        
        btnNearBy.setTitle("ho_btn_nearby".localized, for: .normal)
        btnNearBy.setTitle("ho_btn_nearby".localized, for: .selected)
    }
}

