
//
//  SeachViewController.h
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 2016 TuanVN. All rights reserved.
//

import AssetsLibrary
import UIKit
import GoogleMaps

class AddNewAdsVC: UIViewController, RBImagePickerDataSource, RBImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate, SearchOptionsViewControllerDelegate, SearchDateViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MapVCDelegate {
    var imagepicker: RBImagePickerController?
    @IBOutlet weak var btnSave: UIButton!
    var imagePic: UIImagePickerController?
    @IBOutlet weak var btnIsAvailable: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblNagotiable: UILabel!
    @IBOutlet weak var lblCustom: UILabel!
    @IBOutlet weak var lblAbailable: UILabel!

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var segmentControler: UISegmentedControl!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoriesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var vTopNavi: UIView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLng: UITextField!
    @IBOutlet weak var collectionGalleryView: UICollectionView!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfUnit: UITextField!
    @IBOutlet weak var tvContent: JVFloatLabeledTextView!
    @IBOutlet weak var btnFreeType: UIButton!
    @IBOutlet weak var btnNegotile: UIButton!
    @IBOutlet weak var btnCustom: UIButton!
    @IBOutlet weak var btnSelectLocationFromMap: DButtonAcviewDefault!
    
    private var selectedType = ""
    private var catParentId = ""
    private var catSubId = ""
    private var cityId = ""
    private var companyType = ""
    private var beforeOrAfter = ""
    private var selectedDate: Date?
    private var textSearch = ""
    private var arrAllCategories = [Any]()
    private var arrCities = [Any]()
    private var arrParentCategories = [Any]()
    private var arrSubCategories = [Any]()
    private var arrUrlGallery = [Any]()
    private var arrDataGallery = [Any]()
    private var priceType = ""
    private var forRent = ""
    private var forSale = ""
    private var isSelectedAvatar = false
    
    let SELECT_PARENT_CATEGORY = "PARENT_CATEGORY"
    let SELECT_SUB_CATEGORY = "SUB_CATEGORY"
    let SELECT_CITY = "SELECT_CITY"
    let SELECT_COMPANY = "SELECT_COMPANY"
    let SELECT_DATE_TYPE = "SELECT_DATE_TYPE"
    let PRICE_FREE = "1"
    let PRICE_NEGO = "2"
    let PRICE_CUSTOM = "3"
    let FOR_RENT = 1
    let FOR_BUY = 0

   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!

   
    //pick image

    @IBAction func onAddImage(_ sender: Any) {
        showAlertChoseCameraOrGallery()
    }

    @IBAction func onAddGallery(_ sender: Any) {
        if let anImagepicker = imagepicker {
            present(anImagepicker, animated: true) {() -> Void in }
        }
    }

    @IBAction func onSelect(fromMap sender: Any) {
        let mapVC = MapVC(nibName: "MapVC", bundle: nil)
        mapVC.delegate = self
        if (tfLat.text?.count ?? 0) > 0 && (tfLng.text?.count ?? 0) > 0 {
            let maker = GMSMarker(position: CLLocationCoordinate2DMake(Double(tfLat.text ?? "") ?? 0.0, Double(tfLng.text ?? "") ?? 0.0))
            mapVC.locationMarker = maker
        }
        navigationController?.pushViewController(mapVC, animated: true)
    }

// MARK:: MapVC delegate
    func didSelectLocation(_ newLocation: CLLocationCoordinate2D) {
        tfLng.text = "\(newLocation.longitude)"
        tfLat.text = "\(newLocation.latitude)"
    }

    func showAlertChoseCameraOrGallery() {
        let alertController = UIAlertController(title: "rg_lbl_upload_pictures".localized, message: "rg_lbl_message_upload".localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "rg_btn_camera".localized, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            self.imagePic = UIImagePickerController()
            self.imagePic?.delegate = self
            self.imagePic?.allowsEditing = true
            self.imagePic?.sourceType = .camera
            self.imagePic?.showsCameraControls = true
            let image = UIImage(named: "bg_camera.png")
            let imgView = UIImageView(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 9 / 16))
            imgView.image = image
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            self.imagePic?.cameraOverlayView = imgView
            if let aPic = self.imagePic {
                self.present(aPic, animated: true) {() -> Void in }
            }
        }))
        alertController.addAction(UIAlertAction(title: "rg_btn_gallery".localized, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            self.imagePic = UIImagePickerController()
            self.imagePic?.delegate = self
            self.imagePic?.sourceType = .savedPhotosAlbum
            if let aPic = self.imagePic {
                self.present(aPic, animated: true) {() -> Void in }
            }
        }))
        alertController.addAction(UIAlertAction(title: "btn_cancel".localized, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            self.closeAlertview()
        }))
        DispatchQueue.main.async(execute: {() -> Void in
            self.present(alertController, animated: true) {() -> Void in }
        })
    }

    @IBAction func onIsAvailable(_ sender: Any) {
        btnIsAvailable.isSelected = !btnIsAvailable.isSelected
    }

    @IBAction func onFreeType(_ sender: Any) {
        btnFreeType.isSelected = true
        btnCustom.isSelected = false
        btnNegotile.isSelected = false
        tfUnit.isEnabled = false
        tfPrice.isEnabled = false
        priceType = PRICE_FREE
    }

    @IBAction func onNegotileType(_ sender: Any) {
        btnFreeType.isSelected = false
        btnCustom.isSelected = false
        btnNegotile.isSelected = true
        tfUnit.isEnabled = false
        tfPrice.isEnabled = false
        priceType = PRICE_NEGO
    }

    @IBAction func onCustomType(_ sender: Any) {
        btnFreeType.isSelected = false
        btnCustom.isSelected = true
        btnNegotile.isSelected = false
        tfUnit.isEnabled = true
        tfPrice.isEnabled = true
        priceType = PRICE_CUSTOM
    }

    @IBAction func onSave(_ sender: Any) {
        if (tfTitle.text?.count ?? 0) == 0 {
            view.makeToast("na_msg_fill_title_ads".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if tvContent.text.count == 0 {
            view.makeToast("na_msg_fill_des".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if arrUrlGallery.count == 0 {
            view.makeToast("na_msg_select_gallery".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if !isSelectedAvatar {
            view.makeToast("na_msg_select_image".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if (catParentId == "") {
            view.makeToast("na_msg_select_category".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if (catSubId == "") {
            view.makeToast("na_msg_select_sub_category".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if (cityId == "") {
            view.makeToast("na_msg_select_city".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        if (priceType == PRICE_CUSTOM) {
            if (tfPrice.text?.count ?? 0) == 0 || (tfUnit.text?.count ?? 0) == 0 {
                view.makeToast("na_msg_fill_unit".localized, duration: 2.0, position: CSToastPositionCenter)
                return
            }
        }
        let imgAvatarData = UIImageJPEGRepresentation(self.imgImage.image!, 0.5)
        if segmentControler.selectedSegmentIndex == FOR_BUY {
            forRent = "0"
            forSale = "1"
        } else {
            forSale = "0"
            forRent = "1"
        }
        view.endEditing(true)
        var isAvailable = ""
        if btnIsAvailable.isSelected {
            isAvailable = "1"
        } else {
            isAvailable = "0"
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        
        print("title ",tfTitle.text ??  "value"," uid ",gUser.usId,priceType,forRent,forSale,catParentId,catSubId,cityId)
        ModelManager.addAds(withTitle: tfTitle.text ?? "null", description: tvContent.text ?? "null", price: priceType , price_value: Validator.getSafeString(tfPrice.text ?? "null"), price_unit: Validator.getSafeString(tfUnit.text ?? "null"), forRent: forRent , forSale: forSale, accountId: gUser.usId ?? "null", categoryId: catParentId , subCate: catSubId , city: cityId , dataImgAvatar: imgAvatarData, dataGallery: arrUrlGallery, isAvailable: isAvailable , lat: Validator.getSafeString(tfLat.text), lng: Validator.getSafeString(tfLng.text), withSuccess: {(_ successStr: String?) -> Void in
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.view.makeToast("na_msg_add_success".localized, duration: 2.0, position: CSToastPositionCenter)
            let detail = MyAdsVC(nibName: "MyAdsVC", bundle: nil)
           self.revealViewController().pushFrontViewController(detail, animated: true)
        
        }
            , failure: {(_ err: String?) -> Void in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
         if err != nil{
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
         }else{
            self.view.makeToast("Have some error")
         }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customText()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

      
        //register Nib gallery colllectionview cell
        view.backgroundColor = UIColor.white
        collectionGalleryView.register(UINib(nibName: "Detailsadscollectioncalling2", bundle: nil), forCellWithReuseIdentifier: "DetailAdsCollectionCellImgcell")
        imgImage.contentMode = .scaleAspectFill
        imgImage.clipsToBounds = true
        segmentControler.selectedSegmentIndex = FOR_BUY
        arrAllCategories = [Any]()
        arrCities = [Any]()
        arrParentCategories = [Any]()
        arrSubCategories = [Any]()
        arrUrlGallery = [Any]()
        arrDataGallery = [Any]()
        let cityObj = CityObj()
        cityObj.cityId = ""
        cityObj.cityName = "text_all_cities".localized
        arrCities.append(cityObj)
        cityId = ""
        let categoryAllObj = CategoryPr()
        categoryAllObj.categoryId = ""
        categoryAllObj.categoryName = "text_all_category".localized
        arrParentCategories.append(categoryAllObj)
        catParentId = ""
        let categoryAllObj1 = CategoryPr()
        categoryAllObj1.categoryId = ""
        categoryAllObj1.categoryName = "text_all_sub_category".localized
        arrSubCategories.append(categoryAllObj1)
        catSubId = ""
        imagepicker = RBImagePickerController()
        imagepicker?.delegate = self
        imagepicker?.dataSource = self
        imagepicker?.selectionType = RBMultipleImageSelectionType
        imagepicker?.title = "rg_btn_gallery".localized
        imagepicker?.navigationController?.navigationItem.leftBarButtonItem?.title = "no"
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.initData), userInfo: nil, repeats: false)
        setupView()
    }

    @objc func initData() {
        ModelManager.getlistCity(success: {(_ arrCity: [Any]?) -> Void in
            if self.arrCities.count < 2 {
                if let aCity = arrCity {
                    self.arrCities.append(contentsOf: aCity)
                }
            }
        }, failure: {(_ error: String?) -> Void in
        })
        ModelManager.getListCategory(success: {(_ arrCategory: [Any]?) -> Void in
            if self.arrAllCategories.count < 2 {
                if let aCategory = arrCategory {
                    self.arrAllCategories = self.arrAllCategories + aCategory
                }
                for cateObj in (self.arrAllCategories as? [CategoryPr])! {
                    if (Validator.getSafeString(cateObj.categoryParentId) == "0") {
                        self.arrParentCategories.append(cateObj)
                    }
                }
            }
        }, failure: {(_ err: String?) -> Void in
        })
    }
    func customText(){
        lblTitle.text = "rv_menu_new_ad".localized
        tfTitle.placeholder = "na_tf_title_ads".localized
        categoryLabel.text = "text_all_category".localized
        subCategoriesLabel.text = "text_all_sub_category".localized
        cityLabel.text = "text_all_cities".localized
        tfLat.placeholder = "na_tf_lat".localized
        tfLng.placeholder = "na_tf_long".localized
    btnSelectLocationFromMap.setTitle("na_btn_select_location".localized, for: .normal)
        segmentControler.setTitle("na_btn_for_buy".localized, forSegmentAt: 0)
        segmentControler.setTitle("na_btn_for_rent".localized, forSegmentAt: 1)
        lblFree.text = "na_lbl_free".localized
        lblNagotiable.text = "na_lbl_negotiale".localized
        lblCustom.text = "na_lbl_custom".localized
        tfPrice.placeholder = "na_tf_price".localized
        tfUnit.placeholder = "na_tf_unit".localized
        lblAbailable.text = "na_lbl_available".localized
        tvContent.placeholder = "na_tf_description".localized
        btnSave.setTitle("na_btn_save".localized, for: .normal)
        
    }

    func setupView() {
        vTopNavi.backgroundColor = Helper.COLOR_DARK_PR_MARY
        segmentControler.tintColor = Helper.COLOR_SEGMENTTINT
        btnFreeType.isSelected = true
        btnCustom.isSelected = false
        btnNegotile.isSelected = false
        tfUnit.isEnabled = false
        tfPrice.isEnabled = false
        priceType = PRICE_FREE
        
    }

    @IBAction func actionCategory(_ sender: Any) {
        if arrParentCategories.count < 2 {
            view.makeToast("msg_try_again".localized, duration: 1.5, position: CSToastPositionCenter)
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.initData), userInfo: nil, repeats: false)
        } else {
            var arrCatName = [Any]()
            for cateObj in (arrParentCategories as? [CategoryPr])! {
                arrCatName.append(Validator.getSafeString(cateObj.categoryName))
            }
            let controller = SearchOptionsViewController(nibName: "SearchOptionsViewController", bundle: nil)
            controller.delegate = self
            controller.searchOption = SELECT_PARENT_CATEGORY
            if arrParentCategories.count > 0 {
                controller.arrayItems = arrCatName
            }
            controller.present(inParentViewController: self)
        }
    }

    @IBAction func subCategory(_ sender: Any) {
        if catParentId == "" {
            view.makeToast("msg_select_category_first".localized, duration: 2.0, position: CSToastPositionCenter)
            return
        }
        arrSubCategories.removeAll()
        let categoryAllObj = CategoryPr()
        categoryAllObj.categoryId = ""
        categoryAllObj.categoryName = "text_all_sub_category".localized
        arrSubCategories.append(categoryAllObj)
        var arrName = [Any]()
        arrName.append(categoryAllObj.categoryName)
        let controller = SearchOptionsViewController(nibName: "SearchOptionsViewController", bundle: nil)
        controller.delegate = self
        controller.searchOption = SELECT_SUB_CATEGORY
        if (catParentId == "") {
            for cateObj in (arrAllCategories as? [CategoryPr])! {
                if !(cateObj.categoryParentId == "0") {
                    arrSubCategories.append(cateObj)
                    arrName.append(cateObj.categoryName)
                }
            }
        } else {
            for cateObj in (arrAllCategories as? [CategoryPr])! {
                if (cateObj.categoryParentId == catParentId) {
                    arrSubCategories.append(cateObj)
                    arrName.append(cateObj.categoryName)
                }
            }
        }
        controller.arrayItems = arrName
        controller.present(inParentViewController: self)
    }

    @IBAction func actionCity(_ sender: Any) {
        if arrCities.count < 2 {
            view.makeToast("msg_try_again".localized, duration: 1.5, position: CSToastPositionCenter)
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.initData), userInfo: nil, repeats: false)
        } else {
            let controller = SearchOptionsViewController(nibName: "SearchOptionsViewController", bundle: nil)
            controller.delegate = self
            controller.searchOption = SELECT_CITY
            var arrName = [Any]()
            for city in (arrCities as? [CityObj])! {
                arrName.append(Validator.getSafeString(city.cityName))
            }
            controller.arrayItems = arrName
            controller.present(inParentViewController: self)
        }
    }

    @IBAction func toggleMenu(_ sender: Any) {
        revealViewController().revealToggle(sender)
    }

// MARK: ==> delegate dropdown list
    func searchOptionsViewControllerDidSelectedItem(_ rowSelected: Int, forOption option: String?) {
        if (option == SELECT_PARENT_CATEGORY) {
            let cateSelected = arrParentCategories[rowSelected] as? CategoryPr
            categoryLabel.text = cateSelected?.categoryName
            catParentId = cateSelected?.categoryId ?? ""
            subCategoriesLabel.text = "text_all_sub_category".localized
            catSubId = ""
            return
        }
        if (option == SELECT_SUB_CATEGORY) {
            let cateSelected = arrSubCategories[rowSelected] as? CategoryPr
            subCategoriesLabel.text = cateSelected?.categoryName
            catSubId = cateSelected?.categoryId ?? ""
            return
        }
        if (option == SELECT_CITY) {
            let cityObj = arrCities[rowSelected] as? CityObj
            cityLabel.text = cityObj?.cityName
            cityId = cityObj?.cityId ?? ""
            return
        }
    }

    func searchDateViewControllerDidSelectedDate(_ item: Date?) {
        selectedDate = item
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textSearch = textField.text ?? ""
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text
        let newText = (oldText as NSString?)?.replacingCharacters(in: range, with: string)
        textSearch = newText ?? ""
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

// MARK: ==> Collectionview gallery delegate and datasoure
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUrlGallery.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionGalleryView.frame.size.height * 16 / 9, height: collectionGalleryView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailAdsCollectionCellImgcell", for: indexPath) as? Detailsadscollectioncalling2
        if cell == nil {
            cell = Bundle.main.loadNibNamed("Detailsadscollectioncalling2", owner: self, options: nil)?[0] as? Detailsadscollectioncalling2
        }
            // [cell.imgInCell setImage:[UIImage imageWithData:(NSData*)arrDataGallery[indexPath.row]]];
        let a = arrUrlGallery[indexPath.row] as? URL
        let library = ALAssetsLibrary()
        if let anA = a {
            library.asset(for: anA, resultBlock: {(_ asset: ALAsset?) -> Void in
//                let copyOfOriginalImage = UIImage(cgImage: asset?.defaultRepresentation().fullScreenImage() as! CGImage, scale: 0.5, orientation: .up)
//                cell?.imgInCell.image = copyOfOriginalImage
                
                cell?.imagecell.image = UIImage(cgImage: (asset?.thumbnail().takeUnretainedValue())!)

            }, failureBlock: {(_ error: Error?) -> Void in
                // error handling
                print("failure-----")
            })
        }
        if let aCell = cell {
            return aCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "text_delete_pictures".localized, message: "msg_delete_pictures".localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "btn_ok".localized, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.arrUrlGallery.remove(at: indexPath.row)
                self.collectionGalleryView.reloadData()
            })
        }))
        alertController.addAction(UIAlertAction(title: "btn_cancel".localized, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            self.closeAlertview()
        }))
        DispatchQueue.main.async(execute: {() -> Void in
            self.present(alertController, animated: true) {() -> Void in }
        })
    }

    func closeAlertview() {
        dismiss(animated: true) {() -> Void in }
    }

// MARK: ==>uiimage picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePic?.dismiss(animated: true) {() -> Void in }
        imgImage.image = image
        isSelectedAvatar = true
    }

// MARK: =>RBpickerview delegate
    func imagePickerController(_ imagePicker: RBImagePickerController?, didFinishPickingImagesWithURL imageURLS: [Any]?) {
        if let anURLS = imageURLS {
            arrUrlGallery.append(contentsOf: anURLS)
        }
        for urlImg in imageURLS as! [URL] {
            var containt = "0"
            for urlOld in arrUrlGallery as! [URL] {
                if urlOld == urlImg {
                    containt = "1"
                    break
                }
            }
            if (containt == "0") {
                    arrUrlGallery.append(urlImg)
            }
        }
        collectionGalleryView.reloadData()
    }

    @nonobjc func imagePickerControllerDidCancel(_ imagePicker: UIImagePickerController) {
        imagePicker.dismiss(animated: true) {() -> Void in }
        imagePic?.dismiss(animated: true) {() -> Void in }
    }

    func imagePickerControllerMaxSelectionCount(_ imagePicker: RBImagePickerController?) -> Int {
        return 8
    }

    func imagePickerControllerMinSelectionCount(_ imagePicker: RBImagePickerController?) -> Int {
        return 0
    }
}
