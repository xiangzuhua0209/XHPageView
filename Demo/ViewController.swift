//
//  ViewController.swift
//  Demo
//
//  Created by xiangzuhua on 2021/5/27.
//

import UIKit
import XHPageView

let mainColor = UIColor.black
let unselectedColor = UIColor.gray
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "XHPageViewd"
        setupPageStyle()
        // Do any additional setup after loading the view.
    }


    func setupPageStyle() {
        
        let style = XHPageViewStyle()
//        style.isTitleViewScrollEnabel = true
//        style.isScaleEnable = false
        style.titleMargin = 20
        style.titleSize = 16
        style.selectedTitleColor = mainColor
        style.unSelectedTitleColor = unselectedColor
        
        style.isShowBottomLine = false
        style.bottomLineColor = mainColor
        
//        style.isShowCoverView = true
        style.coverViewHeight = 40
        style.coverViewMargin = 10
        style.coverViewAlpher = 0.4
        style.coverViewCornerRadius = 20
        style.coverViewBackgroundColor = UIColor.purple
        style.selectedTitleViewColor = UIColor.orange
        style.unSelectedTitleViewColor = UIColor.white
        
        
        let titles = ["推荐","分类","VIP","直播","广播"]
        
        let VCs = [ZHHomeRecommendVC(),
        ZHHomeClassifyVC(),
        ZHHomeVIPViewController(),
        ZHHomeShowViewController(),
        ZHHomeBroadcastVC()]
        
        for vc in VCs {
            self.addChild(vc)
        }
        let rect:CGRect = CGRect(x: 0.0, y: ZHNavigationBarHeight, width: ZHScreenWidth, height: ZHScreenHeight - ZHNavigationBarHeight - ZHTabBarHeight)
        let pageView = XHPageView(rect, titles: titles, style: style, viewControllers: VCs)
        view.addSubview(pageView)
    }
}

