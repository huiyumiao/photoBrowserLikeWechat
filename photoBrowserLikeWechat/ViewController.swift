//
//  ViewController.swift
//  photoBrowserLikeWechat
//
//  Created by 苗慧宇 on 20/12/2017.
//  Copyright © 2017 mhy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let imageNameArray = ["01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg"]
    
    fileprivate lazy var imageViewArray = {
        return [UIImageView]()
    }()
    
    fileprivate lazy var imageFrameArray = {
        return [NSValue]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUIComponent()
    }
    
    func setupUIComponent() {
        view.backgroundColor = UIColor(rgbValue: 0xdddddd)

        let leftRightMargin: CGFloat    = 15.0//左右间距
        let marginBetweenImage: CGFloat = 10.0// 图片间间距
        let imageWidth = (UIScreen.main.bounds.size.width - 2 * leftRightMargin - 2 * marginBetweenImage) / 3.0//图片宽
        let imagesBeginY: CGFloat = 100
        let imageHeight: CGFloat  = imageWidth / 3.0 * 2.0// 图片高
        
        for index in 0..<imageNameArray.count {
            let imageView = UIImageView()
            view.addSubview(imageView)
            imageViewArray.append(imageView)
            
            let row = CGFloat(index / 3)
            let col = CGFloat(index % 3)
            imageView.frame = CGRect(
                x: leftRightMargin + col * (imageWidth + marginBetweenImage),
                y: imagesBeginY + row * (imageHeight + marginBetweenImage),
                width: imageWidth,
                height: imageHeight
            )
            
            saveWindowFrameBy(originalFrame: imageView.frame)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.image = UIImage(named: imageNameArray[index])
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(
                UITapGestureRecognizer(target: self,
                                       action: #selector(clickImage(recognizer:)))
            )
        }
    }
    
    /** 根据图片再view中的位置，算出在window中的位置，并保存 */
    func saveWindowFrameBy(originalFrame: CGRect) {
        // 因为这里恰好在view中的位置就是在window中的位置，所以不需要转frame
        // 因为数组不能存结构体，所以存的时候转成 NSValue
        let frameValue = NSValue(cgRect: originalFrame)
        imageFrameArray.append(frameValue)
    }
    
    /** 点击了图片 */
    @objc func clickImage(recognizer: UITapGestureRecognizer) {
        let tag = recognizer.view?.tag
        print("image at: \(tag!) was clicked")
        
        let photoBrowserVC = PhotoBrowserViewController(imageNameArray: imageNameArray,
                                                        currentImageIndex: tag!,
                                                        imageViewArray: imageViewArray,
                                                        imageFrameArray: imageFrameArray)
        self.present(photoBrowserVC,
                     animated: true,
                     completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

