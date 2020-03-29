
//
//  RecentContactTbCell.swift
//  SmartAds
//
//  Created by Pham Diep on 5/30/17.
//  Copyright © 2017 Mr Lemon. All rights reserved.
//

import UIKit
import Firebase

class RecentContactTbCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastMess: UILabel!
    //@IBOutlet weak var imageoffonline: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
   // @IBOutlet weak var imgguess: UIImageView!
    @IBOutlet weak var imgNewMessage: UIImageView!
    @IBOutlet weak var lblUnread: UITextView!
    var conversationId = ""

    func setupOnlineOffline(withUserId userId: String?) {
        Database.database().reference().child("user/\(userId ?? "")/status").observe(DataEventType.value)  {(snapshot) in
            if snapshot.exists() {
                if (Validator.getSafeString(snapshot.value) == "1") {
                 //   self.imageoffonline.image = UIImage(named: "ic_online")
                } else if (Validator.getSafeString(snapshot.value) == "2") {
                 //   self.imageoffonline.image = UIImage(named: "ic_away")
                } else {
              //      self.imageoffonline.image = UIImage(named: "ic_offline")
                }
            }
        }
        Database.database().reference().child("user/\(gUser.usId as String)/chatWith/\(userId ?? "")").queryOrdered(byChild: "datePost").observe(DataEventType.value) {(snapshot)  in
            if snapshot.exists() {

            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
      //  imgguess.layer.cornerRadius = imgguess.bounds.size.height / 2
       // imgguess.layer.masksToBounds = true
        lblUnread.textContainerInset = UIEdgeInsetsMake(7, 0, 3, 0)
        lblUnread.layer.cornerRadius = 10
        lblUnread.backgroundColor = Helper.COLOR_DARK_PR_MARY
        lblUnread.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
