
//
//  MessagesDetailViewController.swift
//  Real Ads
//
//  Created by Mac on 5/14/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class MessagesDetailViewController: UIViewController, UITextFieldDelegate, UIKeyboardViewControllerDelegate {
    @IBOutlet var viewTittle: CBAutoScrollLabel!
    @IBOutlet var viewNamePhone: CBAutoScrollLabel!
    @IBOutlet var viewPhone: CBAutoScrollLabel!
    @IBOutlet var viewEmail: CBAutoScrollLabel!
    @IBOutlet var viewDate: CBAutoScrollLabel!
    @IBOutlet var avartar: UIImageView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var textViewContent: UITextView!
    var message: Messages?
    @IBOutlet var btnBookmark: UIButton!
    @IBOutlet var btnReply: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var viewDetailMess: UIView!
    var est: Ads?
    var arrBook = [Any]()

    @IBOutlet weak var imgNaviBg: UIImageView!
    @IBOutlet weak var message_detail: UILabel!

    var keyboard: UIKeyboardViewController?

    private var favoriteInt: Int = 0

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onBookmark(_ sender: Any) {
        //    NSMutableArray *arr = [Util objectForKey:@"Mark"];
        //    self.ArrBook = [[NSMutableArray alloc]init];
        //    for (NSObject *o in arr) {
        //        [self.ArrBook addObject:o];
        //    }
        ////    self.ArrBook = [Util objectForKey:@"Mark"];
        //    for (int i=0;i<self.ArrBook.count;i++) {
        //        NSString *ab = [self.ArrBook objectAtIndex:i];
        //        if ([ab isEqualToString:_message.MessageId]) {
        //            [self.ArrBook removeObject:ab];
        //            [Util setObject:self.ArrBook forKey:@"Mark"];
        //        }else{
        //            [self.ArrBook addObject:_message.MessageId];
        //            [Util setObject:self.ArrBook forKey:@"Mark"];
        //        }
        //    }
    }

    @IBAction func onReply(_ sender: Any) {
        var customURL: String? = nil
        if let anEmail = message?.email {
            customURL = "Mailto://\(anEmail)"
        }
        if let anURL = URL(string: customURL ?? "") {
            if UIApplication.shared.canOpenURL(anURL) {
                if let anURL = URL(string: customURL ?? "") {
                    UIApplication.shared.openURL(anURL)
                }
            } else {
                let alert = UIAlertView(title: "", message: Util.localized("alert_datail"), delegate: self as! UIAlertViewDelegate, cancelButtonTitle: "Ok", otherButtonTitles: "")
                alert.show()
            }
        }
    }

    @IBAction func onCall(_ sender: Any) {
        Util.callPhoneNumber(message?.phone)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        customText()
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        setdata()
        favoriteInt = 0
    }

    func setdata() {
        viewDetailMess.layer.cornerRadius = 6
        btnBookmark.layer.cornerRadius = 4
        viewTittle.text = message?.title
        viewTittle.font = UIFont.boldSystemFont(ofSize: 18)
        viewNamePhone.font = UIFont.boldSystemFont(ofSize: 18)
        viewEmail.font = UIFont.systemFont(ofSize: 14)
        viewEmail.textColor = UIColor.darkGray
        viewDate.font = UIFont.systemFont(ofSize: 14)
        viewDate.textColor = UIColor.darkGray
        viewPhone.font = UIFont.systemFont(ofSize: 14)
        viewPhone.textColor = UIColor.darkGray
        textViewContent.font = UIFont.systemFont(ofSize: 14)
        textViewContent.textColor = UIColor.darkGray
        if let aName = message?.name, let aPhone = message?.phone {
            viewNamePhone.text = "\(aName)(\(aPhone))"
        }
        textViewContent.text = message?.content ?? ""
        viewEmail.text = message?.email
        viewDate.text = Util.string(from: Date(timeIntervalSince1970: TimeInterval((message?.dateCreated?.doubleValue)!)), format: "dd MMM yyyy HH:mm")
        // self.Avartar.imageURL = [NSURL URLWithString:self.message.image];
        keyboard = UIKeyboardViewController(controllerDelegate: self)
        keyboard?.addToolbarToKeyboard()
        avartar.setImageWith(URL(string: message?.image ?? ""), placeholderImage: Helper.IMAGE_HODER)
        avartar.contentMode = .scaleAspectFill
        avartar.clipsToBounds = true
    }

    func customText() {
        message_detail.text = "dm_lbl_title".localized
        btnCall.setTitle("dm_btn_call".localized, for: .normal)
        btnReply.setTitle("dm_btn_email".localized, for: .normal)
    }
}
