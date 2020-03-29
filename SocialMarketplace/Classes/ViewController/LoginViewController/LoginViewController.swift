
//  LoginViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/21/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class LoginViewController: UIViewController, UIKeyboardViewControllerDelegate, SWRevealViewControllerDelegate, UIAlertViewDelegate {
    @IBOutlet weak var lblForgotPassWord: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var lbl_tearms: UIButton!
    @IBOutlet weak var btn_privacy: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var revealBtn: UIButton!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user: User?
    @IBOutlet weak var viewLogin: UIImageView!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var viewForgetpass: UIView!
    @IBOutlet var bgForgetPass: UIView!
    @IBOutlet var btnOKForgot: UIButton!
    @IBOutlet var txtEmailForot: JVFloatLabeledTextField!
    @IBOutlet weak var lblLogin: UILabel!

    @IBOutlet weak var imgNaviBg: UIImageView!

    var keyboard: UIKeyboardViewController?

    private var remember: Int = 0
    private var keyArray = [Any]()
    private var objectArray = [Any]()

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onLogin(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if (emailTextField.text?.count ?? 0) == 0 || (passwordTextField.text?.count ?? 0) == 0 {
            view.makeToast(Util.localized("msg_some_field_mising".localized), duration: 2.0, position: CSToastPositionCenter)
        } else {
            MBProgressHUD.showAdded(to: view, animated: true)
            ModelManager.loginbyDefault(withUserName: emailTextField.text, password: passwordTextField.text, withSuccess: {(_ userInfo: Any?) -> Void in
                //To do
//                login_already = "1"
                //
                gUser = userInfo as! User
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getListBookMark), userInfo: nil, repeats: false)
                Util.saveObject(withEncode: gUser, forkey: KEY_SAVE_gUSER)
                Util.setObject("1", forKey: KEY_LOGIN)
                Util.setObject(self.passwordTextField.text, forKey: "password")
                let frontController = HomeVC(nibName: "HomeVC", bundle: nil)
                let rearViewController = RevealViewController(nibName: "RevealViewController", bundle: nil)
                let naviVC = UINavigationController(rootViewController: frontController)
                naviVC.setNavigationBarHidden(true, animated: false)
                let mainRevealController = SWRevealViewController(rearViewController: rearViewController, frontViewController: naviVC)
                mainRevealController?.rearViewRevealWidth = self.view.frame.size.width * 3 / 4
                mainRevealController?.rearViewRevealOverdraw = 0
                mainRevealController?.bounceBackOnOverdraw = false
                mainRevealController?.stableDragOnOverdraw = true
                mainRevealController?.frontViewPosition = FrontViewPositionLeft
                mainRevealController?.delegate = self
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.navigationController?.pushViewController(mainRevealController!, animated: true)
            }, failure: {(_ err: String?) -> Void in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
            })
        }
    }


    @IBAction func onRegister(_ sender: Any) {
        let regis = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        navigationController?.pushViewController(regis, animated: true)
    }

    @IBAction func onForgetPass(_ sender: Any) {
        view.endEditing(true)
        view.addSubview(viewForgetpass)
    }

    @IBAction func onOkForgotPass(_ sender: Any) {
        if Validator.validateEmail(txtEmailForot.text) {
            viewForgetpass.removeFromSuperview()
            MBProgressHUD.showAdded(to: view, animated: true)
            ModelManager.forgotPassword(withEmail: txtEmailForot.text, withSuccess: {(_ successStr: String?) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
               Util.showMessage("msg_forgot_success".localized, withTitle: APP_NAME)
//                let alert = UIAlertView(title: "", message: "msg_forgot_success".localized, delegate: self, cancelButtonTitle: "btn_ok".localized, otherButtonTitles: "")
//                alert.tag = 10
//                alert.show()
            }, failure: {(_ err: String?) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
            })
        } else {
            view.makeToast("msg_invalid".localized, duration: 2.0, position: CSToastPositionCenter)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        view.backgroundColor = UIColor.white
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        // Do any additional setup after loading the view from its nib.
        remember = 1
        keyboard = UIKeyboardViewController(controllerDelegate: self)
        keyboard?.addToolbarToKeyboard()
        layoutView()
        setRevealBtn()
        user = User()
        keyArray = [Any]()
        objectArray = [Any]()
        keyArray = ["user", "pass"]
            //    self.emailTextField.text = [Util objectForKey:@"email"];
            //    self.passwordTextField.text = [Util objectForKey:@"pass"];
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.doSingleTap(_:)))
        tap.numberOfTapsRequired = 1
        viewForgetpass.addGestureRecognizer(tap)
        viewForgetpass.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewForgetpass.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }

    @objc func doSingleTap(_ gesture: UIGestureRecognizer?) {
        viewForgetpass.removeFromSuperview()
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onRemember(_ sender: Any) {
        if remember == 1 {
            checkImg.isHidden = true
            remember = 0
        } else {
            checkImg.isHidden = false
            remember = 1
        }
    }

    func layoutView() {
        Util.borderAndcornerButtonwith(5.0, andBorder: 0.0, andColor: nil, with: btnRegister)
        Util.borderAndcornerButtonwith(5.0, andBorder: 0.0, andColor: nil, with: loginBtn)
    }

    @IBAction func onTearmAndConditions(_ sender: Any) {
        let vc = MoreFieldDrawMenu(nibName: "MoreFieldDrawMenu", bundle: nil)
        vc.strTitle = "lg_btn_tearm".localized
        vc.strBack = "YES"
        vc.strPresent = strTerm
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onPrivacy(_ sender: Any) {
        let vc = MoreFieldDrawMenu(nibName: "MoreFieldDrawMenu", bundle: nil)
        vc.strTitle = "lg_btn_privacy_policy".localized
        vc.strBack = "YES"
        vc.strPresent = strPrivacy
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func getListBookMark() {
        ModelManager.getBookmarksAds(byUserId: gUser.usId, andPage: "0", sortType: "", sortBy: "", withSuccess: {(_ dicReturn: [AnyHashable: Any]?) -> Void in
            
        }, failure: {(_ error: String?) -> Void in
            
        })
    }

    func text() {
        lblLogin.text = "lg_title_login".localized
        emailTextField.placeholder = "lg_tf_username".localized
        passwordTextField.placeholder = "lg_tf_password".localized
        btnForgot.setAttributedTitle("lg_btn_forgot".localized.attributedString, for: .normal)
        loginBtn.setTitle("lg_btn_login".localized, for: .normal)
        btnRegister.setTitle("lg_btn_register".localized, for: .normal)
        lbl_tearms.setAttributedTitle("lg_btn_tearm".localized.attributedString, for: .normal)
        btn_privacy.setAttributedTitle("lg_btn_privacy_policy".localized.attributedString, for: .normal)
        lblForgotPassWord.text = "lg_lbl_forgot_password".localized
        txtEmailForot.placeholder = "lg_tf_email_forgot".localized
        btnOKForgot.setTitle("lg_btn_ok_forgot".localized, for: .normal)
    }
}
