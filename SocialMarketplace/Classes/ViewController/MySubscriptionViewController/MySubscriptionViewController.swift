
//
//  MySubscriptionViewController.swift
//  Real Ads
//
//  Created by hieund@wirezy on 4/22/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

class MySubscriptionViewController: UIViewController, UITableViewDragLoadDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var revealBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    var mysubArr = [Any]()
    @IBOutlet weak var lbl_top_my: UILabel!
    var numPage = ""

    @IBOutlet weak var imgNaviBg: UIImageView!

    var page: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        // Do any additional setup after loading the view from its nib.
        setRevealBtn()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MySubscriptionViewController.targetMethod(_:)), userInfo: nil, repeats: false)
        page = 1
        tblView.setDragDelegate(self, refreshDatePermanentKey: "MySubList")
        tblView.showLoadMoreView = true
    }

// MARK: - Control datasource
    @objc func finishRefresh() {
        tblView.reloadData()
        tblView.finishRefresh()
    }

// MARK: - Drag delegate methods
    func dragTableDidTriggerRefresh(_ tableView: UITableView?) {
        //send refresh request(generally network request) here
        MBProgressHUD.showAdded(to: view, animated: true)
        page = 1
            //self.MysubArr = [[NSMutableArray alloc]init];
            //[self.MysubArr removeAllObjects];
        let myThread = Thread(target: self, selector: #selector(self.getdata), object: nil)
        myThread.start()
        // Actually create the thread
        perform(#selector(self.finishRefresh), with: nil, afterDelay: 2)
    }

    func dragTableRefreshCanceled(_ tableView: UITableView?) {
        //cancel refresh request(generally network request) here
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.finishRefresh), object: nil)
    }

    func dragTableDidTriggerLoadMore(_ tableView: UITableView?) {
        page += 1
        // start_index++;
        if page <= Int(numPage) ?? 0 {
            let myThread = Thread(target: self, selector: #selector(self.getdata), object: nil)
            myThread.start()
            // Actually create the thread
        } else {
            view.makeToast("No Data", duration: 2.0, position: CSToastPositionCenter)
            tblView.stopLoadMore()
        }
    }

    func dragTableLoadMoreCanceled1(_ tableView: UITableView?) {
    }

    @objc func targetMethod(_ time: Timer?) {
        getdata()
    }

   @objc func getdata() {
      ModelManager.mySubcription(withPage: "\(page)", withSuccess: { (dicReturn) in
         if let dicReturn = dicReturn as? [String : Any] {
            let arr = dicReturn["data"] as? [Any]
            self.numPage = dicReturn["allpage"] as? String ?? ""
            if self.page == 1 {
               self.mysubArr.removeAll()
            }
            for dic in arr! {
               let dic = JSON(dic)
               let est = MySubcription()
               est.duration = dic["duration"].stringValue
               est.adsId = dic["estateId"].stringValue
               est.endDate = dic["endDate"].stringValue
               est.payment = dic["payment"].stringValue
               est.paidDate = dic["paidDate"].stringValue
               est.value = dic["value"].stringValue
               est.image = dic["image"].stringValue
               est.titleAds = dic["titleAds"].stringValue
               self.mysubArr.append(est)
            }
         }
         MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
         self.tblView.reloadData()
      }) { (err) in
         MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
      }
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
        return mysubArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MySubscriptionTableViewCell") as? MySubscriptionTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MySubscriptionTableViewCell", owner: nil, options: nil)?[0] as? MySubscriptionTableViewCell
        }
        let ess = mysubArr[indexPath.row] as? MySubcription
        //cell.
        cell?.viewCell.layer.cornerRadius = 6
        cell?.imgCell.setImageWith(URL(string: ess?.image ?? ""), placeholderImage: Helper.IMAGE_HODER)
        cell?.descriptionScrollLabel.text = ess?.titleAds
        let interval1 = TimeInterval((ess?.paidDate?.doubleValue)!)
        let date1 = Date(timeIntervalSince1970: interval1)
        let interval2 = TimeInterval((ess?.endDate?.doubleValue)!)
        let date2 = Date(timeIntervalSince1970: interval2)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cell?.fromScrollLabel.text = "\(formatter.string(from: date1)) to \(formatter.string(from: date2))"
        if let aDuration = ess?.duration {
            cell?.reachScrollLabel.text = "\(aDuration) \("ms_text_days".localized)"
        }
        if let aValue = ess?.value {
            cell?.spentScrollLabel.text = "$\(aValue)"
        }
        cell?.selectionStyle = .none
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func text() {
        lbl_top_my.text = "rv_menu_mysubcription".localized
    }
}
