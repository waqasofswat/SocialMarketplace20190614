//
//  RecentContactTbCell2.swift
//  SocialMarketplace
//
//  Created by Waqas on 26/03/2020.
//  Copyright © 2020 Logan CP. All rights reserved.
//

import UIKit
import Firebase

class RecentContactTbCell2: UITableViewCell {
    @IBOutlet weak var lblunread: UILabel!
    
    @IBOutlet weak var labellast2: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var imgNewMessage: UIImageView!

    @IBOutlet weak var imgstatus: UIImageView!
    @IBOutlet weak var imgmain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
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
    
}
