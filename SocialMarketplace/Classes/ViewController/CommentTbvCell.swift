
//
//  CommentTbvCell.swift
//  SmartAds
//
//  Created by Pham Diep on 5/26/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit

class CommentTbvCell: UITableViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!

    func setupData(withObj commentObj: Comment?) {
        imgAvatar.setImageWith(URL(string: commentObj?.linkAvatar ?? ""), placeholderImage: UIImage(named: "avatar_default-1.png"))
        lblName.text = commentObj?.accName
        lblContent.text = commentObj?.content
//        lblDate.text = Util.string(from: Date(timeIntervalSince1970: commentObj?.timeIntervalPost ?? 0.0), format: "yyyy-MM-dd")
        lblDate.text = Date(timeIntervalSince1970: commentObj?.timeIntervalPost ?? 0.0).timeAgoSinceNow

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = 22
        imgAvatar.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
