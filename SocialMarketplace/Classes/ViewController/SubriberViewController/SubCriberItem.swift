
//
//  SubCriberItem.swift
//  SmallAds
//
//  Created by Hicom on 5/14/16.
//  Copyright © 2016 Hicom Solutions. All rights reserved.
//

import Foundation

class SubCriberItem: NSObject {
    
    @objc var itemCurrencySymbol: NSString?
    @objc var itemDuration: NSString?
    @objc var itemID: Int = 0
    @objc var itemPrice: Int = 0
    @objc var itemStatus: Int = 0
    @objc var itemIsFeatured: Int = 0
    @objc var isChecked = false
    
}
