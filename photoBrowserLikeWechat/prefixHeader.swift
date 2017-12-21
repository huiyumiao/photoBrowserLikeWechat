//
//  prefixHeader.swift
//  photoBrowserLikeWechat
//
//  Created by 苗慧宇 on 20/12/2017.
//  Copyright © 2017 mhy. All rights reserved.
//

import Foundation
import UIKit

let kScreenWidth = UIScreen.main.bounds.width

let kScreenHeight = UIScreen.main.bounds.height


// MARK: - UIColor Extension
extension UIColor {
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgbValue >> 16) & 0xFF),
            green: CGFloat((rgbValue >> 8) & 0xFF),
            blue: CGFloat(rgbValue & 0xFF),
            alpha: alpha
        )
    }
}

