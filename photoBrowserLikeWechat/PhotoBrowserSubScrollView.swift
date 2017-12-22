//
//  PhotoBrowserSubScrollView.swift
//  photoBrowserLikeWechat
//
//  Created by 苗慧宇 on 20/12/2017.
//  Copyright © 2017 mhy. All rights reserved.
//

import UIKit

protocol PhotoBrowserSubScrollViewDelegate {
    
    /** 单击回调*/
    func photoBrowserSubScrollViewDoSingleTapped(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, imageFrame: CGRect)
    /** 开始或结束向下拖拽（外部需要隐藏其它图片，否则左右滑时会看到），needBack页面是否需要退回，imageFrame退回时用来做动画，不退回时可以不传 */
    func photoBrowserSubScrollViewDoDownDrag(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, isBegin: Bool, needBack: Bool, imageFrame: CGRect)
    /** 拖拽进行中额回调，把拖拽进度发下去，以设置透明度 */
    func PhotoBrowserSubScrollViewDoSingleTapped(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, dragProportion: CGFloat)
}

class PhotoBrowserSubScrollView: UIView, UIScrollViewDelegate {

    var delegate: PhotoBrowserSubScrollViewDelegate?
    
    fileprivate var imageName: String!
    
    fileprivate lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        
        let image = UIImage(named: imageName)
        let imageSize = image?.size
        let imageViewWidth = kScreenWidth
        let imageViewHeight = (imageSize?.height)! / (imageSize?.width)! * imageViewWidth
        
        imageView.frame.size = CGSize(width: imageViewWidth, height: imageViewHeight)
        imageView.image = image
        
        return imageView
    }()
    
    // 包装单个图片的scrollView
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clear
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true // 这是为了左右滑时能够及时回调scrollViewDidScroll代理
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        imageView.center = centerOfScrollViewContent(scrollView: scrollView)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        
        return scrollView
    }()
    
    // 双击
    fileprivate var doubleTap: UITapGestureRecognizer {
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.addTarget(self, action: #selector(doubleTapped(recognizer:)))
        return doubleTap
    }
    // 单击
    fileprivate var singleTap: UITapGestureRecognizer {
        let singleTap = UITapGestureRecognizer()
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.addTarget(self, action: #selector(singleTapped(recognizer:)))
        return singleTap
    }
    
    // 拖拽时的展示image
    fileprivate var moveImage: UIImageView?
    // 正在拖拽
    fileprivate var doingPan = false
    // 正在缩放，此时不执行拖拽方法
    fileprivate var doingZoom = false
    // 拖拽比例
    fileprivate var comProprotion: CGFloat = 0
    // 拖拽是不是正在向下，如果是，退回页面，否则，弹回
    var directionIsDown = false
    
    // 最多移动多少时，页面完全透明，图片达到最小状态
    fileprivate let MAX_MOVE_OF_Y: CGFloat = 250.0
    // 当移动达到MAX_MOVE_OF_Y时，图片缩小的比例
    fileprivate let IMAGE_MIN_ZOOM: CGFloat = 0.3
    
    /// 拖拽系数，手指移动距离和图片移动距离的系数，图片越高时它越大
    fileprivate var dragCoefficient: CGFloat = 0.0
    /// 向下拖拽手势开始时的X，在拖拽开始时赋值，拖拽结束且没有退回页面时置
    fileprivate var panBeginX: CGFloat = 0.0
    /// 向下拖拽手势开始时的Y，在拖拽开始时赋值，拖拽结束且没有退回页面时置0
    fileprivate var panBeginY: CGFloat = 0.0
    /// 向下拖拽开始时，图片的宽
    fileprivate var imageWidthBeforeDrag: CGFloat = 0.0
    /// 向下拖拽开始时，图片的高
    fileprivate var imageHeightBeforeDrag: CGFloat = 0.0
    /// 向下拖拽开始时，图片的中心X
    fileprivate var imageCenterXBeforeDrag: CGFloat = 0.0
    /// 向下拖拽开始时，图片的Y
    fileprivate var imageYBeforeDrag: CGFloat = 0.0
    /// 向下拖拽开始时，滚动控件的offsetX
    fileprivate var scrollOffsetX: CGFloat = 0.0
    
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        
        self.imageName = imageName
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(doubleTap)
        
        self.backgroundColor = UIColor.clear
        scrollView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 计算imageview的center，核心方法之一
    ///
    /// - Parameter scrollView: 图片容器 scrollView
    /// - Returns: 缩放后图片的 center
    fileprivate func centerOfScrollViewContent(scrollView: UIScrollView) -> CGPoint {
        let offsetX = (scrollView.bounds.width > scrollView.contentSize.width) ?
            (scrollView.bounds.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = (scrollView.bounds.height > scrollView.contentSize.height) ?
            (scrollView.bounds.height - scrollView.contentSize.height) * 0.5 : 0
        
        let actualCenter = CGPoint(x: offsetX + scrollView.contentSize.width * 0.5,
                                   y: offsetY + scrollView.contentSize.height * 0.5)
        
        return actualCenter
    }
    
    /// 核心方法：存储拖拽开始前，图片的frame
    fileprivate func cacheImageViewFrameBeforeDragging() {
        imageWidthBeforeDrag  = imageView.frame.width
        imageHeightBeforeDrag = imageView.frame.height
        imageYBeforeDrag = (imageHeightBeforeDrag < kScreenHeight) ?
            (kScreenHeight - imageHeightBeforeDrag) * 0.5 : 0
        imageCenterXBeforeDrag = imageWidthBeforeDrag * 0.5 - scrollView.contentOffset.x
        dragCoefficient = 1 + imageHeightBeforeDrag / 2000
    }
    
    fileprivate func draggingAction(panGes: UIPanGestureRecognizer) {
        
    }
    
    /// 单击图片
    @objc func singleTapped(recognizer: UITapGestureRecognizer) {
        
    }
    
    /// 双击图片
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        
    }
    
    // MARK: - UIScrollView delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfScrollViewContent(scrollView: scrollView)
        doingZoom = false
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        doingZoom = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollNewY: CGFloat = 0
        var scrollOldY: CGFloat = 0
        scrollNewY = scrollView.contentOffset.y
        if (scrollNewY < 0 || doingPan) && !doingZoom {
            // doPan
        }
        scrollOldY = scrollNewY
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // endPan()
    }
}
