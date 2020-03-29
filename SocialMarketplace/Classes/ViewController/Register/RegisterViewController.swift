
//
//  RegisterViewController.swift
//  Real Ads
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var sex: String?
    var imagePicker: UIImagePickerController?
    var libraryPopover: UIPopoverController?
    @IBOutlet var scollview: TPKeyboardAvoidingScrollView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtAddress: JVFloatLabeledTextField!
    @IBOutlet var txtSkype: UITextField!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var txtConfirmPass: UITextField!
    @IBOutlet var imgAvartar: UIImageView!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var viewUpImage: UIView!
    @IBOutlet var btnGallerty: UIButton!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    @IBOutlet weak var segmentCompany: UISegmentedControl!
    @IBOutlet weak var segmentGenderHeight: NSLayoutConstraint!
    @IBOutlet weak var tfWebsite: JVFloatLabeledTextField!
    @IBOutlet weak var tvDescription: JVFloatLabeledTextView!

    @IBOutlet weak var imgNavi: UIImageView!
    @IBOutlet weak var lblMessageUpload: UILabel!
    @IBOutlet weak var lblUploadPictures: UILabel!
    @IBOutlet weak var lbl_regisster: UILabel!

    var female = false
    var male = false
    var isPrivate = false

    @IBAction func onRegister(_ sender: Any) {
        view.endEditing(true)
        if (txtEmail.text?.count ?? 0) == 0 || (txtName.text?.count ?? 0) == 0 || (txtAddress.text?.count ?? 0) == 0 || (txtPhone.text?.count ?? 0) == 0 || (txtSkype.text?.count ?? 0) == 0 || (txtUsername.text?.count ?? 0) == 0 || (txtPassword.text?.count ?? 0) == 0 || (tvDescription?.text.count ?? 0) == 0 {
            view.makeToast("msg_some_field_mising".localized, duration: 2.0, position: CSToastPositionCenter)
        } else {
            if (txtPassword.text == txtConfirmPass.text) {
                let imageData = UIImageJPEGRepresentation(self.imgAvartar.image!, 0.5)
                if segmentGender.selectedSegmentIndex == 0 {
                    sex = "1"
                } else {
                    sex = "0"
                }
                MBProgressHUD.showAdded(to: view, animated: true)
                ModelManager.registerAccount(withUsername: txtUsername.text, password: txtPassword.text, email: txtEmail.text, name: txtName.text, phone: txtPhone.text, address: txtAddress.text, sex: sex, skype: txtSkype.text, web: tfWebsite.text, individual: "\(segmentCompany.selectedSegmentIndex)", description: tvDescription.text, dataImgAvatar: imageData, withSuccess: {(_ successStr: String?) -> Void in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    self.view.makeToast(successStr, duration: 2.0, position: CSToastPositionCenter)
                }, failure: {(_ err: String?) -> Void in
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
                })
            } else {
                view.makeToast("msg_pass_not_match".localized, duration: 2.0, position: CSToastPositionCenter)
            }
        }
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onImage(_ sender: Any) {
        viewUpImage.isHidden = false
    }

    @IBAction func onGallery(_ sender: Any) {
        viewUpImage.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .savedPhotosAlbum
        if let aPicker = imagePicker {
            present(aPicker, animated: true) {() -> Void in }
        }
    }

    @IBAction func onCamera(_ sender: Any) {
        viewUpImage.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .camera
        imagePicker?.showsCameraControls = true
        let image = UIImage(named: "bg_camera.png")
        let imgView = UIImageView(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        imagePicker?.cameraOverlayView = imgView
        if let aPicker = imagePicker {
            present(aPicker, animated: true) {() -> Void in }
        }
        UIApplication.shared.isStatusBarHidden = true
    }

    override func viewDidLoad() {
        settext()
        super.viewDidLoad()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

    func setupLayout() {
        view.backgroundColor = UIColor.white
        imgNavi.backgroundColor = Helper.COLOR_DARK_PR_MARY
        segmentCompany.tintColor = Helper.COLOR_SEGMENTTINT
        segmentGender.tintColor = Helper.COLOR_SEGMENTTINT
        segmentGender.selectedSegmentIndex = 0
        tfWebsite.isHidden = true
        segmentGender.isHidden = false
        segmentCompany.selectedSegmentIndex = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.doSingleTap(_:)))
        tap.numberOfTapsRequired = 1
        viewUpImage.addGestureRecognizer(tap)
        // self.ViewImage.hidden = YES;
        viewUpImage.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        // male = YES;
        sex = "1"
        imgAvartar.contentMode = .scaleAspectFill
        imgAvartar.clipsToBounds = true
    }

    @objc func doSingleTap(_ gesture: UIGestureRecognizer?) {
        viewUpImage.isHidden = true
    }

// MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            navigationController?.popViewController(animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePicker?.dismiss(animated: true) {() -> Void in }
        imgAvartar.image = image
    }

    //  On cancel, only dismiss the picker controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true) {() -> Void in }
    }

    @IBAction func segmentCompanyChanged(_ sender: Any) {
        if segmentCompany.selectedSegmentIndex == 0 {
            tfWebsite.isHidden = true
            segmentGender.isHidden = false
        } else {
            tfWebsite.isHidden = false
            segmentGender.isHidden = true
        }
    }

    func settext() {
        
        btnGallerty.setTitle("rg_btn_gallery".localized, for: .normal)
        btnCamera.setTitle("rg_btn_camera".localized, for: .normal)
        lblMessageUpload.text = "rg_lbl_message_upload".localized
        lblUploadPictures.text = "rg_lbl_upload_pictures".localized
        txtUsername.placeholder = "rg_tf_username".localized
        txtPassword.placeholder = "rg_tf_password".localized
        txtConfirmPass.placeholder = "rg_tf_retype_password".localized
        tvDescription.placeholder = "rg_tf_description".localized
        txtPhone.placeholder = "rg_tf_phone".localized
        txtAddress.placeholder = "rg_tf_address".localized
        txtSkype.placeholder = "rg_rf_skype".localized
        
        txtName.placeholder = "rg_tf_fullname".localized
        segmentGender.setTitle("rg_sm_male".localized , forSegmentAt: 0)
        segmentGender.setTitle("rg_sm_female".localized , forSegmentAt: 1)
        btnRegister.setTitle("btn_register".localized , for: .normal)
        
        lbl_regisster.text = "rg_title_register".localized
        segmentCompany.setTitle("rg_sm_personal".localized , forSegmentAt: 0)
        segmentCompany.setTitle("rg_sm_company".localized , forSegmentAt: 1)
        txtEmail.placeholder = "rg_tf_email".localized
        btnRegister.setTitle("rg_btn_register".localized, for: .normal)
        
    }
}
