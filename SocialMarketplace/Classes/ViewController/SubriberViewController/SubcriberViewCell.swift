
//
//  SubcriberViewCell.swift
//  SmallAds
//
//  Created by Hicom on 5/14/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

protocol SubcriberViewCellDelegate: NSObjectProtocol {
    func subcriberViewCellTouch(_ item: SubCriberItem?)
}

class SubcriberViewCell: UITableViewCell {
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    weak var delegate: SubcriberViewCellDelegate?
    var itemEdit: SubCriberItem?

    @IBAction func touchCheck(_ sender: Any) {
        delegate?.subcriberViewCellTouch(itemEdit)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
