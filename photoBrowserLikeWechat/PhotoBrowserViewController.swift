//
//  PhotoBrowserViewController.swift
//  photoBrowserLikeWechat
//
//  Created by 苗慧宇 on 20/12/2017.
//  Copyright © 2017 mhy. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    fileprivate var imageNameArray: [String]!
    
    fileprivate var currentImageIndex: Int = 0
    
    fileprivate var imageViewArray: [UIImageView]?
    
    fileprivate var imageViewFrameArray: [NSValue]?
    
    fileprivate lazy var mainScrollView: PhotoBrowserMainScrollView = {
        let mScroll = PhotoBrowserMainScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), imageNameArray: imageNameArray, currentImageIndex: currentImageIndex)
        view.addSubview(mScroll)
        mScroll.delegate = self
        mScroll.isHidden = true
        return mScroll
    }()
    
    fileprivate var transition: PhotoBrowserTransition = {
        let transition = PhotoBrowserTransition()
        return transition
    }()
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - imageNameArray: 图片名数组
    ///   - currentImageIndex: 当前点击的第几个
    ///   - imageViewArray: 页面里图片控件数组，这里需要是因为，转场时，要隐藏对应的
    ///   - imageFrameArray: 页面里图片控件在window中的frame，包装成数组传进来，转场时需要
    init(imageNameArray: Array<String>,
         currentImageIndex: Int,
         imageViewArray: Array<UIImageView>,
         imageFrameArray: Array<NSValue>) {

        self.imageNameArray      = imageNameArray
        self.currentImageIndex   = currentImageIndex
        self.imageViewArray      = imageViewArray
        self.imageViewFrameArray = imageFrameArray

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("图片浏览器销毁")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
        view.backgroundColor = UIColor(rgbValue: 0x000000)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoBrowserViewController: PhotoBrowserMainScrollViewDelegate {
    func photoBrowserMainScrollViewSingleTapped(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, imageFrame: CGRect) {
        
    }
    
    func photoBrowserMainScrollViewChangeCurrentIndex(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, currentIndex: Int) {
        
    }
    
    func photoBrowserMainScrollViewDoingDownDrag(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, dragProportion: CGFloat) {
        
    }
    
    func PhotoBrowserMainScrollViewNeedBack(_ photoBrowserMainScrollView: PhotoBrowserMainScrollView, imageFrame: CGRect) {
        
    }
}
