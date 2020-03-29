
//
//  ChatVC.swift
//  SmartAds
//
//  Created by Pham Diep on 5/29/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import Photos
import UIKit
import IQKeyboardManagerSwift

import Firebase
import SwiftyJSON

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, ChatTbvCell2Delegate {
    var imagePicker: UIImagePickerController?
    @IBOutlet weak var lblTitle: UILabel!
    @objc var seller: User?
    @IBOutlet weak var tbvMessage: UITableView!
    @IBOutlet weak var tfComment: UITextView!
    var conversationId = ""
    @IBOutlet weak var viewUpload: UIView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblUploadPictures: UILabel!
    @IBOutlet weak var lblMessageUpload: UILabel!
   
   @IBOutlet weak var constrainPaddingBot: NSLayoutConstraint!
   
    private var arrComment = [Any]()
    private var pullToRefresh: UIRefreshControl?
    private var numberOfMesShow: Int = 0
    private var filename = ""
    private var imageH = ""
    private var imageW = ""
    private var loadMore = false
   
   
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextss()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        viewUpload.isHidden = true
        let detail = ListChatViewController(nibName: "ListChatViewController", bundle: nil)
        let naviVC = UINavigationController(rootViewController: detail)
        naviVC.setNavigationBarHidden(true, animated: false)
        //    [self.revealViewController pushFrontViewController:naviVC animated:YES];
        filename = ""
        imageH = ""
        imageW = ""
        numberOfMesShow = 20
        tbvMessage.rowHeight = UITableViewAutomaticDimension
        tbvMessage.estimatedRowHeight = 30
        tbvMessage.delegate = self
        tbvMessage.dataSource = self
        tbvMessage.register(UINib(nibName: "ChatTbvCell2", bundle: nil), forCellReuseIdentifier: "ChatTbvCell2")
        tfComment.autocorrectionType = .no
        tfComment.delegate = self
      IQKeyboardManager.shared.enableAutoToolbar = true
        let tapToHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleSingleTap(_:)))
        tapToHideKeyboard.numberOfTapsRequired = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.closeUploadPopup(_:)))
        tap.numberOfTapsRequired = 1
        viewUpload.addGestureRecognizer(tap)
        tbvMessage.addGestureRecognizer(tapToHideKeyboard)
        pullToRefresh = UIRefreshControl()
        if let aRefresh = pullToRefresh {
            tbvMessage.addSubview(aRefresh)
        }
        pullToRefresh?.addTarget(self, action: #selector(self.pullToLoadmore), for: .valueChanged)
        getData()
        registerNotificationCenterHooks()

        // Do any additional setup after loading the view from its nib.
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
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: Notification.Name.UIKeyboardDidShow, object: nil)

        updateStatus(inOutViewController: "1")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unRegisterNotificationCenterHooks()
      NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidShow, object: nil)
        updateStatus(inOutViewController: "0")
        var referentChatIdPathFromUser: String? = nil
        if let anId = seller?.usId {
            referentChatIdPathFromUser = "user/\(gUser.usId as String)/chatWith/\(anId)"
        }
        
        Database.database().reference().child(referentChatIdPathFromUser!).removeObserver(withHandle: UInt(DataEventType.value.rawValue))
        
        
        super.viewDidDisappear(animated)
    }
    
    @objc func closeUploadPopup(_ recognizer: UITapGestureRecognizer?) {
        viewUpload.isHidden = true
    }
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer?) {
        tfComment.endEditing(true)
    }
    
    @objc func pullToLoadmore() {
        if conversationId.count > 0 {
            numberOfMesShow += 20
            loadMore = true
            getListMessageWith()
        } else {
            pullToRefresh?.endRefreshing()
        }
    }
    
    func getData() {
        var referentChatIdPathFromUser: String? = nil
        if let anId = seller?.usId {
            referentChatIdPathFromUser = "user/\(gUser.usId as String)/chatWith/\(anId)"
        }
        Database.database().reference().child(referentChatIdPathFromUser!).observe(DataEventType.value, with: {(_ snapshot: DataSnapshot) -> Void in
            if snapshot.exists() {
                for lastMessobj in snapshot.children {
                    let lastMessobj = lastMessobj as! DataSnapshot
                    self.conversationId = Validator.getSafeString(lastMessobj.key)
                }
                if self.conversationId.count > 0 {
                    self.loadMore = false
                    self.getListMessageWith()
                }
            } else {
                
            }
        })
    }
    
    func getListMessageWith() {
        Database.database().reference().child("message").child(conversationId).queryLimited(toLast: UInt(numberOfMesShow)).observeSingleEvent(of: DataEventType.value, with: {(_ snapshot: DataSnapshot) -> Void in
            if snapshot.exists() {
                self.arrComment.removeAll()
                for thumbMessSnap in snapshot.children {
                    let thumbMessSnap = thumbMessSnap as! DataSnapshot
                    let mesObj = MessageObj(fromFdataSnapShot: thumbMessSnap)
                    
                    self.arrComment.append(mesObj)
                }
                self.tbvMessage.reloadData()
                self.pullToRefresh?.endRefreshing()
                if !self.loadMore {
                    self.scrollToBottom()
                }
                Database.database().reference().child("message").child(self.conversationId).removeObserver(withHandle: UInt(DataEventType.value.rawValue))
                //            [[[FIRDatabase database].reference child:[NSString stringWithFormat:@"user/%@/chatWith/%@/%@", gUser.usId, _seller.usId, _conversationId]] updateChildValues:@{@"status" : @"1"}];
            }
        })
    }
    
    func scrollToBottom() {
        let rows: Int = tbvMessage.numberOfRows(inSection: 0)
        if rows > 0 {
            tbvMessage.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: false)
        }
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(arrComment.count-1) inSection:0];
        //    [self.tbvMessage scrollToRowAtIndexPath:indexPath
        //                           atScrollPosition:UITableViewScrollPositionTop
        //                                   animated:NO];
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSend(_ sender: Any) {
        if btnSend.tag == 1 {
            viewUpload.isHidden = false
        } else {
            sendMessage()
        }
    }
    
    @IBAction func onGallery(_ sender: Any) {
        viewUpload.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .savedPhotosAlbum
        if let aPicker = imagePicker {
            present(aPicker, animated: true) {() -> Void in }
        }
    }
    
    @IBAction func onCamera(_ sender: Any) {
        viewUpload.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .camera
        imagePicker?.showsCameraControls = true
        if let aPicker = imagePicker {
            present(aPicker, animated: true) {() -> Void in }
        }
    }
    
    func sendMessage() {
        if tfComment.text.count == 0 && filename.count == 0 {
            return
        }
        if conversationId.count > 0 {
            loadMore = false
            postComment(tfComment.text)
            tfComment.text = ""
        } else {
            var referentChatIdPathFromUser: String? = nil
            if let anId = seller?.usId {
                referentChatIdPathFromUser = "user/\(gUser.usId as String)/chatWith/\(anId)"
            }
            Database.database().reference().child(referentChatIdPathFromUser!).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if snapshot.exists() {
                    self.conversationId = Validator.getSafeString(snapshot.value)
                    self.postComment(self.tfComment.text)
                    self.tfComment.text = ""
                } else {
                    self.conversationId = Database.database().reference().child(referentChatIdPathFromUser!).childByAutoId().key
                    self.postComment(self.tfComment.text)
                    self.tfComment.text = ""
                }
                self.loadMore = false
                self.getListMessageWith()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true) {() -> Void in }
    }
    
    // MARK: -  imagepicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker?.dismiss(animated: true) {() -> Void in }
        MBProgressHUD.showAdded(to: view, animated: true)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            self.imageW = "\(image?.size.width ?? 0.0)"
            self.imageH = "\(image?.size.height ?? 0.0)"
            let newImage: UIImage? = Util.image(with: image, convertToWidth: 400)
            let dataFile = UIImageJPEGRepresentation(newImage!, 0.5)
            ModelManager.upload(withFile: dataFile, uid: gUser.usId, withSuccess: {(_ msg: String?) -> Void in
                //Get file server name
                let arr = msg?.components(separatedBy: "/")
                self.filename = "\(arr?[(arr?.count ?? 0) - 2] ?? "")/\(arr?[(arr?.count ?? 0) - 1] ?? "")"
                //Get file local name
                //            NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                //            PHAsset *asset=[PHAsset fetchAssetsWithALAssetURLs:@[referenceURL] options:nil].firstObject;
                //            if (asset) {
                //                // get photo info from this asset
                //                PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
                //                imageRequestOptions.synchronous = YES;
                //                [[PHImageManager defaultManager]
                //                 requestImageDataForAsset:asset
                //                 options:imageRequestOptions
                //                 resultHandler:^(NSData *imageData, NSString *dataUTI,
                //                                 UIImageOrientation orientation,
                //                                 NSDictionary *info)
                //                 {
                //                     if ([info objectForKey:@"PHImageFileURLKey"]) {
                //                         NSString *path = [NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]];
                //                         NSArray *arr = [path componentsSeparatedByString:@"/"];
                //                         NSString *text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:[arr count] - 1]];
                //                         _tfComment.text = text;
                //                     }
                //                 }];
                //            }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.sendMessage()
                })
                MBProgressHUD.hide(for: self.view, animated: false)
            }, failure: {(_ msg: String?) -> Void in
                self.view.makeToast(msg, duration: 2.0, position: CSToastPositionCenter)
                MBProgressHUD.hide(for: self.view, animated: false)
            })
        })
    }
    
    func postComment(_ comment: String?) {
        var comment = comment
        if btnSend.tag == 1 {
            comment = "[Image]"
        }
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            ModelManager.pushMessage(withReceiveId: self.seller?.usId, content: comment, withSuccess: {(_ dicSuccess: String?) -> Void in
                print("send push message - \(dicSuccess ?? "")")
            }, failure: {(_ err: String?) -> Void in
                print("send push message - \(err ?? "")")
            })
        })
        Database.database().reference().child("message").child(conversationId).childByAutoId().updateChildValues(["senderId": gUser.usId, "receiverId": self.seller?.usId, "datePost": String(format: "%.0lf", Date().timeIntervalSince1970), "message": comment, "urlFile": filename, "imageH": imageH, "imageW": imageW], withCompletionBlock: {(_ error: Error?, _ ref: DatabaseReference) -> Void in
            self.filename = ""
            self.imageH = ""
            self.imageW = ""
            if error == nil {
                //**  Update last message in Sender user
                if let anId = self.seller?.usId, let comment = comment {
                    Database.database().reference().child("user/\(gUser.usId as String)/chatWith/\(anId)/\(self.conversationId)").updateChildValues(["lastMessage": comment, "datePost": String(format: "%.0lf", Date().timeIntervalSince1970), "senderId": gUser.usId, "receiverId": anId, "imageSender": gUser.usImage, "imageReceiver": self.seller?.usImage, "senderName": gUser.usName, "receiverName": self.seller?.usName, "unread": "0"], withCompletionBlock: {(_ error: Error?, _ ref: DatabaseReference) -> Void in
                        if error == nil {
                            self.tfComment.text = ""
                        }
                    })
                }
                //Get last msg receiver user
                var referentChatIdPathToUser: String? = nil
                if let anId = self.seller?.usId {
                    referentChatIdPathToUser = "user/\(anId)/chatWith/\(gUser.usId as String)/\(self.conversationId)"
                }
                Database.database().reference().child(referentChatIdPathToUser!).observeSingleEvent(of: DataEventType.value, with: {(_ snapshot: DataSnapshot) -> Void in
                    var unread: String? = "0"
                    if snapshot.exists() {
                        if let data = snapshot.value as? [String: String]{
                            if !(data["status"] == "1") {
                                unread = data["unread"]
                                unread = "\((unread?.integerValue)! + 1)"
                            }
                        }
                    } else {
                        unread = "1"
                    }
                    if let anId = self.seller?.usId, let comment = comment {
                        Database.database().reference().child("user/\(anId)/chatWith/\(gUser.usId as String)/\(self.conversationId)").updateChildValues(["lastMessage": comment, "datePost": String(format: "%.0lf", Date().timeIntervalSince1970), "senderId": gUser.usId, "receiverId": anId, "imageSender": gUser.usImage, "imageReceiver": self.seller?.usImage, "senderName": gUser.usName, "receiverName": self.seller?.usName, "unread": unread], withCompletionBlock: {(_ error: Error?, _ ref: DatabaseReference) -> Void in
                            if error == nil {
                                self.tfComment.text = ""
                            }
                        })
                    }
                })
            }
        })
    }
    
    // MARK:: tbview delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTbvCell2", for: indexPath) as? ChatTbvCell2
        cell?.selectionStyle = .none
        let objMessage = arrComment[indexPath.row] as? MessageObj
        objMessage?.imgInfoObj?.imgIfIndexPath = indexPath
        cell?.indexClick = indexPath.row
        cell?.delegate = self
        cell?.backgroundColor = UIColor.clear
        cell?.hideAllCell()
        if (gUser.usId == objMessage?.senderId) {
            cell?.tvMessageHost.backgroundColor = Helper.COLOR_BG_MESSAGE_HOST
            cell?.stackViewHost.isHidden = false
            cell?.viewContainImgHost.isHidden = false
            if indexPath.row > 0 {
                let objLastMessage = arrComment[indexPath.row - 1] as? MessageObj
                cell?.viewContainImgHost.isHidden = (objMessage?.senderId == objLastMessage?.senderId) ? true : false
            }
            let date = Date(timeIntervalSince1970: objMessage?.dateCreate ?? 0.0)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy HH:mm"
            cell?.lblDatePostHost.text = formatter.string(from: date)
            cell?.imgHost.setImageWith(URL(string: gUser.usImage), placeholderImage: Helper.IMAGE_HODER)
            if objMessage?.imgInfoObj?.imgIfUrl?.count == 0 {
                cell?.tvMessageHost.isHidden = false
                cell?.tvMessageHost.text = objMessage?.content
            } else {
                let arrType = objMessage?.imgInfoObj?.imgIfUrl?.components(separatedBy: ".")
                if (arrType?.count ?? 0) > 0 {
                    if (arrType?.last == "jpg") || (arrType?.last == "JPG") || (arrType?.last == "PNG") || (arrType?.last == "png") || (arrType?.last == "gif") || (arrType?.last == "GIF") {
                        cell?.viewHostSendImage.isHidden = false
                        //                        let rowHeight = CGFloat(objMessage?.imgInfoObj.imgHeight ?? 0.0 * (cell?.imageHostSend.bounds.size.width ?? 0.0 / objMessage?.imgInfoObj.imgWidth ?? 0.0))
                        var rowHeight: CGFloat = 0.0
                        if let imgHeight = objMessage?.imgInfoObj?.imgHeight?.floatValue , let imgWidth = objMessage?.imgInfoObj?.imgWidth?.floatValue {
                            rowHeight = CGFloat( CGFloat(imgHeight) * ((cell?.imageHostSend.bounds.size.width)! / CGFloat(imgWidth) ))
                            
                        }
                        
                        //                         = CGFloat( (objMessage?.imgInfoObj?.imgHeight as! NSString).floatValue * (Float(cell?.imageHostSend.bounds.size.width) / (objMessage?.imgInfoObj?.imgWidth as! NSString).floatValue))
                        
                        cell?.constrainHeightHost.constant = rowHeight
                        if let anUrl = objMessage?.imgInfoObj?.imgIfUrl {
                            cell?.imageHostSend.setImageWith(URL(string: "\(URL_FILE)\(anUrl)"), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
                            })
                        }
                    } else {
                        cell?.btnClickFileHost.isHidden = false
                        cell?.btnClickFileHost.setTitle(objMessage?.content, for: .normal)
                        cell?.btnClickFileHost.underline()
                    }
                }
            }
        } else {
            cell?.viewContainImgGuess.isHidden = false
            if !(indexPath.row == 0) {
                let objLastMessage = arrComment[indexPath.row - 1] as? MessageObj
                cell?.viewContainImgGuess.isHidden = (objMessage?.senderId == objLastMessage?.senderId) ? true : false
            }
            cell?.lblMessage.textAlignment = .left
            cell?.stackViewGuess.isHidden = false
            cell?.lblMessage.backgroundColor = Helper.COLOR_BG_MESSAGE_GUESS
            let date = Date(timeIntervalSince1970: objMessage?.dateCreate ?? 0.0)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy HH:mm"
            cell?.lblDatePostGuess.text = formatter.string(from: date)
            cell?.imgGuess.setImageWith(URL(string: seller?.usImage ?? ""), placeholderImage: Helper.IMAGE_HODER)
            if objMessage?.imgInfoObj?.imgIfUrl?.count == 0 {
                cell?.lblMessage.isHidden = false
                cell?.lblMessage.text = objMessage?.content
            } else {
                let arrType = objMessage?.imgInfoObj?.imgIfUrl?.components(separatedBy: ".")
                if (arrType?.count ?? 0) > 0 {
                    if (arrType?.last == "jpg") || (arrType?.last == "JPG") || (arrType?.last == "PNG") || (arrType?.last == "png") || (arrType?.last == "gif") || (arrType?.last == "GIF") {
                        cell?.viewGuessSendImage.isHidden = false
                        
                        var rowHeight: CGFloat = 0.0
                        if let imgHeight = objMessage?.imgInfoObj?.imgHeight?.floatValue , let imgWidth = objMessage?.imgInfoObj?.imgWidth?.floatValue {
                            rowHeight = CGFloat( CGFloat(imgHeight) * ((cell?.imageHostSend.bounds.size.width)! / CGFloat(imgWidth) ))
                            
                        }
                        cell?.constrainHeightImgGuess.constant = rowHeight
                        if let anUrl = objMessage?.imgInfoObj?.imgIfUrl {
                            cell?.imageGuessSend.setImageWith(URL(string: "\(URL_FILE)\(anUrl)"), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
                            })
                        }
                    } else {
                        cell?.btnClickFileGuess.isHidden = false
                        cell?.btnClickFileGuess.setTitle(objMessage?.content, for: .normal)
                        cell?.btnClickFileGuess.underline()
                    }
                }
            }
        }
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    // MARK: - click file button delegate
    func clickButtom(at index: Int, identifier: String?) {
        let msgobj = arrComment[index] as? MessageObj
        if (identifier == "file") {
            if let anUrl = msgobj?.imgInfoObj?.imgIfUrl, let anUrl1 = URL(string: "\(URL_FILE)\(anUrl)") {
                UIApplication.shared.openURL(anUrl1)
            }
        } else {
            let imgVC = ImageViewController(nibName: "ImageViewController", bundle: nil)
            if let anUrl = msgobj?.imgInfoObj?.imgIfUrl {
                imgVC.strURL = "\(URL_FILE)\(anUrl)"
            }
            present(imgVC, animated: true) {() -> Void in }
        }
    }
    
    func updateStatus(inOutViewController status: String?) {
        if conversationId.count > 0 {
            if let anId = seller?.usId, let status = status {
                Database.database().reference().child("user/\(gUser.usId as String)/chatWith/\(anId)/\(conversationId)").updateChildValues(["status": status, "unread": "0"])
            }
        }
    }
    
    func isRowZeroVisible(_ index: IndexPath?) -> Bool {
        for indexThump: IndexPath? in tbvMessage.indexPathsForVisibleRows ?? [IndexPath?]() {
            if indexThump?.row == index?.row {
                return true
            }
        }
        return false
    }
    
    // MARK: - TextView Delegate
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text.count != 0 {
            btnSend.setImage(UIImage(named: "ic_send"), for: .normal)
            btnSend.tag = 2
            //is send text
        } else {
            btnSend.setImage(UIImage(named: "ic_add"), for: .normal)
            btnSend.tag = 1
            // is choose picture
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        tfComment.text = ""
        return true
    }
    
    // MARK: - Notification Center Registering/Unregistering
    func registerNotificationCenterHooks() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.applicationDidEnterBackgroundNotificationHandler(_:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.applicationWillEnterForegroundNotificationHandler(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    func unRegisterNotificationCenterHooks() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationWillEnterForegroundNotificationHandler(_ notification: Notification?) {
        updateStatus(inOutViewController: "1")
    }
    
    @objc func applicationDidEnterBackgroundNotificationHandler(_ notification: Notification?) {
        updateStatus(inOutViewController: "0")
    }
    
    func customTextss() {
        lblUploadPictures.text = "rg_lbl_upload_pictures".localized
        lblMessageUpload.text = "rg_lbl_message_upload".localized
        btnGallery.setTitle("rg_btn_gallery".localized, for: .normal)
        btnGallery.setTitle("rg_btn_camera", for: .normal)
        lblTitle.text = "ch_title".localized
    }
}
