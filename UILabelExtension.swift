//
//  UILabelExtension.swift
//
//  Created by jodo on 15/12/1.
//  Copyright © 2015年 jodo. All rights reserved.
//

import UIKit

class UILabelExtension: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) //UIEdgeInsetsZero
    @IBInspectable
    var paddingLeft:CGFloat {
        
        get{return padding.left}
        set{padding.left = newValue}
        
    }
    @IBInspectable
    var paddingTop:CGFloat {
        get{return padding.top}
        set{padding.top = newValue}
        
    }
    @IBInspectable
    var paddingRight:CGFloat {
        get{return padding.right}
        set{padding.right = newValue}
        
    }
    @IBInspectable
    var paddingBottom:CGFloat {
        get{return padding.bottom}
        set{padding.bottom = newValue}
        
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    

}
