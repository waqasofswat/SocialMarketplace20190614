
//
//  SubcriberViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/23/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class SubcriberViewController: UIViewController, UIKeyboardViewControllerDelegate, UITextFieldDelegate, PayPalPaymentDelegate, UITableViewDelegate, UITableViewDataSource, SubcriberViewCellDelegate {
    var payPalConfig: PayPalConfiguration?
    var completedPayment: PayPalPayment?
    @IBOutlet weak var viewShowBanking: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var viewBanking: UIView!
    @IBOutlet weak var btnBanking: UIButton!
    var acceptCreditCards = false
    @IBOutlet weak var tableView: UITableView!
    var environment = ""
    var ads: Ads?
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var check1MImg: UIImageView!
    @IBOutlet weak var check3MImg: UIImageView!
    @IBOutlet weak var check6MImg: UIImageView!
    @IBOutlet weak var check1YImg: UIImageView!
    @IBOutlet weak var endDatelabel: UILabel!
    @IBOutlet var btnPayment: UIButton!
    @IBOutlet var txtEndDate: UITextField!
    
    @IBOutlet weak var imgNaviBg: UIImageView!
    
    var keyBoardController: UIKeyboardViewController?
    var datePicker: UIDatePicker?
    var Enddate: UIDatePicker?
    
    private var check: Int? = 0
    private var Sum: Int? = 0
    private var arrayItems = [Any]()
    
    var currency = ""
    
    //    // MARK: Paypal vars
    //    @IBAction func onBackKing(_ sender: Any) {
    //
    //        let dic : [String: Any] = ["paidDate": startDateTextField.text as Any,
    //                                   "endDate": endDatelabel.text as Any,
    //                                   "duration": "\(check ?? 0)",
    //            "value" : "\(Sum ?? 0)",
    //            "adsId" : ads?.adsId as Any,
    //            "payment" : "2"]
    //
    //
    //        MBProgressHUD.showAdded(to: viewBanking, animated: true)
    //        ModelManager.addSubCription(withParam: dic, endate: <#String!#>, duration: <#String!#>, withSuccess: {(_ strSuccess: String?) -> Void in
    //            MBProgressHUD.hideAllHUDs(for: self.viewBanking, animated: true)
    //            self.view.makeToast(strSuccess, duration: 2.0, position: CSToastPositionCenter)
    //        }, failure: {(_ err: String?) -> Void in
    //            MBProgressHUD.hideAllHUDs(for: self.viewBanking, animated: true)
    //            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
    //        })
    //    }
    
    @IBAction func on1M(_ sender: Any) {
        hideAll()
        check1MImg.isHidden = false
        check = 1
        Sum = 50
        setEndDate()
    }
    
    @IBAction func on3M(_ sender: Any) {
        hideAll()
        check3MImg.isHidden = false
        check = 3
        Sum = 150
        setEndDate()
    }
    
    @IBAction func on6M(_ sender: Any) {
        hideAll()
        check6MImg.isHidden = false
        check = 6
        Sum = 300
        setEndDate()
    }
    
    @IBAction func on1Y(_ sender: Any) {
        hideAll()
        check1YImg.isHidden = false
        check = 12
        Sum = 600
        setEndDate()
    }
    
    @IBAction func onOKBanking(_ sender: Any) {
        viewBanking.isHidden = true
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func onPay(_ sender: Any) {
        requirePaypalPayment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        serviceLabel.text = ads?.adsTitle
        check = 1
        Sum = 10
        // Do any additional setup after loading the view from its nib.
        //Setup keyboard
        keyBoardController = UIKeyboardViewController(controllerDelegate: self)
        keyBoardController?.addToolbarToKeyboard()
        startDateTextField.text = Util.string(from: Date(), format: "yyyy/MM/dd")
        let start: Date? = getDateFromDateString(startDateTextField.text)
        var dateComponents = DateComponents()
        dateComponents.month = check
        let calendar = Calendar.current
        var newDate: Date? = nil
        if let aStart = start {
            newDate = calendar.date(byAdding: dateComponents, to: aStart)
        }
        endDatelabel.text = getDateString(from: newDate)
        dateAndTimePicker()
        acceptCreditCards = false
        environment = PayPalEnvironmentSandbox
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //    [self.tableView registerClass:[SubcriberViewCell class] forCellReuseIdentifier:@"SubcriberViewCell"];
        tableView.register(UINib(nibName: "SubcriberViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubcriberViewCell")
        MBProgressHUD.showAdded(to: view, animated: true)
        ModelManager.getlistSubscription(success: {(_ arr: [Any]?) -> Void in
            if let anArr = arr {
                self.arrayItems = anArr
            }
            self.tableView.reloadData()
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }, failure: {(_ err: String?) -> Void in
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        layoutView()
    }
    
    func layoutView() {
        viewShowBanking.layer.cornerRadius = 6
        viewBanking.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        uiView.layer.cornerRadius = 6
        serviceLabel.numberOfLines = 0
        serviceLabel.sizeToFit()
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        environment = PayPalEnvironmentSandbox
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: kPayPalClientId, PayPalEnvironmentSandbox: kPayPalClientId])
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubcriberViewCell") as? SubcriberViewCell
        cell?.delegate = self
        let i = arrayItems[indexPath.row] as? SubCriberItem
        cell?.itemEdit = i
        if i?.itemPrice == 0 {
            cell?.lblValue.text = "Free"
        } else {
            if let aSymbol = i?.itemCurrencySymbol, let aPrice = i?.itemPrice {
                cell?.lblValue.text = "\(aSymbol) \(aPrice)"
            }
        }
        if i?.itemIsFeatured == 1 {
            if let aDuration = i?.itemDuration {
                cell?.lblName.text = "\(aDuration) days (With Featured)"
            }
        } else {
            if let aDuration = i?.itemDuration {
                cell?.lblName.text = "\(aDuration) days"
            }
        }
        cell?.imgCheck.isHidden = !(i?.isChecked)!
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func subcriberViewCellTouch(_ item: SubCriberItem?) {
        item?.isChecked = !(item?.isChecked)!
        Sum = item?.itemPrice ?? 0
        check = item?.itemDuration?.integerValue ?? 0
        for i in (arrayItems as? [SubCriberItem])! {
            if i.itemID != item?.itemID {
                i.isChecked = false
            }
        }
        tableView.reloadData()
        setEndDate()
    }
    
    //Date and time
    func dateAndTimePicker() {
        //date
        datePicker = UIDatePicker()
        datePicker?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180)
        datePicker?.date = Date()
        datePicker?.datePickerMode = .date
        //datePicker.backgroundColor = self.view.backgroundColor;
        datePicker?.backgroundColor = UIColor.clear
        datePicker?.addTarget(self, action: Selector("updateTextField:"), for: .valueChanged)
        let datePickerView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 180, width: UIScreen.main.bounds.size.width, height: 180))
        if let aPicker = datePicker {
            datePickerView.addSubview(aPicker)
        }
        startDateTextField.delegate = self
        startDateTextField.inputView = datePickerView
    }
    
    @objc func updateTextField(_ sender: Any?) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        if let aDate = datePicker?.date {
            startDateTextField.text = dateFormat.string(from: aDate)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (startDateTextField.text == "") {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy/MM/dd"
            startDateTextField.text = dateFormat.string(from: Date())
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setEndDate()
    }
    
    func hideAll() {
        check1MImg.isHidden = true
        check6MImg.isHidden = true
        check3MImg.isHidden = true
        check1YImg.isHidden = true
    }
    
    func getDateString(from date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var dateString: String? = nil
        if let aDate = date {
            dateString = dateFormatter.string(from: aDate)
        }
        return dateString
    }
    
    func getDateFromDateString(_ dateString: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date: Date? = dateFormatter.date(from: dateString ?? "")
        return date
    }
    
    func setEndDate() {
        let start: Date? = getDateFromDateString(startDateTextField.text)
        var dateComponents = DateComponents()
        dateComponents.day = check
        let calendar = Calendar.current
        var newDate: Date? = nil
        if let aStart = start {
            newDate = calendar.date(byAdding: dateComponents, to: aStart)
        }
        endDatelabel.text = getDateString(from: newDate)
    }
    
    // MARK: PAYPAL FUNCTIONS
    func requirePaypalPayment() {
        var hasItem = false
        for item in (arrayItems as? [SubCriberItem])! {
            if item.isChecked {
                hasItem = true
                break
            }
        }
        if !hasItem {
            view.makeToast("Please select subscription type ", duration: 2.0, position: CSToastPositionCenter)
            return
        }
        for item in (arrayItems as? [SubCriberItem])! {
            if item.isChecked {
                if item.itemPrice == 0 {
                    sendOrderToServer()
                    return
                }
            }
        }
        // Remove our last completed payment, just for demo purposes.
        completedPayment = nil
        let payment = PayPalPayment()
        //        payment.amount = NSDecimalNumber(string: "\(Sum)")
        payment.currencyCode = "USD"
        payment.shortDescription = "Payment for Order in App"
        var itemArr = [Any]()
        for temp: SubCriberItem in (arrayItems as? [SubCriberItem])! {
            if temp.isChecked {
                let item1 = PayPalItem(name: gUser.usName, withQuantity: 1, withPrice: NSDecimalNumber(string: "\(temp.itemPrice)"), withCurrency: "USD", withSku: "")
                itemArr.append(item1)
            }
        }
        payment.items = itemArr
        if !payment.processable {
            
        }
        let subtotal: NSDecimalNumber? = PayPalItem.totalPrice(forItems: itemArr)
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let total: NSDecimalNumber? = subtotal?.adding(shipping).adding(tax)
        payment.amount = total!
        payment.paymentDetails = paymentDetails
        PayPalMobile.preconnect(withEnvironment: environment)
        let config = PayPalConfiguration()
        config.acceptCreditCards = false
        config.languageOrLocale = "en"
        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: config, delegate: self)
        present(paymentViewController!, animated: true) {() -> Void in }
    }
    
    
    // MARK: - Proof of payment validation
    func sendCompletedPayment(toServer completedPayment: PayPalPayment?) {
        // TODO: Send completedPayment.confirmation to server
        if let aConfirmation = completedPayment?.confirmation {
            print("Here is your proof of payment:\n\n\(aConfirmation)\n\nSend this to your server for confirmation and fulfillment.")
        }
    }
    
    // MARK: - PayPalPaymentDelegate methods
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController?, didComplete completedPayment: PayPalPayment?) {
        print("PayPal Payment Success!")
        self.completedPayment = completedPayment
        sendCompletedPayment(toServer: completedPayment)
        // Payment was processed successfully; send to server for verification and fulfillment
        dismiss(animated: true) {() -> Void in }
        sendOrderToServer()
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController?) {
        print("PayPal Payment Canceled")
        completedPayment = nil
        dismiss(animated: true) {() -> Void in }
    }
    
    func sendOrderToServer() {
        var subId = ""
        for temp: SubCriberItem in (arrayItems as? [SubCriberItem])! {
            if temp.isChecked {
                subId = "\(temp.itemID)"
            }
        }
        let keyArray = ["paidDate", "endDate", "duration", "value", "adsId", "payment", "subId"]
        let startText = startDateTextField.text
        let endText = endDatelabel.text
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        let startDate: Date? = dateFormat.date(from: startText ?? "")
        let endDate: Date? = dateFormat.date(from: endText ?? "")
        if let aDate = startDate, let aDate1 = endDate {
            print("date: \(aDate), \(aDate1)")
        }
        let resultStart: Double? = startDate?.timeIntervalSince1970
        let resultEnd: Double? = endDate?.timeIntervalSince1970
        print("time: \(resultStart ?? 0.0), \(resultEnd ?? 0.0)")
        MBProgressHUD.showAdded(to: view, animated: true)
        ModelManager.addSubCription(withStartDate: String(format: "%.0f", resultStart!), endate: String(format: "%.0f", resultEnd!), duration: String(format: "%i", check!), value: String(format: "%i", Sum!), adsId:  ads?.adsId, payment: "1", subId: subId, withSuccess: {(_ strSuccess: String?) -> Void in
            print("\(strSuccess ?? "")")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.view.makeToast(strSuccess, duration: 2.0, position: CSToastPositionCenter)
        }, failure: {(_ err: String?) -> Void in
            print("\(err ?? "")")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
         if err != nil{
            self.view.makeToast(err, duration: 2.0, position: CSToastPositionCenter)
         }else{
            self.view.makeToast("have some error")
         }
        })
        
    }
}

