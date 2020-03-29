
//
//  AboutViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet var revealBtn: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lbl_about: UILabel!

    @IBOutlet weak var imgNaviBg: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        settexx()
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        // Do any additional setup after loading the view from its nib.
        setRevealBtn()
        view.backgroundColor = UIColor.white
        btnShare.isHidden = true
        btnRate.isHidden = true
    }

    func setRevealBtn() {
        let revealController: SWRevealViewController? = revealViewController()
        if let aRecognizer = revealController?.panGestureRecognizer {
            view.addGestureRecognizer(aRecognizer()!)
        }
        revealBtn.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }

    @IBAction func gotoWeb(_ sender: Any) {
        if let aString = URL(string: "http://hicomsolutions.com.au/") {
            UIApplication.shared.openURL(aString)
        }
    }

    @IBAction func onShare(_ sender: Any) {
        let textToShare = "Get our Solutions Completely & Ready-to-go Applications"
        let myWebsite = URL(string: "http://hicomsolutions.com.au/")
        let objectsToShare = [textToShare, myWebsite] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true) {() -> Void in }
    }

    @IBAction func onRate(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "neverRate")
        if let aFormat = URL(string: "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=573753324") {
            UIApplication.shared.openURL(aFormat)
        }
    }

    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            UserDefaults.standard.set(true, forKey: "neverRate")
            if let aFormat = URL(string: "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=573753324") {
                UIApplication.shared.openURL(aFormat)
            }
        } else if buttonIndex == 1 {

        } else if buttonIndex == 2 {
            UserDefaults.standard.set(true, forKey: "neverRate")
        }
    }

    func settexx() {
        lbl1.text = APP_NAME
        lbl2.text = "ab_text_about2".localized
        lbl_about.text = "rv_menu_about".localized
        btnShare.setTitle("ab_btn_share_app".localized, for: .normal)
        btnRate.setTitle("ab_btn_rate_app".localized, for: .normal)
    }
}
