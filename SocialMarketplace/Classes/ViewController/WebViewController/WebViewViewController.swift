
//
//  WebViewViewController.swift
//  Real Ads
//
//  Created by De Papier on 4/13/15.
//  Copyright (c) 2015 Hicom Solutions. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var scrollLabel: CBAutoScrollLabel!
    @IBOutlet var webView: UIWebView!
    var newss: News?

    @IBOutlet weak var imgNaviBg: UIImageView!

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imgNaviBg.backgroundColor = Helper.COLOR_DARK_PR_MARY
        layoutView()
        scrollLabel.text = newss?.newsTitle
            // Do any additional setup after loading the view from its nib.
            // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://vnre.reic.vn/2012/09/its-great-time-to-invest-in-hoa-lac-hi.html"]]];
        let url = URL(string: newss?.newsUrl?.removingPercentEncoding ?? "")
        if let anUrl = url {
            webView.loadRequest(URLRequest(url: anUrl))
        }
        webView.delegate = self
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        MBProgressHUD.showAdded(to: self.webView, animated: true)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hideAllHUDs(for: self.webView, animated: true)
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hideAllHUDs(for: self.webView, animated: true)
        view.makeToast("msg_not_found".localized, duration: 2.0, position: CSToastPositionCenter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func layoutView() {
        // self.scrollLabel.text = _newss.title;
        scrollLabel.textColor = UIColor.white
        scrollLabel.font = UIFont(name: "OpenSans-Semibold", size: 22)
    }
}
