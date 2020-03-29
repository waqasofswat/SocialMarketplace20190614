
//
//  Created by Mac on 5/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var sex = ""
    var imagePicker: UIImagePickerController!
    @IBOutlet var scollview: TPKeyboardAvoidingScrollView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtAddress: JVFloatLabeledTextField!
    @IBOutlet var txtSkype: UITextField!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var imgAvartar: UIImageView!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var viewUpImage: UIView!
    @IBOutlet var btnGallerty: UIButton!
    @IBOutlet weak var segmentGender: UISegmentedControl!
    @IBOutlet weak var segmentCompany: UISegmentedControl!
    @IBOutlet weak var segmentGenderHeight: NSLayoutConstraint!
    @IBOutlet weak var tfWebsite: JVFloatLabeledTextField!
    @IBOutlet weak var tvDescription: JVFloatLabeledTextView!
    
    @IBOutlet weak var lblMessageUpload: UILabel!
    @IBOutlet weak var lblUploadPictures: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNavi: UIImageView!
    @IBOutlet weak var btnReveal: UIButton!

    var female = false
    var male = false
    var isPrivate = false

    @IBAction func onRegister(_ sender: Any) {
        view.endEditing(true)
        if (txtEmail.text?.count ?? 0) == 0 || (txtName.text?.count ?? 0) == 0 || (txtAddress.text?.count ?? 0) == 0 || (txtPhone.text?.count ?? 0) == 0 || (txtSkype.text?.count ?? 0) == 0 || (tvDescription.text.count ) == 0 {
            view.makeToast("Some field is missing. Please fill all required field!", duration: 2.0, position: CSToastPositionCenter)
        } else {
            let imageData = UIImageJPEGRepresentation(self.imgAvartar.image!, 0.5)
            if segmentGender.selectedSegmentIndex == 0 {
                sex = "1"
            } else {
                sex = "0"
            }
            var individual = String()
            if segmentCompany.selectedSegmentIndex == 0 {
                individual = "0"
            } else {
                individual = "1"
                if (tfWebsite.text?.count ?? 0) == 0 {
                    view.makeToast("Website is missing. Please fill all required field!", duration: 2.0, position: CSToastPositionCenter)
                    return
                }
            }
            MBProgressHUD.showAdded(to: view, animated: true)
            ModelManager.editAccountInfo(withName: txtName.text, phone: txtPhone.text, address: txtAddress.text, sex: sex, skype: txtSkype.text, web: tfWebsite.text, individual: individual, description: tvDescription.text, dataImgAvatar: imageData, withSuccess: {(_ successStr: String?) -> Void in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.view.makeToast(successStr, duration: 2.0, position: CSToastPositionCenter)
            }, failure: {(_ err: String?) -> Void in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
            })
        }
    }

    @IBAction func onBack(_ sender: Any) {
    }

    @IBAction func onImage(_ sender: Any) {
        viewUpImage.isHidden = false
    }

    @IBAction func onGallery(_ sender: Any) {
        viewUpImage.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        if let aPicker = imagePicker {
            present(aPicker, animated: true) {() -> Void in }
        }
    }

    @IBAction func onCamera(_ sender: Any) {
        viewUpImage.isHidden = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
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
   
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        setRevealBtn()
        setupLayout()
        customText()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    func customText() {
        lblTitle.text = "rv_menu_my_account".localized
        segmentCompany.setTitle("rg_sm_personal".localized, forSegmentAt: 0)
        segmentCompany.setTitle("rg_sm_company".localized, forSegmentAt: 1)
        txtName.placeholder = "rg_tf_fullname".localized
        txtEmail.placeholder = "rg_tf_email".localized
        txtPhone.placeholder = "rg_tf_phone".localized
        txtAddress.placeholder = "rg_tf_address".localized
        tvDescription.placeholder = "rg_tf_description".localized
        txtSkype.placeholder = "rg_rf_skype".localized
        segmentGender.setTitle("rg_sm_male".localized, forSegmentAt: 0)
        segmentGender.setTitle("rg_sm_female".localized, forSegmentAt: 1)
        btnRegister.setTitle("ma_btn_update".localized, for: .normal)
        lblUploadPictures.text = "rg_lbl_upload_pictures".localized
        lblMessageUpload.text = "rg_lbl_message_upload".localized
        btnGallerty.setTitle("rg_btn_gallery".localized, for: .normal)
        btnCamera.setTitle("rg_btn_camera".localized, for: .normal)

    }

    func setupLayout() {
        txtEmail.allowsEditingTextAttributes = false
        view.backgroundColor = UIColor.white
        imgNavi.backgroundColor = Helper.COLOR_DARK_PR_MARY
        btnRegister.backgroundColor = Helper.COLOR_BTN_SMALL
        segmentCompany.tintColor = Helper.COLOR_SEGMENTTINT
        segmentGender.tintColor = Helper.COLOR_SEGMENTTINT
        btnGallerty.backgroundColor = Helper.COLOR_BTN_SMALL
        btnCamera.backgroundColor = Helper.COLOR_BTN_SMALL
        segmentGender.selectedSegmentIndex = 0
        tfWebsite.isHidden = true
        segmentGender.isHidden = false
        segmentCompany.selectedSegmentIndex = 0
        btnRegister.layer.cornerRadius = 4
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyAccountVC.doSingleTap(_:)))
        tap.numberOfTapsRequired = 1
        viewUpImage.addGestureRecognizer(tap)
        // self.ViewImage.hidden = YES;
        viewUpImage.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        // male = YES;
        sex = "1"
        imgAvartar.contentMode = .scaleAspectFill
        imgAvartar.clipsToBounds = true
        txtName.text = gUser.usName
        txtEmail.text = gUser.usEmail
        txtSkype.text = gUser.usSkype
        txtAddress.text = gUser.usAddress
        txtPhone.text = gUser.usPhone
        tfWebsite.text = gUser.usWebsite
        tvDescription.text = gUser.usDescription
        if (gUser.usIndividual == "0") {
            segmentCompany.selectedSegmentIndex = 0
            tfWebsite.isHidden = true
            segmentGender.isHidden = false
        } else {
            segmentCompany.selectedSegmentIndex = 1
            tfWebsite.isHidden = false
            segmentGender.isHidden = true
        }
        if (gUser.usSex == "0") {
            segmentGender.selectedSegmentIndex = 1
        } else {
            segmentGender.selectedSegmentIndex = 0
        }
        imgAvartar.setImageWith(URL(string: gUser.usImage), placeholderImage: Helper.IMAGE_HODER)
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        btnReveal.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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
}
