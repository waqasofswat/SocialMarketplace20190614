
//
//  FavoriteViewController.h
//  Real Estate
//
//  Created by De Papier on 4/14/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//
//
//  FavoriteViewController.m
//  Real Estate
//
//  Created by De Papier on 4/14/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class MoreFieldDrawMenu: UIViewController {
    @IBOutlet var revealBtn: UIButton!
    var strPresent: String?
    @IBOutlet weak var webView: UIWebView!
    var strTitle: String?
    @IBOutlet weak var lblTitle: MarqueeLabel!
    var strBack: String?
    @IBOutlet weak var imgNavi: UIImageView!

    @IBOutlet weak var lbl_favorite: MarqueeLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        text()
        view.backgroundColor = Helper.COLOR_BACKGROUD_VIEW
        imgNavi.backgroundColor = Helper.COLOR_DARK_PR_MARY
        // Do any additional setup after loading the view from its nib.
        if (strBack == "YES") {
            revealBtn.setBackgroundImage(UIImage(named: "ic_back.png"), for: .normal)
        } else {
            revealBtn.setBackgroundImage(UIImage(named: "ic_menu.png"), for: .normal)
        }
        intitData()
    }

    @IBAction func onMenuBtn(_ sender: Any) {
        if (strBack == "YES") {
            navigationController?.popViewController(animated: true)
        } else {
            revealViewController().revealToggle(sender)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func intitData() {
        lblTitle.text = strTitle
        webView.loadHTMLString(strPresent!, baseURL: nil)
    }

    func text() {
        lblTitle.text = Util.localized("lbl_favorite")
    }
}
