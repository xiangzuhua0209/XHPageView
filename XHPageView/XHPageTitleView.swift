//
//  XHPageTitleView.swift
//
//  Created by xiangzuhua on 2021/5/13.
//

import UIKit

/// titleView的协议，将title的单击和双击事件委托出去
public protocol XHPageTitleViewDelegate {
    
    /// 点击标题时触发
    /// - Parameters:
    ///   - titleView: 父视图titleView
    ///   - index: 当前点击的角标
    func titleView(_ titleView: XHPageTitleView, current index: Int)
    func titleView(_ titleView: XHPageTitleView, doubleSelected index: Int)
}

// 定义一个点击事件的闭包
public typealias TitleClickHandler = (XHPageTitleView, Int) -> ()


public class XHPageTitleView: UIView {
    public var titles: [String]
    public var style: XHPageViewStyle
    
    public var currentIndex: Int = 0
    public var labels: [UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.scrollsToTop = false
        return scroll
    }()
    
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = style.bottomLineColor
        return bottomLine
    }()
    
    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = style.coverViewBackgroundColor
        cover.alpha = style.coverViewAlpher
        return cover
    }()
    
    public var delegate:XHPageTitleViewDelegate?
    public var clickHandler: TitleClickHandler?
    
    public init(_ frame:CGRect, titles: [String], style: XHPageViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        scrollView.frame = bounds
        labelsLayout()
        bottomLineLayout()
        coverViewLayout()
        
        if style.isScaleEnable {
            let transform = CGAffineTransform(scaleX: style.maximumScale, y: style.maximumScale)
            labels.first?.transform = transform
        }
        
        if style.isTitleViewScrollEnabel {
            guard let lastLabel = labels.last else {
                return
            }
            scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + style.titleMargin * 0.5, height: bounds.height)
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - UI
extension XHPageTitleView{
    private func setupUI(){
        addSubview(scrollView)
        setupLabels()
        setupBottomLine()
        setupCoverView()
    }
    
    private func setupLabels(){
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = i
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.titleSize)
            label.textColor = currentIndex == i ? style.selectedTitleColor : style.unSelectedTitleColor
            label.backgroundColor = currentIndex == i ? style.selectedTitleViewColor : style.unSelectedTitleViewColor
            labels.append(label)
            scrollView.addSubview(label)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapAction(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
        }
    }
    
    private func setupBottomLine(){
        guard style.isShowBottomLine else {
            return
        }
        scrollView.addSubview(bottomLine)
    }
    private func setupCoverView(){
        guard style.isShowCoverView else {
            return
        }
        scrollView.insertSubview(coverView, at: 0)
        coverView.layer.cornerRadius = style.coverViewCornerRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK: - layout
extension XHPageTitleView{
    
    private func labelsLayout(){
        var labelX: CGFloat = 0.0
        let labelY: CGFloat = 0.0
        var labelW: CGFloat = 0.0
        let labelH: CGFloat = frame.size.height
        
        for (i, label) in labels.enumerated() {
            if style.isTitleViewScrollEnabel {
                labelX = i == 0 ? (style.titleMargin * 0.5) : (labels[i - 1].frame.maxX + style.titleMargin)
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [.font : label.font as Any], context: nil).width
            } else {
                labelW = bounds.size.width / CGFloat(labels.count)
                labelX = labelW * CGFloat(i)
            }
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
    }
    
    private func bottomLineLayout(){
        guard labels.count - 1 >= currentIndex else {
            return
        }
        let selectedLabel = labels[currentIndex]
        var bottomLineX = selectedLabel.frame.origin.x
        var bottomLineW = selectedLabel.frame.size.width
        if style.isTitleViewScrollEnabel {
            bottomLineX = selectedLabel.frame.origin.x - style.titleMargin * 0.5
            bottomLineW = selectedLabel.frame.size.width + style.titleMargin
        }
        bottomLine.frame = CGRect(x: bottomLineX, y: frame.size.height - style.bottomLineHeight, width: bottomLineW, height: style.bottomLineHeight)
    }
    
    private func coverViewLayout(){
        guard labels.count - 1 >= currentIndex else {
            return
        }
        let currentLabel = labels[currentIndex]
        var cover_x = currentLabel.frame.origin.x
        var cover_w = currentLabel.frame.width
        let cover_h = style.coverViewHeight
        let cover_y = (frame.height - cover_h) * 0.5
        if style.isTitleViewScrollEnabel {
            cover_x -= style.coverViewMargin
            cover_w += style.coverViewMargin * 2
        }
        
        coverView.frame = CGRect(x: cover_x, y: cover_y, width: cover_w, height: cover_h)
    }

}
// MARK: - 事件
extension XHPageTitleView{
    // label的点击事件
    @objc func labelTapAction(_ sender:UIGestureRecognizer){
        guard let targetLabel = sender.view as? UILabel else {
            return
        }
        
        clickHandler?(self, targetLabel.tag)
        
        if targetLabel.tag == currentIndex {
            // 点击了已选中的label
            self.delegate?.titleView(self, doubleSelected: currentIndex)
            return
        }
        
        let beforeLabel = labels[currentIndex]
        
        currentIndex = targetLabel.tag
        self.delegate?.titleView(self, current: currentIndex)
        beforeLabel.textColor = style.unSelectedTitleColor
        targetLabel.textColor = style.selectedTitleColor
        
        // 自动移动标签到合适的位置
        adjustLabelPosition(target: targetLabel)
        
        // 移动bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25) {
                var bottomLineX = targetLabel.frame.origin.x
                var bottomLineW = targetLabel.frame.size.width
                if self.style.isTitleViewScrollEnabel {
                    bottomLineX = targetLabel.frame.origin.x - self.style.titleMargin * 0.5
                    bottomLineW = targetLabel.frame.size.width + self.style.titleMargin
                }
                self.bottomLine.frame.origin.x = bottomLineX
                self.bottomLine.frame.size.width = bottomLineW
            }
        }
        
        // 缩放动画
        if style.isScaleEnable {
            beforeLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: style.maximumScale, y: style.maximumScale)
        }
        
        if style.isShowCoverView {
            var cover_x = targetLabel.frame.origin.x
            var cover_w = targetLabel.frame.width
            if style.isTitleViewScrollEnabel {
                cover_x -= style.coverViewMargin
                cover_w += style.coverViewMargin * 2
            }
            UIView.animate(withDuration: 0.25) {
                self.coverView.frame.origin.x = cover_x
                self.coverView.frame.size.width = cover_w
            }
        }
        beforeLabel.backgroundColor = style.unSelectedTitleViewColor
        targetLabel.backgroundColor = style.selectedTitleViewColor
    }
    
    // 自动移动标签
    private func adjustLabelPosition(target label: UILabel){
        guard style.isTitleViewScrollEnabel else {
            return
        }
        
        var offset = label.center.x - bounds.width * 0.5
        if offset < 0 {
            offset = 0.0
        }
        
        if offset > scrollView.contentSize.width - bounds.width {
            offset = scrollView.contentSize.width - bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        
    }
}

extension XHPageTitleView: XHPageContentViewDelegate{
    public func contentView(_ contentView: XHPageContentView, inIndex: Int) {
        let beforeLabel = labels[currentIndex]
        let targetLabel = labels[inIndex]
        currentIndex = inIndex
        beforeLabel.textColor = style.unSelectedTitleColor
        targetLabel.textColor = style.selectedTitleColor
        
        // 自动移动标签到合适的位置
        adjustLabelPosition(target: targetLabel)
        
        // 移动bottomLine
        if style.isShowBottomLine {
            var bottomLineX = targetLabel.frame.origin.x
            var bottomLineW = targetLabel.frame.size.width
            if self.style.isTitleViewScrollEnabel {
                bottomLineX = targetLabel.frame.origin.x - self.style.titleMargin * 0.5
                bottomLineW = targetLabel.frame.size.width + self.style.titleMargin
            }
            self.bottomLine.frame.origin.x = bottomLineX
            self.bottomLine.frame.size.width = bottomLineW
        }
        
        // 缩放动画
        if style.isScaleEnable {
            beforeLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: style.maximumScale, y: style.maximumScale)
        }
        
        if style.isShowCoverView {
            var cover_x = targetLabel.frame.origin.x
            var cover_w = targetLabel.frame.width
            if style.isTitleViewScrollEnabel {
                cover_x -= style.coverViewMargin
                cover_w += style.coverViewMargin * 2
            }
            self.coverView.frame.origin.x = cover_x
            self.coverView.frame.size.width = cover_w

        }
        beforeLabel.backgroundColor = style.unSelectedTitleViewColor
        targetLabel.backgroundColor = style.selectedTitleViewColor
    }
    
    public func contentView(_ contentView: XHPageContentView, sourIndex: Int, targetIndex: Int, progress: CGFloat) {
        if sourIndex > titles.count - 1 || sourIndex < 0 {
            return
        }
        
        if targetIndex > titles.count - 1 || targetIndex < 0 {
            return
        }
        
        let beforeLabel = labels[sourIndex]
        let targetLabel = labels[targetIndex]
        let resultColor = UIColor.zh_color(old: style.selectedTitleColor, new: style.unSelectedTitleColor, progress: progress)
        print("resultColor : \(resultColor)")
        beforeLabel.textColor = resultColor
        targetLabel.textColor = UIColor.zh_color(old: style.unSelectedTitleColor, new: style.selectedTitleColor, progress: progress)
        
        // 自动移动标签到合适的位置
        adjustLabelPosition(target: targetLabel)
        
        // 移动bottomLine
        if style.isShowBottomLine {
            var bottomLineX = targetLabel.frame.origin.x
            var bottomLineW = targetLabel.frame.size.width
            if self.style.isTitleViewScrollEnabel {
                bottomLineX = targetLabel.frame.origin.x - self.style.titleMargin * 0.5
                bottomLineW = targetLabel.frame.size.width + self.style.titleMargin
            }
            let oldBottomLineX = self.bottomLine.frame.origin.x
            let oldBottomLineW = self.bottomLine.frame.size.width
            self.bottomLine.frame.origin.x = oldBottomLineX + (bottomLineX - oldBottomLineX) * progress
            self.bottomLine.frame.size.width = oldBottomLineW + (bottomLineW - oldBottomLineW) * progress
        }
        
        // 缩放动画
        if style.isScaleEnable {
            let deltaScale = style.maximumScale - (style.maximumScale - 1.0) * progress
            let scale = 1.0 + (style.maximumScale - 1.0) * progress
            beforeLabel.transform = CGAffineTransform(scaleX: deltaScale, y: deltaScale )
            targetLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        if style.isShowCoverView {
            var cover_x = targetLabel.frame.origin.x
            var cover_w = targetLabel.frame.width
            var oldCoverViewX = beforeLabel.frame.origin.x
            var oldCoverViewW = beforeLabel.frame.size.width
            if style.isTitleViewScrollEnabel {
                cover_x -= style.coverViewMargin
                cover_w += style.coverViewMargin * 2
                oldCoverViewX -= style.coverViewMargin
                oldCoverViewW += style.coverViewMargin * 2
            }
            self.coverView.frame.origin.x = oldCoverViewX + (cover_x - oldCoverViewX) * progress
            self.coverView.frame.size.width = oldCoverViewW + (cover_w - oldCoverViewW) * progress
        }
        
        beforeLabel.backgroundColor = UIColor.zh_color(old: style.selectedTitleViewColor, new: style.unSelectedTitleViewColor, progress: progress)
        targetLabel.backgroundColor = UIColor.zh_color(old: style.unSelectedTitleViewColor, new: style.selectedTitleViewColor, progress: progress)
    }
    
    
}


extension UIColor {
    // 根据系数颜色渐变
    static func zh_color(old beforColor: UIColor, new targetColor: UIColor, progress: CGFloat) -> UIColor{
        if beforColor.cgColor.alpha == 0 && targetColor.cgColor.alpha == 0{
            return UIColor.clear
        }
        let old_red = beforColor.zh_getRGB().0
        let old_green = beforColor.zh_getRGB().1
        let old_blue = beforColor.zh_getRGB().2
        
        let new_red = targetColor.zh_getRGB().0
        let new_green = targetColor.zh_getRGB().1
        let new_blue = targetColor.zh_getRGB().2
        
        let diffValue_red = new_red - old_red
        let diffValue_green = new_green - old_green
        let diffValue_blue = new_blue - old_blue
        
        let red = old_red + diffValue_red * progress
        let green = old_green + diffValue_green * progress
        let blue = old_blue + diffValue_blue * progress
        
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    func zh_getRGB() -> (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
