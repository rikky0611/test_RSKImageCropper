//
//  ViewController.swift
//  test_RSKImageCropper
//
//  Created by 荒川陸 on 2016/04/12.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import RSKImageCropper

var originalImage = UIImage(named:"castle.png")

class SampleViewController: UIViewController, RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource {
    @IBOutlet var ImageView : UIImageView!
    
    
    // トリミングする領域が四角の場合
    //var imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image:originalImage!, cropMode: RSKImageCropMode.Square)
    
    // トリミングする領域が円形の場合
    // var imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: originalImage!, cropMode: RSKImageCropMode.Custom)
    
    // トリミングする領域をカスタマイズする場合
    var imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: originalImage!, cropMode: RSKImageCropMode.Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        //self.presentViewController(imageCropVC, animated: true, completion: nil)
    }
    
    @IBAction func push(){
        self.presentViewController(imageCropVC, animated: true, completion: nil)
    }
    
    
    
    // キャンセルがおされたらトリミング画面を閉じる
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // トリミング前に呼ばれる
    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
    
    // トリミング済みの画像がかえる
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.ImageView.image = croppedImage
    }
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width: CGFloat!
        var height: CGFloat!
        
        width = self.view.frame.width/10
        // 正方形でトリミングしたい場合
        height = width
        
        maskSize = CGSizeMake(width, height)
        
        let viewWidth: CGFloat = CGRectGetWidth(controller.view.frame)
        let viewHeight: CGFloat = CGRectGetHeight(controller.view.frame)
        
        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        return maskRect
    }
    
    // トリミングしたい領域を描画
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let square: UIBezierPath = UIBezierPath()
        square.moveToPoint(point1)
        square.addLineToPoint(point2)
        square.addLineToPoint(point3)
        square.addLineToPoint(point4)
        square.closePath()
        
        return square
    }
    
    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
}