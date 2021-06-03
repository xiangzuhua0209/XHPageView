//
//  XHPageView.swift
//  XHFM
//
//  Created by xiangzuhua on 2021/5/13.
//

import UIKit

/// 刷新协议，提供时机用于界面的数据刷新，如需要，在ViewController中遵循此协议，并实现要求
public protocol XHPageViewReloadable {
    /// 两次点击同一标题触发此方法
    func didSelectedSameTile(_ index: Int)
    /// contentView滑动结束触发此方法
    func contentViewDidEndScroll()
}

/// pageView的样式
public class XHPageViewStyle {
    /// 标题栏相关配置
    public var titleViewHeight: CGFloat = 44.0
    public var titleSize: CGFloat = 17.0
    public var titleMargin: CGFloat = 12.0
    
    /// 选中标题的下滑线条相关配置
    public var bottomLineHeight: CGFloat = 4.0
    public var bottomLineColor: UIColor = UIColor.red
    public var isShowBottomLine = true
    
    /// 选中与非选中的颜色相关配置
    public var selectedIndex: Int = 0
    public var selectedTitleViewColor: UIColor = UIColor.clear
    public var unSelectedTitleViewColor: UIColor = UIColor.clear
    public var selectedTitleColor: UIColor = UIColor.black
    public var unSelectedTitleColor: UIColor = UIColor.gray
    
    /// 标题栏是否可以滑动，标题不多的时候不需要滑动，标题比较多，显示不全应该可滑动
    public var isTitleViewScrollEnabel = false
    
    /// 点击标题的缩放动画效果控制
    public var isScaleEnable = true // 点击的缩放动画
    public var maximumScale: CGFloat = 1.2 // 动画缩放因子
    
    /// 选中标题的填充层相关配置
    public var isShowCoverView = false
    public var coverViewBackgroundColor = UIColor.black
    public var coverViewAlpher: CGFloat = 0.4
    public var coverViewHeight: CGFloat = 44.0
    public var coverViewMargin: CGFloat = 8.0 // 填充层左右边界距离文字视图的距离
    public var coverViewCornerRadius: CGFloat = 12 // 填充层圆角半径
    
    /// 容器视图相关配置
    public var contentViewBackgroundColor = UIColor.white
    public var isContentScrollEnabled: Bool = true // 容器视图是否可以左右滑动切换
    
    public init() {
        
    }
    
}

public class XHPageView: UIView {
    
    private (set) public lazy var titleView: XHPageTitleView = {
        let titleView = XHPageTitleView(.zero, titles: titles, style: style)
        return titleView
    }()
    
    private (set) public lazy var contentView: XHPageContentView = {
        let contentView = XHPageContentView(frame: .zero, style: style, viewControllers: viewControllers, startIndex: startIndex)
        return contentView
    }()
    
    public var titles: [String]
    public var style: XHPageViewStyle
    public var viewControllers: [UIViewController]
    public var startIndex: Int
    public init(_ frame: CGRect, titles:[String], style: XHPageViewStyle, viewControllers: [UIViewController], startIndex: Int = 0) {
        self.titles = titles
        self.style = style
        self.viewControllers = viewControllers
        self.startIndex = startIndex
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension XHPageView{
    private func setupUI(){
        titleView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: style.titleViewHeight)
        addSubview(titleView)
        contentView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: frame.size.width, height: frame.height - titleView.frame.height)
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}


