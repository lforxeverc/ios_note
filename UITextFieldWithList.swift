//
//  UITextFieldWithList.swift
//  Chrom
//
//  Created by jodo on 16/1/7.
//  Copyright © 2016年 jodo. All rights reserved.
//

import UIKit

class UITextFieldWithList: UIView {
    var actionDelegate:ActionDelegate?
    var listview:UITableView!//the dropdown list
    lazy var tfAccount:UITextField! = UITextField()// input textfield
    lazy var tfPsw:UITextField! = UITextField()
    lazy var accountRBtn:UIImageView! = UIImageView()// btn in the textfield
    lazy var pswRBtn = UIButton()
    lazy var wholeFrame:CGRect! = CGRectZero//
    lazy var listTopMargin:CGFloat = 1 // the margin between textfield and drop down list
    lazy var canShowList = false
    //    var showBtnImage:UIImage?{
    //        didSet{
    //            self.showBtn.setBackgroundImage(self.showBtnImage, forState: UIControlState.Normal)
    //        }
    //    }
    
    lazy var showBtnRightMargin:CGFloat = 10 //
    var listframe:CGRect! = CGRectZero
    var data:[[String:AnyObject]] = [] {
        didSet{
            self.canShowList = ( self.data.count != 0)
            
            let cell = UITableViewCell()
            let high = cell.frame.height * CGFloat(data.count)
            print("cell high = \(high) max = \(100)")
            listHight = high
            if listHight > 100 {
                listHight = 100
            }
            
            self.listview.frame = listframe
        }
    }
    var listHight:CGFloat = 0
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    
    func setup(){
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        canShowList = data.count != 0
        wholeFrame = self.frame
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.masksToBounds = true
        self.tfAccount = UITextField(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: (self.frame.height - 1) / 2))
        self.tfAccount.delegate = self
        self.tfAccount.textColor = UIColor.lightGrayColor()
        self.tfAccount.leftView = padding
        self.tfAccount.leftViewMode = .Always
        self.addSubview(self.tfAccount)
        
        
//        self.accountRBtn.setImage(UIImage(named: "JodoDrop", inBundle: ResBundle.getResBundle(), compatibleWithTraitCollection: nil), forState: UIControlState.Normal)
//        self.accountRBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
////        self.accountRBtn.setTitle("  ", forState: UIControlState.Normal)
//        self.accountRBtn.sizeToFit()
//        
//        self.accountRBtn.addTarget(self, action: "clickAccountBtn", forControlEvents: UIControlEvents.TouchUpInside)
        self.accountRBtn.image = UIImage(named: "JodoDrop", inBundle: ResBundle.getResBundle(), compatibleWithTraitCollection: nil)
        self.accountRBtn.frame = CGRect(origin: self.accountRBtn.frame.origin, size: CGSize(width: self.accountRBtn.frame.width + 30, height: self.accountRBtn.frame.height))
        self.accountRBtn.contentMode = .Center
        self.accountRBtn.userInteractionEnabled = true
        self.accountRBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickAccountBtn"))
        self.tfAccount.rightView = self.accountRBtn
        self.tfAccount.rightViewMode = UITextFieldViewMode.Always
        self.tfAccount.keyboardType = UIKeyboardType.ASCIICapable
        
        
        let div = UILabel(frame: CGRect(x: 0, y: self.frame.height / 2 , width: self.frame.width, height: 1))
        div.backgroundColor = UIColor.grayColor()
        self.addSubview(div)
        
        self.tfPsw = UITextField(frame:CGRect(x: 0 , y: (self.frame.height / 2 + 1), width: self.frame.width, height: (self.frame.height - 1) / 2))
        //        self.tfPsw.backgroundColor = UIColor.lightGrayColor()
        self.tfPsw.delegate = self
        self.tfPsw.textColor = UIColor.lightGrayColor()
        self.tfPsw.secureTextEntry = true
        
        
        self.addSubview(self.tfPsw)
        let padding1 =  UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.tfPsw.leftView = padding1
        self.tfPsw.leftViewMode = .Always
        self.pswRBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        self.pswRBtn.setTitle("Default", forState: UIControlState.Normal)
        self.pswRBtn.sizeToFit()
        
        self.pswRBtn.addTarget(self, action: "clickPswBtn", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tfPsw.rightView = self.pswRBtn
        self.tfPsw.rightViewMode = UITextFieldViewMode.Always
        
        
        
        
        
        self.listview = UITableView(frame: CGRectZero)
        self.listview.backgroundColor = UIColor.whiteColor()
        self.listview.frame = listframe
        self.listview.delegate = self
        self.listview.dataSource = self
        self.listview.bounces = false
        self.listview.hidden = true
        self.listview.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
        
    }
    func sendUpdateViewNoti(hide:Bool){
        self.listview.hidden = hide
        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        if hide{
            shake.fromValue = NSNumber(float: 0)
            
            shake.toValue = NSNumber(double: M_PI)
        }
        else{
            shake.fromValue = NSNumber(double: M_PI)
            
            shake.toValue = NSNumber(double: 0)
        }
        
        shake.removedOnCompletion = false
        shake.duration = 0.2
        shake.cumulative = true
        shake.fillMode = kCAFillModeForwards
        
        self.accountRBtn.layer.addAnimation(shake , forKey: nil)
    }
    
    
    func clickAccountBtn(){
        
        data = JodoAccount2DB.sharedInstance().getAccountNPsws()
        listframe = CGRect(x: self.frame.origin.x + 5, y: (self.frame.height / 2 + 1) + self.frame.origin.y, width: self.frame.width - 10, height: self.listHight)
        self.listview.frame = listframe
        self.superview?.addSubview(listview)
        if canShowList{
            self.listview.hidden = !self.listview.hidden
            sendUpdateViewNoti(self.listview.hidden)
        }
        else{
            self.tfAccount.placeholder = "no tips"
        }
        
        
    }
    
    func clickPswBtn(){
        actionDelegate?.pswRightBtnClick()
    }

    
}
@objc protocol ActionDelegate:NSObjectProtocol{
    func accountRightBtnClick()
    func pswRightBtnClick()
}

extension UITextFieldWithList:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tfAccount.text = JodoAccount2DB.sharedInstance().getAccount(indexPath.row)
        self.tfPsw.text = JodoAccount2DB.sharedInstance().getPsw(indexPath.row)
        sendUpdateViewNoti(true)
    }
    
}

//class UITextFieldRightView : UITextField {
//    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
//        super.rightViewRectForBounds(bounds)
//    }
//}

extension UITextFieldWithList : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return (data.count)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell()
        let lab = UILabel()
        lab.text = JodoAccount2DB.sharedInstance().getAccount(indexPath.row)
        lab.font = UIFont.systemFontOfSize(14)
        lab.sizeToFit()
        lab.center.y = (cell.center.y)
        lab.frame.origin.x = 20
        cell.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(lab)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
}

extension UITextFieldWithList:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.tfAccount.resignFirstResponder()
        sendUpdateViewNoti(true)
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
    }
}


