
//
//  ChatTbvCell.swift
//  SmartAds
//
//  Created by Pham Diep on 5/29/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit

protocol ChatTbvCell2Delegate: NSObjectProtocol {
    func clickButtom(at index: Int, identifier: String?)
}

class ChatTbvCell2: UITableViewCell {
    @IBOutlet weak var imgGuess: UIImageView!
    @IBOutlet weak var imgHost: UIImageView!
    @IBOutlet weak var viewContainImgGuess: UIView!
    @IBOutlet weak var viewContainImgHost: UIView!
    @IBOutlet weak var lblMessage: UITextView!
    @IBOutlet weak var tvMessageHost: UITextView!
    @IBOutlet weak var stackViewGuess: UIStackView!
    @IBOutlet weak var stackViewHost: UIStackView!
    @IBOutlet weak var imageGuessSend: UIImageView!
    @IBOutlet weak var constrainHeightImgGuess: NSLayoutConstraint!
    @IBOutlet weak var imageHostSend: UIImageView!
    @IBOutlet weak var constrainHeightHost: NSLayoutConstraint!
    @IBOutlet weak var lblDatePostGuess: UILabel!
    @IBOutlet weak var lblDatePostHost: UILabel!
    @IBOutlet weak var btnClickFileGuess: UIButton!
    @IBOutlet weak var btnClickFileHost: UIButton!
    weak var delegate: ChatTbvCell2Delegate?
    var indexClick: Int = 0
    @IBOutlet weak var viewGuessSendImage: UIView!
    @IBOutlet weak var viewHostSendImage: UIView!

    func hideAllCell() {
        viewContainImgHost.isHidden = true
        viewContainImgGuess.isHidden = true
        stackViewHost.isHidden = true
        stackViewGuess.isHidden = true
        viewGuessSendImage.isHidden = true
        btnClickFileGuess.isHidden = true
        lblMessage.isHidden = true
        viewHostSendImage.isHidden = true
        btnClickFileHost.isHidden = true
        tvMessageHost.isHidden = true
        constrainHeightHost.constant = 0
        constrainHeightImgGuess.constant = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imgGuess.layer.cornerRadius = 15
        imgGuess.layer.masksToBounds = true
        imgHost.layer.cornerRadius = 15
        imgHost.layer.masksToBounds = true
        lblMessage.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5)
        lblMessage.layer.cornerRadius = 10
        tvMessageHost.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5)
        tvMessageHost.layer.cornerRadius = 10
        imageHostSend.layer.borderColor = Helper.COLOR_BG_MESSAGE_HOST.cgColor
        imageHostSend.layer.borderWidth = 2
        imageHostSend.layer.cornerRadius = 7
        imageGuessSend.layer.borderColor = Helper.COLOR_BG_MESSAGE_GUESS.cgColor
        imageGuessSend.layer.borderWidth = 2
        imageGuessSend.layer.cornerRadius = 7
    }

    @IBAction func onClickFileGuess(_ sender: Any) {
        delegate?.clickButtom(at: indexClick, identifier: "file")
    }

    @IBAction func onClickFileHost(_ sender: Any) {
        delegate?.clickButtom(at: indexClick, identifier: "file")
    }

    @IBAction func onClickButtomImage(_ sender: Any) {
        delegate?.clickButtom(at: indexClick, identifier: "image")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
