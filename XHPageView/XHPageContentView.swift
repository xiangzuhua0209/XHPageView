//
//  XHPageContentView.swift
//  XHFM
//
//  Created by xiangzuhua on 2021/5/13.
//

import UIKit

/// ContentView的协议，容器视图滑动过程中需要与titleView视图做同步处理，通过实现这些要求，可以做到事件的处理同步。这是一个公开的协议，可以在外部实现协议的要求，来达到你的目的。
public protocol XHPageContentViewDelegate {
    
    /// 容器视图滑动结束后，会触发此方法
    /// - Parameters:
    ///   - contentView: 容器视图
    ///   - inIndex: 滑动结束，容器视图当前显示的子控制器的下标值
    func contentView(_ contentView: XHPageContentView, inIndex:Int)
    
    /// 容器视图滑动过程中，会触发次方法
    /// - Parameters:
    ///   - contentView: 容器视图
    ///   - sourIndex: 开始滑动时当前呈现子控制器的下标值
    ///   - targetIndex: 将要滑向的自控制器的下标值
    ///   - progress: 滑动的百分比
    func contentView(_ contentView: XHPageContentView, sourIndex: Int, targetIndex: Int, progress: CGFloat)
}

private let cellID = "XHPageContentView_CellID"
public class XHPageContentView: UIView{
    
    public var delegate: XHPageContentViewDelegate?
    public var reloader: XHPageViewReloadable?// 刷新协议的对象
    
    /// 初始化所需的配置
    public var style: XHPageViewStyle
    public var viewControllers: [UIViewController]
    public var startIndex: Int
    
    /// 将要滑动前容器视图的偏移量，用于计算滑动方向
    public var startOffsetX: CGFloat = 0
    
    private (set) public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        if #available(iOS 10, *){
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    public init(frame: CGRect, style: XHPageViewStyle, viewControllers: [UIViewController], startIndex: Int) {
        self.style = style
        self.viewControllers = viewControllers
        self.startIndex = startIndex
        super.init(frame: frame)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let layout = collectionView.collectionViewLayout as!UICollectionViewFlowLayout
        layout.itemSize = bounds.size
        collectionView.contentOffset = CGPoint(x: CGFloat(startIndex) * bounds.size.width, y: 0)
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

extension XHPageContentView{
    private func setupUI(){
        addSubview(collectionView)
        collectionView.backgroundColor = style.contentViewBackgroundColor
        collectionView.isScrollEnabled = style.isContentScrollEnabled
    }
}

extension XHPageContentView: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        // 重用之前已存在的，cell去掉之前的子视图
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let childViewController = viewControllers[indexPath.row]
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
        return cell
    }
}

extension XHPageContentView: UICollectionViewDelegate{
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateUI(scrollView)
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        collectionViewDidEndScroll(scrollView)
//    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll(scrollView)
    }
    
    private func collectionViewDidEndScroll(_ scrollView: UIScrollView) {
        let inIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        reloader = viewControllers[inIndex] as? XHPageViewReloadable
        reloader?.contentViewDidEndScroll()
        
        delegate?.contentView(self, inIndex: inIndex)
    }
    
    private func updateUI(_ scrollView: UIScrollView){
        var progress: CGFloat = 0.0
        var targetIndex: Int = 0
        var sourceIndex: Int = 0
        // truncatingRemainder 对浮点数取余
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if scrollView.contentOffset.x > startOffsetX {// 向左滑
            targetIndex = index + 1
            sourceIndex = index
            if targetIndex > viewControllers.count - 1 {
                return
            }
        } else {
            targetIndex = index - 1
            sourceIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }
        
        if progress > 0.998 {
            progress = 1
        }
        print("progress----:\(progress)")
        delegate?.contentView(self, sourIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    
}


extension XHPageContentView: XHPageTitleViewDelegate{
    
    public func titleView(_ titleView: XHPageTitleView, current index: Int) {
        if index > viewControllers.count - 1 {
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    public func titleView(_ titleView: XHPageTitleView, doubleSelected index: Int) {
        if index > viewControllers.count - 1 {
            return
        }
        
        reloader = viewControllers[index] as? XHPageViewReloadable
        reloader?.didSelectedSameTile(index)
    }
    
    
}
