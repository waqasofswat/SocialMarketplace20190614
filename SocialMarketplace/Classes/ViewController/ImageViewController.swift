
//
//  ImageViewController.swift
//  SmartAds
//
//  Created by Ngọc Toán on 7/7/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var webViewController: UIWebView!
    var strURL: String?
    @IBOutlet weak var viewNaviBar: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNaviBar.isHidden = true
        lblTitle.text = "im_title".localized
        btnDone.setTitle("im_btn_done".localized, for: .normal)
        btnSave.setTitle("im_btn_save".localized, for: .normal)
        let tapToHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleSingleTap(_:)))
        tapToHideKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapToHideKeyboard)
        imageView.setImageWith(URL(string: strURL!), completed: {(_ image: UIImage?, _ error: Error?, _ cacheType: SDImageCacheType) -> Void in
        })
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer?) {
        viewNaviBar.isHidden = !viewNaviBar.isHidden
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDone(_ sender: Any) {
        dismiss(animated: true) {() -> Void in }
    }

    @IBAction func onSave(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        view.makeToast("im_msg_save_image".localized, duration: 2.0, position: CSToastPositionCenter)
    }
}
