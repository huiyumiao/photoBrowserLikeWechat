//
//  PhotoBrowserMainScrollView.swift
//  photoBrowserLikeWechat
//
//  Created by 苗慧宇 on 20/12/2017.
//  Copyright © 2017 mhy. All rights reserved.
//

import UIKit

protocol PhotoBrowserMainScrollViewDelegate {
    /** 单击 */
    func photoBrowserMainScrollViewSingleTapped(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, imageFrame: CGRect)
    /** 翻页 */
    func photoBrowserMainScrollViewChangeCurrentIndex(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, currentIndex: Int)
    /** 向下拖拽 */
    func photoBrowserMainScrollViewDoingDownDrag(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, dragProportion: CGFloat)
    /** 需要退回页面 */
    func PhotoBrowserMainScrollViewNeedBack(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, imageFrame: CGRect)
}


class PhotoBrowserMainScrollView: UIView, UIScrollViewDelegate, PhotoBrowserSubScrollViewDelegate {
    
    var delegate: PhotoBrowserMainScrollViewDelegate?
    
    var imageNameArray: [String]?
    
    var currentImageIndex = 0
    
    var mainScrollView: UIScrollView?
    
    var scrollDoEvent = false
    
    var currentPoint = (0, 0)
    
    var currentEvent: UIEvent?
    
    init(frame: CGRect, imageNameArray: Array<String>, currentImageIndex: Int) {
        super.init(frame: frame)
        
        self.imageNameArray = imageNameArray
        self.currentImageIndex = currentImageIndex
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let MARGIN_BETWEEN_IMAGE: CGFloat = 20
    
    func setupUI() {
        backgroundColor = UIColor.clear
        
        /**
         *  滚动控件，包含所有图片，每一页是一张图片(但其实每个图片本身还包装了个scrollview用于缩放)
         */
        let mainScrollView = UIScrollView()
        self.addSubview(mainScrollView)
        self.mainScrollView = mainScrollView
        
        let width = self.frame.width
        mainScrollView.frame = CGRect(x: 0, y: 0, width:
            width + MARGIN_BETWEEN_IMAGE, height: self.frame.height)
        mainScrollView.layer.masksToBounds = false
        mainScrollView.contentSize = CGSize(width: CGFloat((imageNameArray?.count)!) * (width + MARGIN_BETWEEN_IMAGE), height: 0)
        mainScrollView.delegate = self
        mainScrollView.backgroundColor = UIColor.clear
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.isPagingEnabled = true
        if #available(iOS 11.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        }
        
        // MARK: - 添加图片容器
        for index in 0..<(imageNameArray?.count)! {
            let subScrollView = PhotoBrowserSubScrollView(
                frame: CGRect(x: CGFloat(index) * (self.frame.width + MARGIN_BETWEEN_IMAGE),
                              y: 0,
                              width: self.frame.width,
                              height: self.frame.height),
                imageName: imageNameArray![index]
            )
            mainScrollView.addSubview(subScrollView)
            subScrollView.delegate = self
            subScrollView.tag = index + 1
        }
        
        // 设置偏移量，即滚到当前用户选择的图片
        mainScrollView.contentOffset =
            CGPoint(x: CGFloat(currentImageIndex) * (self.frame.width + MARGIN_BETWEEN_IMAGE),
                    y: 0
        )
    }
    
    
    // MARK: - PhotoBrowserSubScrollViewDelegate
    func photoBrowserSubScrollViewDoSingleTapped(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, imageFrame: CGRect) {
        delegate?.photoBrowserMainScrollViewSingleTapped(self, imageFrame: imageFrame)
    }
    
    func photoBrowserSubScrollViewDoDownDrag(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, isBegin: Bool, needBack: Bool, imageFrame: CGRect) {
        if needBack {
            delegate?.PhotoBrowserMainScrollViewNeedBack(self, imageFrame: imageFrame)
        } else {
            for view in (mainScrollView?.subviews)! {
                guard view.tag != photoBrowserSubScrollView.tag else {
                    continue
                }
                view.isHidden = isBegin
            }
        }
    }
    
    func PhotoBrowserSubScrollViewDoSingleTapped(_ photoBrowserSubScrollView: PhotoBrowserSubScrollView, dragProportion: CGFloat) {
        delegate?.photoBrowserMainScrollViewDoingDownDrag(self, dragProportion: dragProportion)
    }
    
    
    // MARK: - UIScrollView Delegate
    // 减速完毕
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentImageIndex = Int(scrollView.contentOffset.x / self.frame.width)
      
        delegate?.photoBrowserMainScrollViewChangeCurrentIndex(self, currentIndex: currentImageIndex)
    }
}




