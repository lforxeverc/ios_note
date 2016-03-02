//
//  DrawPan.swift
//  Demo
//
//  Created by jodo on 16/2/20.
//  Copyright © 2016年 jodo. All rights reserved.
//

import UIKit

class DrawPan: UIView {
    var layers:CAShapeLayer!
    var biz:UIBezierPath!
    var redirect = false
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
         Drawing code
    }
    */
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.whiteColor()
        draw()
    }
    

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let point = (touches.first?.locationInView(self))!
        let minX = CGFloat(0)
        let minY = CGFloat(0)
        let maxX = bounds.width
        let maxY = bounds.height
        if point.x > minX && point.x < maxX && point.y > minY && point.y < maxY{
            
            if redirect {
                biz.moveToPoint((touches.first?.locationInView(self))!)
                redirect = false
            }
            else{
            biz.addLineToPoint((touches.first?.locationInView(self))!)
            }
            
            layers.path = biz.CGPath
        }
        else{
        print("move \(point) \(minX) \(maxX) \(minY)  \(maxY)")
            redirect = true
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = (touches.first?.locationInView(self))!
        let minX = CGFloat(0)
        let minY = CGFloat(0)
        let maxX = bounds.width
        let maxY = bounds.height
        if point.x > minX && point.x < maxX && point.y > minY && point.y < maxY{
        biz.moveToPoint((touches.first?.locationInView(self))!)
        layers.path = biz.CGPath
        }
        else{
        print("start \(point) \(minX) \(maxX) \(minY)  \(maxY)")
        }
    }

    
    func Clean(){
        if layers != nil && biz != nil{
            layers.removeFromSuperlayer()
            draw()
            
        }
    }
    func draw(){
        layers = CAShapeLayer()
        layers.allowsEdgeAntialiasing = true
        layers.backgroundColor = UIColor.whiteColor().CGColor
        biz = UIBezierPath()
        layers.path = biz.CGPath
        layers.fillColor = UIColor.clearColor().CGColor
        layers.strokeColor = UIColor.blueColor().CGColor
        layers.lineWidth = 5
        self.layer.addSublayer(layers)
        

        
        
        
    }
    
    func save(){
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
    self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        super.drawLayer(layer, inContext: ctx)
        print("drawLayer")
    }
    

}


