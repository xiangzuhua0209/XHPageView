//
//  ZHCommon.swift
//  ZHFM
//
//  Created by xiangzuhua on 2021/5/11.
//

import UIKit


// 全面屏系列判断
extension UIDevice {
    class func isIPhoneXMore() -> Bool{
        var isMore = false
        if #available(iOS 11.0, *) {
            isMore = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0 > 0.0
        }
        return isMore
    }
}

let ZHNavigationBarHeight: CGFloat = UIDevice.isIPhoneXMore() ? 88.0 : 64.0
let ZHTabBarHeight: CGFloat = UIDevice.isIPhoneXMore() ? (49.0 + 34.0) : 49.0

// 屏幕宽高
let ZHScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ZHScreenHeight: CGFloat = UIScreen.main.bounds.size.height
