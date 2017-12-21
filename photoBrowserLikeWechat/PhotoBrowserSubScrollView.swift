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

class PhotoBrowserSubScrollView: UIView {

    fileprivate var delegate: PhotoBrowserSubScrollViewDelegate?
    
    fileprivate var imageName: String?
    // 包装单个图片的scrollView
    fileprivate var mainScrollView: UIScrollView?
    fileprivate var mainImageView: UIImageView?
    
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
    fileprivate static let MAX_MOVE_OF_Y: CGFloat = 250.0
    // 当移动达到MAX_MOVE_OF_Y时，图片缩小的比例
    fileprivate static let IMAGE_MIN_ZOOM: CGFloat = 0.3
    
    /// 拖拽系数，手指移动距离和图片移动距离的系数，图片越高时它越大
    fileprivate static var dragCoefficient:CGFloat = 0.0;
    /// 向下拖拽手势开始时的X，在拖拽开始时赋值，拖拽结束且没有退回页面时置
    fileprivate static var panBeginX:CGFloat = 0.0;
    /// 向下拖拽手势开始时的Y，在拖拽开始时赋值，拖拽结束且没有退回页面时置0
    fileprivate static var panBeginY:CGFloat = 0.0;
    /// 向下拖拽开始时，图片的宽
    fileprivate static var imageWidthBeforeDrag:CGFloat = 0.0;
    /// 向下拖拽开始时，图片的高
    fileprivate static var imageHeightBeforeDrag:CGFloat = 0.0;
    /// 向下拖拽开始时，图片的中心X
    fileprivate static var imageCenterXBeforeDrag:CGFloat = 0.0;
    /// 向下拖拽开始时，图片的Y
    fileprivate static var imageYBeforeDrag:CGFloat = 0.0;
    /// 向下拖拽开始时，滚动控件的offsetX
    fileprivate static var scrollOffsetX:CGFloat = 0.0;
    
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        
        self.imageName = imageName
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(doubleTap)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
    }
    
    /// 单击图片
    @objc func singleTapped(recognizer: UITapGestureRecognizer) {
        
    }
    
    /// 双击图片
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        
    }
}
