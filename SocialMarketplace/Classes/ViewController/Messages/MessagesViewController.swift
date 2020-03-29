
//
//  MessagesViewController.swift
//  Real Ads
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessagesViewController: UIViewController, UITableViewDragLoadDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tblView: UITableView!
    var numPage: String?
    var messageArr = [Any]()
    var bookMarkArr = [Any]()
    @IBOutlet weak var viewTblView: UIView!

    @IBOutlet weak var imgNaviBg: UIImageView!

    var page: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        // Do any additional setup after loading the view from its nib.
        setRevealBtn()
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        page = 1
        setdata()
        tblView.setDragDelegate(self, refreshDatePermanentKey: "list")
        tblView.showLoadMoreView = true
        tblView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        if gArrBookMark.count > 0 {
            tblView.reloadData()
        }
    }

// MARK: - Control datasource
    @objc func finishRefresh() {
        tblView.reloadData()
        tblView.finishRefresh()
    }

// MARK: - Drag delegate methods
    func dragTableDidTriggerRefresh(_ tableView: UITableView?) {
        //send refresh request(generally network request) here
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        page = 1
            // [self.messageArr removeAllObjects];
        let myThread = Thread(target: self, selector: #selector(self.setdata), object: nil)
        myThread.start()
        // Actually create the thread
        perform(#selector(self.finishRefresh), with: nil, afterDelay: 0.5)
    }

    func dragTableRefreshCanceled(_ tableView: UITableView?) {
        //cancel refresh request(generally network request) here
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.finishRefresh), object: nil)
    }

    func dragTableDidTriggerLoadMore(_ tableView: UITableView?) {
        page += 1
        // start_index++;
        if page <= Int(numPage!) ?? 0 {
            let myThread = Thread(target: self, selector: #selector(self.setdata), object: nil)
            myThread.start()
            // Actually create the thread
        } else {
            view.makeToast("msg_not_found".localized, duration: 2.0, position: CSToastPositionCenter)
            tblView.stopLoadMore()
        }
    }

    func dragTableLoadMoreCanceled1(_ tableView: UITableView?) {
    }

    @objc func setdata() {
        MBProgressHUD.showAdded(to: viewTblView, animated: true)
        ModelManager.getListMessage(withPage: "\(page)", withSuccess: {(_ dicReturn: [AnyHashable: Any]?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.viewTblView, animated: true)
            if self.page == 1 {
                self.messageArr.removeAll()
            }
            if let dicReturn = dicReturn as? [String: Any] {
                self.numPage = "\(dicReturn["allpage"] ?? "1")"
                if let aReturn = dicReturn["arrMess"] as? [Any] {
                    self.messageArr.append(contentsOf: aReturn)
                }
            }
           
            DispatchQueue.main.async(execute: {() -> Void in
                self.tblView.reloadData()
                self.tblView.stopRefresh()
                self.tblView.stopLoadMore()
            })
        }, failure: {(_ err: String?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.viewTblView, animated: true)
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
            self.tblView.stopRefresh()
            self.tblView.stopLoadMore()
        })
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        btnBack.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ManagePropertionTableViewCell") as? ManagePropertionTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ManagePropertionTableViewCell", owner: nil, options: nil)?[0] as? ManagePropertionTableViewCell
        }
        let mes = messageArr[indexPath.row] as? Messages
        if let aName = mes?.name, let aPhone = mes?.phone {
            cell?.descriptionScrollLabel.text = "\(aName) (\(aPhone))"
        }
        //cell.detailScrollLabel.text = [NSString stringWithFormat:@"%@",mes.phone];
        if let aTitle = mes?.title, let aContent = mes?.content {
            cell?.addressScrollLabel.text = "\(aTitle): \(aContent)"
        }
            //
        let date = Date(timeIntervalSince1970: TimeInterval((mes?.dateCreated?.doubleValue)!))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        cell?.expiredScrollLabel.text = formatter.string(from: date)
        //    gArrBookMark = [Util objectForKey:@"Mark"];
        //    if (gArrBookMark.count>indexPath.row) {
        //        NSString *idBook = [gArrBookMark objectAtIndex:indexPath.row];
        //        if ([mes.MessageId isEqualToString:idBook]) {
        //            cell.ImgBookMark.hidden = NO;
        //        }
        //    }
        cell?.imageVi.setImageWith(URL(string: mes?.image ?? ""), placeholderImage: Helper.IMAGE_HODER)
        cell?.imageVi.contentMode = .scaleAspectFill
        cell?.imageVi.clipsToBounds = true
        cell?.selectionStyle = .none
        cell?.viewCell.layer.cornerRadius = 6
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mes = messageArr[indexPath.row] as? Messages
        let detail = MessagesDetailViewController(nibName: "MessagesDetailViewController", bundle: nil)
        detail.message = mes
        navigationController?.pushViewController(detail, animated: true)
    }
}
