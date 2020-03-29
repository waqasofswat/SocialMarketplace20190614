
//  SeachViewController.swift
//  Real Estate
//
//  Created by Hicom on 2/20/16.
//  Copyright © 2016 TuanVN. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SeachViewController: UIViewController, UITextFieldDelegate, SearchOptionsViewControllerDelegate, SearchDateViewControllerDelegate {
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAll: UILabel!

    @IBOutlet weak var segmentControler: UISegmentedControl!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoriesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var vTopNavi: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var dateExtensionLabel: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    @IBOutlet weak var sliderDistance: UISlider!

    private var selectedType = ""
    private var catParentId = ""
    private var catSubId: String? = ""
    private var cityId = ""
    private var companyType = ""
    private var beforeOrAfter = ""
    private var selectedDate: Date?
    private var textSearch = ""
    private var arrAllCategories = [Any]()
    private var arrCities = [Any]()
    private var arrParentCategories = [Any]()
    private var arrSubCategories = [Any]()
    private var a = ""
    private var b = ""
    private var c = ""
       var bannerView: GADBannerView!
    let SELECT_PARENT_CATEGORY = "PARENT_CATEGORY"
    let SELECT_SUB_CATEGORY = "SUB_CATEGORY"
    let SELECT_CITY = "SELECT_CITY"
    let SELECT_COMPANY = "SELECT_COMPANY"
    let SELECT_DATE_TYPE = "SELECT_DATE_TYPE"
   @IBOutlet weak var constrainNaviHeight: NSLayoutConstraint!
   @IBOutlet weak var constrainPaddingTop: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        customTexts()
      if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896{
         constrainNaviHeight.constant = 88
         constrainPaddingTop.constant = 30
      }

        view.backgroundColor = UIColor.white
        segmentControler.selectedSegmentIndex = 0
        let cityObj = CityObj()
        cityObj.cityId = ""
        cityObj.cityName = "text_all_cities".localized
        arrCities.append(cityObj)
        let categoryAllObj = CategoryPr()
        categoryAllObj.categoryId = ""
        categoryAllObj.categoryName = "text_all_category".localized
        arrParentCategories.append(categoryAllObj)
        let categoryAllObj1 = CategoryPr()
        categoryAllObj1.categoryId = ""
        categoryAllObj1.categoryName = "text_all_sub_category".localized
        arrSubCategories.append(categoryAllObj1)
        selectedType = "se_btn_buy".localized
        dateExtensionLabel.text = "se_lbl_all".localized
        // textSearch = @"";
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.initData), userInfo: nil, repeats: false)
        setupView()
               // In this case, we instantiate the banner with desired ad size.
                 bannerView = GADBannerView(adSize: kGADAdSizeBanner)

               bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                        bannerView.rootViewController = self
               bannerView.load(GADRequest())
        addBannerViewToView(bannerView)

           }
           func addBannerViewToView(_ bannerView: GADBannerView) {
              bannerView.translatesAutoresizingMaskIntoConstraints = false
              view.addSubview(bannerView)
              view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
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

    func setupView() {
        vTopNavi.backgroundColor = Helper.COLOR_DARK_PR_MARY
        segmentControler.tintColor = Helper.COLOR_SEGMENTTINT
        sliderDistance.thumbTintColor = Helper.COLOR_SEGMENTTINT
        sliderDistance.tintColor = Helper.COLOR_SEGMENTTINT
        sliderChange(sliderDistance)
        categoryLabel.text = "text_all_category".localized
        subCategoriesLabel.text = "text_all_sub_category".localized
        cityLabel.text = "text_all_cities".localized
        companyLabel.text = "se_lbl_type".localized
        dateLabel.text = "se_lbl_all".localized
        // self.dateExtensionLabel.text = selectedDateEntension;
        // self.dateLabel.text = [self formatDate:selectedDate];
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

    @IBAction func sliderChange(_ sender: Any) {
        if sliderDistance.value == 0 {
            lblDistanceValue.text = "se_lbl_all".localized
        } else {
            lblDistanceValue.text = String(format: "%.1f km", sliderDistance.value)
        }
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

    @IBAction func actionCompany(_ sender: Any) {
        let controller = SearchOptionsViewController(nibName: "SearchOptionsViewController", bundle: nil)
        controller.delegate = self
        controller.searchOption = SELECT_COMPANY
        controller.arrayItems = ["se_lbl_type".localized, "se_text_individual".localized, "se_text_company".localized]
        controller.present(inParentViewController: self)
    }

    @IBAction func actionDate(_ sender: Any) {
        let controller = SearchOptionsViewController(nibName: "SearchOptionsViewController", bundle: nil)
        controller.delegate = self
        controller.searchOption = SELECT_DATE_TYPE
        controller.arrayItems = ["se_lbl_all".localized, "se_text_before".localized, "se_text_after".localized]
        controller.present(inParentViewController: self)
    }

    @IBAction func actionShowCalendar(_ sender: Any) {
        let controller = SearchDateViewController(nibName: "SearchDateViewController", bundle: nil)
        controller.delegate = self
        controller.dateSelected = selectedDate
        controller.present(inParentViewController: self)
    }

    @IBAction func actionSearch(_ sender: Any) {
        if !checkLocationAvailable() {
            return
        }
        if segmentControler.selectedSegmentIndex == 0 {
            selectedType = "1"
        } else {
            selectedType = "2"
        }
        let timestamp: TimeInterval? = selectedDate?.timeIntervalSince1970
        var strTime = "\(timestamp ?? 0.0)"
        if selectedDate == nil {
            strTime = ""
        }
        let userId = ((login_already == "1") || (login_already == "2")) ? gUser.usId : ""
        let param = ["userId": userId ?? "", "page": "1" as String, "sortBy": "" as String , "sortType": ""as String, "keyword": self.inputTextField.text ?? "", "type": selectedType as String, "categoryId" : Validator.getSafeString(catParentId) as String, "subCate": Validator.getSafeString(catSubId) as String, "city": Validator.getSafeString(cityId) as String, "individual": Validator.getSafeString(companyType) as String, "date": strTime as String, "time_option": Validator.getSafeString(beforeOrAfter) as String, "distance": String(format: "%.1f", sliderDistance.value) as String, "latitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.latitude ?? 0.0)" as String, "longitude": "\(LocationManager.shared().anotherLocationManager.location?.coordinate.longitude ?? 0.0)" as String] as [String : Any]
        let searchResultVC = SearchAdsResultVC()
        searchResultVC.paramDic = param
        navigationController?.pushViewController(searchResultVC, animated: true)
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
            catSubId = nil
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
        if (option == SELECT_COMPANY) {
            if rowSelected == 0 {
                companyLabel.text = "se_lbl_type".localized
            }
            if rowSelected == 1 {
                companyLabel.text = "se_text_individual".localized
                companyType = "1"
            }
            if rowSelected == 2 {
                companyLabel.text = "se_text_company".localized
                companyType = "2"
            }
            return
        }
        if (option == SELECT_DATE_TYPE) {
            if rowSelected == 0 {
                dateExtensionLabel.text = "se_lbl_all".localized
                dateLabel.text = "se_lbl_all".localized
                selectedDate = nil
                beforeOrAfter = ""
            }
            if rowSelected == 1 {
                dateExtensionLabel.text = "se_text_before".localized
                beforeOrAfter = "1"
            }
            if rowSelected == 2 {
                dateExtensionLabel.text = "se_text_after".localized
                beforeOrAfter = "2"
            }
            return
        }
    }

    func searchDateViewControllerDidSelectedDate(_ item: Date?) {
        selectedDate = item
        dateLabel.text = formatDate(selectedDate)
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

    func formatDate(_ theDate: Date?) -> String? {
        var formatter: DateFormatter? = nil
        if formatter == nil {
            formatter = DateFormatter()
            formatter?.dateStyle = .medium
            formatter?.timeStyle = .none
            formatter?.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        }
        if let aDate = theDate {
            return formatter?.string(from: aDate)
        }
        return nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func checkLocationAvailable() -> Bool {
        if (CLLocationManager.authorizationStatus() == .denied) {
            let alert = UIAlertController(title: APP_NAME, message: "msg_location_not_determiner".localized, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "btn_cancel".localized, style: .cancel, handler: nil)
            var setting: UIAlertAction? = nil
            if let aString = URL(string: UIApplicationOpenSettingsURLString) {
                setting = UIAlertAction(title: "btn_setting".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                    UIApplication.shared.openURL(aString)
                                })
            }
            alert.addAction(cancel)
            if let aSetting = setting {
                alert.addAction(aSetting)
            }
            present(alert, animated: true) {() -> Void in }
            return false
        }
        return true
    }

    func customTexts() {
        lblSearch.text = "se_title".localized
        lblAll.text = "se_lbl_all".localized
        lblDistanceValue.text = "se_lbl_all".localized
        lblDistance.text = "se_lbl_distance".localized
        searchButton.setTitle("se_btn_search".localized, for: .normal)
        segmentControler.setTitle("se_btn_buy".localized, forSegmentAt: 0)
        segmentControler.setTitle("se_btn_rent".localized, forSegmentAt: 1)
        inputTextField.placeholder = "se_tf_search".localized
    }
}
