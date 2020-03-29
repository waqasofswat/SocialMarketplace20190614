//
//  Helper.swift
//  SmartAds
//
//  Created by Logan on 5/15/18.
//  Copyright © 2018 Mr Lemon. All rights reserved.
//

import UIKit

class Helper: NSObject {
    static let COLOR_BACKGROUD_VIEW = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
    static let COLOR_PRIMARY_DEFAULT = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let COLOR_BTN_SMALL = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
    static let COLOR_DEVIDER = #colorLiteral(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
    static let COLOR_DARK_PR_MARY = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let IMAGE_HODER = UIImage(named: "avatar_default-1.png")
    static let COLOR_BG_MESSAGE_HOST = #colorLiteral(red: 0.2509803922, green: 0.5019607843, blue: 1, alpha: 1)
    static let COLOR_BG_MESSAGE_GUESS = #colorLiteral(red: 0.9450980392, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    static let COLOR_SEGMENTTINT = #colorLiteral(red: 0.5764705882, green: 0.5803921569, blue: 0.5882352941, alpha: 1)
    static let COLOR_EFEFEF = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    static let COLOR_0ALPHA80 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
}
extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: KEY_SAVE_LANGUAGE)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        return bundle!.localizedString(forKey: self, value: "", table: nil)
    }
    var attributedString: NSAttributedString? {
        return NSAttributedString(string: self, attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.foregroundColor: UIColor.blue])
    }
    
    struct NumFormatter {
        static let instance = NumberFormatter()
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var doubleValue: Double? {
        return NumFormatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return NumFormatter.instance.number(from: self)?.intValue
    }
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
        
    }

}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: self],
            context: nil).size
    }
}
