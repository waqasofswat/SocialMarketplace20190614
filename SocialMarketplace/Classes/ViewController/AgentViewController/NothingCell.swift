
//
//  NothingCell.swift
//  Real Estate
//
//  Created by Hicom on 3/5/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class NothingCell: UITableViewCell {
  @IBOutlet weak var lblTitlex: UILabel!

    override func awakeFromNib() {
        lblTitlex.text = Util.localized("lbl_nothing")
    }
}
