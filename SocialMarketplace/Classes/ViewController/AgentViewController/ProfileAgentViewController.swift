
//
//  AllAdsViewController.h
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//
//
//  AllAdsViewController.m
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class ProfileAgentViewController: UIViewController, UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate, SortViewDelegate {
    @IBOutlet weak var lblTitle: MarqueeLabel!
    var stringTitle: String?
    var topRefreshTable: UIRefreshControl?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var revealBtn: UIButton!
    var sellerId: String?
    @IBOutlet weak var viewTblView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewSeller: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgVerified: UIImageView!
    var seller: User?

    @IBOutlet weak var topNaviView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeightScrollView: NSLayoutConstraint!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnSendMessage: UIButton!

    private var arrAds = [Ads]()
    private var arrSortType = [Any]()
    private var isLoading = false
    private var page: Int = 0
    private var start_index: Int = 0
    private var sortType = ""
    private var sortBy = ""
   
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

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
        initLayout()
        layoutView1()
        activityIndicator.isHidden = true
        Timer.scheduledTimer(timeInterval: 01.0, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
    }

    func initLayout() {
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        btnSendMessage.clipsToBounds = true
        btnSendMessage.layer.cornerRadius = 5
        btnSendMessage.layer.backgroundColor = Helper.COLOR_BTN_SMALL.cgColor
    }

    func layoutView1() {
        lblTitle.text = stringTitle
        lblEmail.text = seller?.usEmail
        lblPhone.text = seller?.usPhone
        lblDescription.text = seller?.usDescription
        if (lblDescription.text == "") {
            constraintHeightScrollView.constant = 0
        } else {
            if (getLabelHeight(lblDescription) / (14 + 3)) <= 4 {
                constraintHeightScrollView.constant = getLabelHeight(lblDescription) + 5
            } else {
                constraintHeightScrollView.constant = 70
            }
        }
        avatar.setImageWith(URL(string: seller?.usImage ?? ""), placeholderImage: Helper.IMAGE_HODER)
        nameLabel.text = seller?.usName
        if (seller?.usIsverified == "0") {
            imgVerified.isHidden = true
        } else {
            imgVerified.isHidden = false
        }
        btnFollow.layer.cornerRadius = 4
      btnFollow.setTitle("FOLLOWED", for: UIControlState.selected)
      btnFollow.setTitle("FOLLOW", for: UIControlState.normal)
      btnFollow.layer.borderWidth = 1
      self.btnFollow.layer.borderColor = Helper.COLOR_BTN_SMALL.cgColor
      if self.seller?.usIsFollow ?? false{
            btnFollow.isSelected = true
            btnFollow.backgroundColor = UIColor.white
            btnFollow.layer.borderWidth = 1
            btnFollow.layer.borderColor = Helper.COLOR_BTN_SMALL.cgColor
        } else {
            btnFollow.isSelected = false
            btnFollow.backgroundColor = Helper.COLOR_BTN_SMALL
        }
    }

    func getLabelHeight(_ label: UILabel?) -> CGFloat {
        var size = CGSize.zero
        size = (label?.font.sizeOfString(string: (label?.text)!, constrainedToWidth: Double((label?.frame.size.width)!)))!
        return size.height
    }

    func initSortFunction() {
        arrSortType = ["Sort by Name asc", "Sort by Name desc", "Sort by Date asc", "Sort by Date desc", "Number of Viewed acs", "Number of Viewed desc"]
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
                if let dicReturn = dicReturn as? [String: Any]{
                self.page = Int(dicReturn["allpage"] as! Int)
                if let aReturn = dicReturn["arrAds"] as? [Ads] {
                    self.arrAds.append(contentsOf: aReturn)
                    
                    }
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
        let est = arrAds[indexPath.row]
        cell?.setupData(with: est)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let est = arrAds[indexPath.row]
        let VC = DetailAdsViewController(nibName: "DetailAdsViewController", bundle: nil)
        VC.objAds = est
        navigationController?.pushViewController(VC, animated: true)
    }

    func readMore(_ button: UIButton?) {
        var index: Int = 0
        if button?.tag != nil {
            index = Int(button?.tag as! Int)
        }
        let est = arrAds[index]
        let VC = DetailAdsViewController(nibName: "DetailAdsViewController", bundle: nil)
        VC.objAds = est
        navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func onReport(_ sender: Any) {
        //now is follow
        if !((login_already == "1") || (login_already == "2")) {
            Util.showMessage("Please login to use this function!", withTitle: APP_NAME)
            return
        }
        let follow = btnFollow.isSelected ? "0" : "1"
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.follow(withAgentId: self.seller?.usId, type: follow, success: {(_ strStatus: String?) -> Void in
                //
            }, failure: {(_ err: String?) -> Void in
                //
            })
        })
        btnFollow.isSelected = !btnFollow.isSelected
        if btnFollow.isSelected {
            self.seller?.usIsFollow = true
            btnFollow.backgroundColor = UIColor.white
        } else {
         self.seller?.usIsFollow = false
            btnFollow.backgroundColor = Helper.COLOR_BTN_SMALL
        }
    }

    @IBAction func onCallNow(_ sender: Any) {
        //now is chat
        //    if (_seller.usPhone.length >0) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //            [Util callPhoneNumber:_seller.usPhone];
        //        });
        //    }else{
        //        [self.view makeToast:@"Can't call this seller!" duration:1.5 position:CSToastPositionCenter ];
        //    }
        if (login_already == "1") || (login_already == "2") {
            let objSeller: User? = seller
            let contactVC = ChatVC(nibName: "ChatVC", bundle: nil)
            contactVC.seller = objSeller
            navigationController?.pushViewController(contactVC, animated: true)
        } else {
            Util.showMessage("Please login to use this function!", withTitle: APP_NAME)
        }
    }

    @IBAction func onBack(_ sender: Any) {
        GlobalVar.shareInstance.gSeller = self.seller
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onSort(_ sender: Any) {
            //    SortViewController *sortVC = [[SortViewController alloc]initWithNibName:@"SortViewController" bundle:nil];
            //    sortVC.delegate = self;
            //    sortVC.arrDataSource = arrSortType;
            //    [sortVC presentInParentViewController:self];
            //===now is report===///
        let contacVC = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        contacVC.strTitle = CONTACT_REPORT_SELLER
        if let anId = seller?.usId, let aName = seller?.usName {
            contacVC.strContent = "\("Seller ID : ")\(anId)\(", name: ")\(aName)"
        }
        navigationController?.pushViewController(contacVC, animated: true)
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

    @IBAction func onMessage(_ sender: Any) {
        let sendMessageVC = SendMessageVC(nibName: "SendMessageVC", bundle: nil)
        sendMessageVC.stringTitle = seller?.usName
        sendMessageVC.accountId = sellerId
        navigationController?.pushViewController(sendMessageVC, animated: true)
    }
}
