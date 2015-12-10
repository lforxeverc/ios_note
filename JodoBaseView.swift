//
//  JodoBaseView.swift
//
//  Created by jodo on 15/9/24.
//  Copyright © 2015年 Jodo. All rights reserved.
//

import UIKit

class JodoBaseView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    Drawing code
    }
    */
    var rect:CGRect?
    
    override func drawRect(rect: CGRect) {
        let contentSize = rect
        
        let screenSize = UIScreen.mainScreen().bounds.size
        var w = screenSize.width
        var h = screenSize.height
        
        //兼容iOS7横屏状态宽高不自动改变的情况
        let version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        if version < 8.0 && UIApplication.sharedApplication().statusBarOrientation.isLandscape {
            w = screenSize.height
            h = screenSize.width
        }

            if contentSize.height < h-20 && contentSize.width < w{
                //暂时不拉伸
                //暂时不拉伸
                //                let scaleX = (screenSize.width-20)/contentSize.width
                //                let scaleY = (screenSize.height-40)/contentSize.height
                //                if scaleX > scaleY {
                //                    self.frame = CGRectMake((screenSize.width - contentSize.width*scaleY)/2 , 30, contentSize.width*scaleY, contentSize.height * scaleY)
                //                }
                //                else{
                //                    self.frame = CGRectMake(10, (screenSize.height - 20 - contentSize.height)/2 + 20 , contentSize.width * scaleX, contentSize.height * scaleX)
                //                
                //                }
            }
            else{
            
            let scaleX = (w-20) / contentSize.width
            let scaleY = (h-40) / contentSize.height
                if scaleX <= scaleY{
                    self.frame = CGRectMake(10, (h - 20)/2 - contentSize.height * scaleX/2, w-20, contentSize.height * scaleX )
                }
                else{
                    let originX = w/2-contentSize.width*scaleY/2
                    self.frame = CGRectMake(originX, 30, contentSize.width*scaleY, h - 40 )
                
                }
                }
                
            
            
            self.center = CGPointMake(w/2, -100)
            UIView.animateWithDuration(0.5) {
                self.center = CGPointMake(w/2, (h-20)/2)
            }
        }
    
    
}
