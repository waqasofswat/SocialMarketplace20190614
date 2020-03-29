
//
//  CommentVC.swift
//  SmartAds
//
//  Created by Pham Diep on 5/26/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit

class CommentVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {
    var topRefreshTable: UIRefreshControl?
    var adsId: String?

    @IBOutlet weak var tbvComment: UITableView!
    @IBOutlet weak var tfComment: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var comment: UILabel!
   @IBOutlet weak var constrainPaddingBot: NSLayoutConstraint!

    var start_index: Int = 0
    var page: Int = 0

    private var arrComment = [Any]()
    private var isLoading: String?
    private var refreshControl: UIRefreshControl?
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

      self.tfComment.delegate = self

        initLoadmoreAndPullToRefresh()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getData), userInfo: nil, repeats: false)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: Notification.Name.UIKeyboardDidShow, object: nil)

    }
   
   
   @objc func keyboardShow(_ notification: Notification?) {
      let userInfo:NSDictionary = notification!.userInfo! as NSDictionary
      let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      self.constrainPaddingBot.constant = keyboardHeight
      
   }
   func textViewDidEndEditing(_ textView: UITextView) {
      self.constrainPaddingBot.constant = 0
      if self.tfComment.text == ""{
         self.tfComment.text = "Write comment here"
      }
   }
   func textViewDidBeginEditing(_ textView: UITextView) {
      if self.tfComment.text == "Write comment here"{
         self.tfComment.text = ""
      }
   }


    func initData() {
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        tbvComment.rowHeight = UITableViewAutomaticDimension
        tbvComment.estimatedRowHeight = 44.0
        tfComment.layer.borderColor = UIColor.darkGray.cgColor
        tfComment.layer.borderWidth = 0.5
        page = 1
        start_index = 1
        tbvComment.register(UINib(nibName: "CommentTbvCell", bundle: nil), forCellReuseIdentifier: "CommentTbvCell")
    }

    func initLoadmoreAndPullToRefresh() {
        isLoading = "0"
        topRefreshTable = UIRefreshControl()
        topRefreshTable?.attributedTitle = NSAttributedString(string: "table_top_refresh".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT] )
        topRefreshTable?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        topRefreshTable?.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        if let aTable = topRefreshTable {
            tbvComment.addSubview(aTable)
        }
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "table_bot_loadmore".localized, attributes: [NSAttributedStringKey.foregroundColor: Helper.COLOR_PRIMARY_DEFAULT])
        // refreshControl.triggerVerticalOffset = 60;
        refreshControl?.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
        refreshControl?.tintColor = Helper.COLOR_PRIMARY_DEFAULT
        tbvComment.bottomRefreshControl = refreshControl
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
                view.makeToast(Util.localized("lbl_no_more_products"), duration: 2.0, position: CSToastPositionCenter)
                finishLoading()
                return
            }
            start_index += 1
            performSelector(inBackground: #selector(self.getData), with: nil)
        }
    }

    @objc func getData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        ModelManager.getListComment(ofAds: adsId, page: Int32(start_index), withSuccess: {(dicReturn) -> Void in
//            if self.start_index == 1 {
//                self.arrComment.removeAll()
//            }
            DispatchQueue.main.async(execute: {() -> Void in
                if let dicReturn = dicReturn as? [String : Any] {
                    if self.start_index == 1 {
                        self.arrComment.removeAll()
                    }
                    self.page = Int(dicReturn["allpage"] as! Int)
                    self.arrComment.append(contentsOf: dicReturn["arrObj"] as! [Any])
                }
                self.tbvComment.reloadData()
                self.finishLoading()
            })
        }, failure: {(_ err: String?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.finishLoading()
                self.view.makeToast(err, duration: 3.0, position: CSToastPositionCenter)
            })
        })
    }

    func finishLoading() {
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
        topRefreshTable?.endRefreshing()
        tbvComment.bottomRefreshControl.endRefreshing()
        isLoading = "0"
    }

// MARK: UITABALEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //  if (!((indexPath.row == estateArr.count)&&(estateArr.count == start_index))) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTbvCell") as? CommentTbvCell
        cell?.setupData(withObj: arrComment[indexPath.row] as? Comment)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onSend(_ sender: Any) {
        view.endEditing(true)
        if tfComment.text.count == 0 {
            view.makeToast(Util.localized("lbl_please_insert_comment_first"))
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        ModelManager.pushComment(withAdsId: adsId, content: tfComment.text, withSuccess: {(_ strSuccess: String?) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tfComment.text = ""
            self.refreshData()
        }, failure: {(_ err: String?) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(err)
        })
    }

    func settext() {
        comment.text = Util.localized("lbl_top_comment")
    }
}
