
//
//  SendMessageVC.swift
//  SmartAds
//
//  Created by Apple on 2/8/18.
//  Copyright © 2018 Mr Lemon. All rights reserved.
//

import UIKit

class SendMessageVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfQuestion: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    var stringTitle: String?
    var accountId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        initView()
    }

    func initView() {
        tfTitle.delegate = self
        tfFullName.delegate = self
        tfEmail.delegate = self
        tfPhone.delegate = self
        tfQuestion.delegate = self
        btnSendMessage.layer.masksToBounds = true
        btnSendMessage.layer.cornerRadius = 5
        lblTitle.text = stringTitle
        tfTitle.resignFirstResponder()
    }

// MARK: - IBA Action
    @IBAction func onSendMessage(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        ModelManager.sendMessage(accountId, title: tfTitle.text, name: tfFullName.text, phone: tfPhone.text, email: tfEmail.text, content: tfQuestion.text, withSuccess: {(_ successStr: String?) -> Void in
            self.showAlert("1", message: successStr)
            MBProgressHUD.hide(for: self.view, animated: true)
        }, failure: {(_ err: String?) -> Void in
            self.showAlert("0", message: err)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

// MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfTitle {
            tfFullName.becomeFirstResponder()
        } else if textField == tfFullName {
            tfEmail.becomeFirstResponder()
        } else if textField == tfEmail {
            tfPhone.becomeFirstResponder()
        } else if textField == tfPhone {
            tfQuestion.becomeFirstResponder()
        } else if textField == tfQuestion {
            view.endEditing(true)
        }
        return true
    }

// MARK: - Function
    func showAlert(_ status: String?, message: String?) {
        var status = status
        var message = message
        if (status == "1") {
            status = "Success"
            message = "Send message success"
        } else {
            status = "Error"
        }
        let alert = UIAlertController(title: status, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            })
        alert.addAction(defaultAction)
        present(alert, animated: true) {() -> Void in }
    }
}
