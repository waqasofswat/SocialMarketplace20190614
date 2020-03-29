
//
//  BtnReportTableViewCell.swift
//  Real Estate
//
//  Created by Hicom on 3/22/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import UIKit

class BtnReportTableViewCell: UITableViewCell {
    @IBOutlet weak var btnReport: UIButton!

    override func awakeFromNib() {
        btnReport.layer.cornerRadius = 4
        btnReport.clipsToBounds = true
        //self.btnReport.layer.shadowColor = [UIColor blackColor].CGColor;
        //self.btnReport.layer.shadowOffset = CGSizeMake(0 ,1);
        //self.btnReport.layer.shadowOpacity = 0.3;
        //_btnReport.backgroundColor = COLOR_PRIMARY_DEFAULT;
        // Initialization code
        btnReport.setTitle("dt_btn_report".localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
