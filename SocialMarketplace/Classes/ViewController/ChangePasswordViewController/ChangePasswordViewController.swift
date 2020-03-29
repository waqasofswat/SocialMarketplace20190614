
//
//  ChangePasswordViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/23/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UIKeyboardViewControllerDelegate {
    @IBOutlet weak var revealBtn: UIButton!
    @IBOutlet var viewChange: UIView!
    @IBOutlet var txtCurrentPass: JVFloatLabeledTextField!
    @IBOutlet var txtNewPass: JVFloatLabeledTextField!
    @IBOutlet var txtCorfirmPass: JVFloatLabeledTextField!
    @IBOutlet var btnChangePass: UIButton!
    @IBOutlet weak var lbl_changeword: UILabel!

    @IBOutlet weak var imgNaviBg: UIImageView!
    @IBOutlet weak var lblCheckPassWhenLoginFB: UILabel!

    private var keyboard: UIKeyboardViewController?

    @IBAction func onChangePass(_ sender: Any) {
        if (txtCurrentPass.text?.count)! > 0 {
            if (txtNewPass.text?.count)! > 0 {
                if (txtCorfirmPass.text == txtNewPass.text) {
                    MBProgressHUD.showAdded(to: view, animated: true)
                    ModelManager.changePassword(withUserId: gUser.usId, currentPass: txtCurrentPass.text, newPass: txtNewPass.text, withSuccess: {(_ success: String?) -> Void in
                        Util.setObject(self.txtNewPass.text, forKey: "password")
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.view.makeToast(success, duration: 2.0, position: CSToastPositionCenter)
                    }, failure: {(_ error: String?) -> Void in
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.view.makeToast(error, duration: 2.0, position: CSToastPositionCenter)
                    })
                } else {
                    view.makeToast("cp_msg_pass_notmatch".localized, duration: 3.0, position: CSToastPositionCenter)
                }
            } else {
                view.makeToast("cp_msg_fill_new_pass".localized, duration: 3.0, position: CSToastPositionCenter)
            }
        } else {
            view.makeToast("cp_msg_fill_pass".localized, duration: 3.0, position: CSToastPositionCenter)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        view.backgroundColor = UIColor.white
        setRevealBtn()
        layoutView()
        keyboard = UIKeyboardViewController(controllerDelegate: self)
        keyboard?.addToolbarToKeyboard()
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    func layoutView() {
        let loginType = Util.string(forKey: KEY_LOGIN) as? String
        if (loginType == "1") {
            viewChange.isHidden = false
            lblCheckPassWhenLoginFB.isHidden = true
        } else {
            viewChange.isHidden = true
            lblCheckPassWhenLoginFB.isHidden = false
            lblCheckPassWhenLoginFB.text = "cp_msg_pass_fb".localized
        }
        viewChange.layer.cornerRadius = 6
    }

    func text() {
        lbl_changeword.text = "rv_menu_change_password".localized
        btnChangePass.setTitle("cp_btn_change_pass".localized, for: .normal)
        txtCurrentPass.placeholder = "cp_tf_current_pass".localized
        txtNewPass.placeholder = "cp_tf_new_pass".localized
        txtCorfirmPass.placeholder = "cp_tf_confirm_pass".localized
    }
}
