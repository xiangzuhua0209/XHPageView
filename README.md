# XHPageView
## 功能介绍
XHPageView简单的说就是选项卡，多个标题选项对应多个控制器，用在新闻和商城App较多，看图应该更容易明白
![录制](./Assets/h1.gif)

## 使用介绍
#### 简述
总共三个文件分别是：
* 标题控件类 - XHPageTitleView,主要是实现了标题栏的UI展示、点击事件处理及动画等功能
* 容器视图 - XHPageTitleView,使用UICollectionview装载子控制器的视图，实现了按整屏分页滑动并显示的功能
* 主控件视图 - XHPageView,将XHPageTitleView和XHPageTitleView结合到一起，实现了一个可点击切换、可滑动切换的标题切换器

>在XHPageView中还定义了一个很重要的类：XHPageViewStyle
>简单的说是一个配置文件，但是通过它可以设置标题栏的很多UI属性，比如标题颜色、大小，label的背景色、缩放比例等；也可以设置功能属性，比如是否可以滑动、是否可以缩放、是否有底部滑动栏等。

#### 集成XHPageView
这一步简单描述一下，创建项目后，使用终端 cd 到项目文件夹中，创建Podfile，在Podfile像下面这样写

```
platform :ios,'13.0'
 target 'Test' do
 use_frameworks!
 inhibit_all_warnings!
 pod 'XHPageView', '~> 1.0.2'
end
```
然后 pod install 就可以了
>注意 XHPageView是从iOS 13开始支持的

#### 初始化一个标题切换器
直接看代码!!!
首先引入XHPageView
```
import XHPageView
```
然后创建样式
```
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

```
接着创建初始化XHPageView必须的标题和子控制器
```
        let titles = ["推荐","分类","VIP","直播","广播"]
        
        let VCs = [ZHHomeRecommendVC(),
        ZHHomeClassifyVC(),
        ZHHomeVIPViewController(),
        ZHHomeShowViewController(),
        ZHHomeBroadcastVC()]
        
        for vc in VCs {
            self.addChild(vc)
        }
```
最后初始化XHPageView并展示
```
        let rect:CGRect = CGRect(x: 0.0, y: ZHNavigationBarHeight, width: ZHScreenWidth, height: ZHScreenHeight - ZHNavigationBarHeight - ZHTabBarHeight)
        let pageView = XHPageView(rect, titles: titles, style: style, viewControllers: VCs)
        view.addSubview(pageView)
```
如此便可以得到一个标题切换器，是不是很简单!
