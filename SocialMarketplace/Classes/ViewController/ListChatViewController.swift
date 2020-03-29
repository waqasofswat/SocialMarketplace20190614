
//
//  ListChatViewController.swift
//  SmartAds
//
//  Created by Ngọc Toán on 7/21/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import DateToolsSwift
import UIKit
import Firebase

class ListChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    private var arrSortRecentMassage = [RecentChatObj]()
    private var arrRecentMess = [RecentChatObj]()

    override func viewDidLoad() {
        super.viewDidLoad()
        customText()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RecentContactTbCell2", bundle: nil), forCellReuseIdentifier: "RecentContactTbCell2")
        let nib = UINib(nibName: "MyNothingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyNothingTableViewCell")
        getListRecentMessage()
    }

    func customText() {
        lblTitle.text = "rv_menu_recent_chat".localized
    }

    func getListRecentMessage() {
        Database.database().reference().child("user/\(gUser.usId as String)/chatWith").queryOrdered(byChild: "datePost").observe(DataEventType.value) { (snapshot) in
            if snapshot.exists() {
                self.arrRecentMess.removeAll()
                for snapshotChat in snapshot.children {
                    let recentChatThumb = RecentChatObj(fromFDataSnapshot: snapshotChat as? DataSnapshot)
                    self.arrRecentMess.append(recentChatThumb as RecentChatObj)
                }
                self.arrSortRecentMassage =  self.arrRecentMess.sorted(by: { (obj1, obj2) -> Bool in
                    return Int(obj1.dateLastCreate!) > Int(obj2.dateLastCreate!)
                })
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSortRecentMassage.count > 0 {
            return arrSortRecentMassage.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrSortRecentMassage.count == 0 {
            let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "MyNothingTableViewCell")
            cell?.backgroundColor = UIColor.clear
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentContactTbCell2") as? RecentContactTbCell2
            let chatObj = arrSortRecentMassage[indexPath.row]
            cell?.labellast2.text = chatObj.lastMessage
            cell?.lbldate.text = Date(timeIntervalSince1970: chatObj.dateLastCreate ?? 0.0).timeAgoSinceNow
            cell?.lblunread.isHidden = true
            if !(chatObj.unreadMessage == 0) {
                cell?.lblunread.isHidden = false
                if chatObj.unreadMessage ?? 0 > 5 {
                    cell?.lblunread.text = "5+"
                } else {
                    cell?.lblunread.text = String((chatObj.unreadMessage)!)
                }
            }
            if (gUser.usId == chatObj.senderId) {
        //        cell?.imgguess.setImageWith(URL(string: chatObj.imgReceiver ?? ""), placeholderImage: Helper.IMAGE_HODER)
                cell?.lblmain.text = chatObj.receiverName
                cell?.setupOnlineOffline(withUserId: chatObj.receiverId)
            } else {
            //    cell?.imgguess.setImageWith(URL(string: chatObj.imgSender ?? ""), placeholderImage: Helper.IMAGE_HODER)
                cell?.lblmain.text = chatObj.senderName
                cell?.setupOnlineOffline(withUserId: chatObj.senderId)
                //now is local push + online off
            }
            cell?.backgroundColor = UIColor.clear
            if let aCell = cell {
                return aCell
            }
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSortRecentMassage.count < 1 {
            return
        }
        let lastMessObj = arrSortRecentMassage[indexPath.row]
        let contactVC = ChatVC(nibName: "ChatVC", bundle: nil)
        let sellerObj = User()
        if (gUser.usId == lastMessObj.senderId) {
            sellerObj.usId = lastMessObj.receiverId
            sellerObj.usName = lastMessObj.receiverName
            sellerObj.usImage = lastMessObj.imgReceiver
        } else {
            sellerObj.usId = lastMessObj.senderId
            sellerObj.usName = lastMessObj.senderName
            sellerObj.usImage = lastMessObj.imgSender
        }
        contactVC.seller = sellerObj
        navigationController?.pushViewController(contactVC, animated: true)
    }

    @IBAction func onMenu(_ sender: Any) {
        revealViewController().revealToggle(sender)
    }

    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
