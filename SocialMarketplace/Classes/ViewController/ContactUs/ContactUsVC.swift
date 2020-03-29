
//
//  SettingViewController.h
//  Real Ads
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//
//
//  SettingViewController.m
//  Real Ads
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tfType: JVFloatLabeledTextField!
    @IBOutlet weak var tfSubject: JVFloatLabeledTextField!
    @IBOutlet weak var tvContent: JVFloatLabeledTextView!
    @IBOutlet weak var lblTitle: UILabel!
    @objc var strTitle = ""
    @objc var strContent = ""
    @IBOutlet weak var tpKeyboard: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var btnSubmit: UIButton!

    @IBOutlet weak var imgNaviBg: UIImageView!

    private var keyArray = [Any]()
    private var objectArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view from its nib.
        //    [_tpKeyboard contentSizeToFit];
        setupLayout()
        if (strTitle == CONTACT_REPORT_SELLER) || (strTitle == CONTACT_REPORT_ADS) {
            setupBackButton()
            tfSubject.text = strContent
            tfSubject.isEnabled = false
            tfType.text = "cu_text_report".localized
        } else {
            tfType.text = "cu_text_contact_us".localized
            setRevealBtn()
        }
        tfType.isEnabled = false
    }

    //-(void)viewDidLayoutSubviews{
    //    _tpKeyboard.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    //}
    func setupBackButton() {
        btnBack.setBackgroundImage(UIImage(named: "ic_back.png"), for: .normal)
        btnBack.addTarget(self, action: #selector(ContactUsVC.btnBackClick(_:)), for: .touchUpInside)
    }

    func setRevealBtn() {
        view.endEditing(true)
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        btnBack.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    func setupLayout() {
        lblTitle.text = "rv_menu_contact_us".localized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmitClick(_ sender: Any) {
        view.endEditing(true)
        if tfName.text?.count == 0 {
            view.makeToast("msg_input_name".localized, duration: 3.0, position: CSToastPositionCenter)
            return
        }
        if tfEmail.text?.count == 0 {
            view.makeToast("msg_input_email".localized, duration: 3.0, position: CSToastPositionCenter)
            return
        }
        if tfSubject.text?.count == 0 {
            view.makeToast("msg_input_subject".localized, duration: 3.0, position: CSToastPositionCenter)
            return
        }
        if tvContent.text.count == 0 {
            view.makeToast("msg_input_content".localized, duration: 3.0, position: CSToastPositionCenter)
            return
        }
        if Validator.validateEmail(tfEmail.text) {
            keyArray = ["name", "email", "type", "subject", "content"]
            var temp = ""
            if (strTitle == CONTACT_REPORT_ADS) || (strTitle == CONTACT_REPORT_SELLER) {
                temp = "2"
            } else {
                temp = "1"
            }
            MBProgressHUD.showAdded(to: view, animated: true)
            ModelManager.contactUsAction(withName: tfName.text, email: tfEmail.text, type: temp, subject: tfSubject.text, content: tvContent.text, withSuccess: {(_ strSuccess: String?) -> Void in
                self.view.makeToast("msg_success".localized, duration: 3.0, position: CSToastPositionCenter)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.clear()
            }, failure: {(_ err: String?) -> Void in
                self.view.makeToast(err, duration: 3.0, position: CSToastPositionCenter)
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            })
        } else {
            view.makeToast("msg_invalid".localized, duration: 3.0, position: CSToastPositionCenter)
            return
        }
    }

    func clear() {
        if (strTitle == "cu_text_report".localized) {
            tfName.text = ""
            tfEmail.text = ""
            tvContent.text = ""
        } else {
            tfName.text = ""
            tfEmail.text = ""
            tfSubject.text = ""
            tvContent.text = ""
        }
    }

    func text() {
        btnSubmit.setTitle("btn_send".localized, for: .normal)
        tfName.placeholder = "cu_tf_fullname".localized
        tfSubject.placeholder = "cu_tf_subject".localized
        tvContent.placeholder = "cu_tf_reason".localized
        tfEmail.placeholder = "cu_tf_email".localized
    }
}
