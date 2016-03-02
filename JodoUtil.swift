//
//  JodoUtil.swift
//  jodoSDK
//
//  Created by desmo on 15/10/10.
//  Copyright © 2015年 jodo. All rights reserved.
//

import Foundation


//aler
func aler(title:String , msg:String){
    
    let av = UIAlertView()
    av.title = title
    av.message = msg
    av.addButtonWithTitle(String.keyForValue("confirm"))
    av.show()
}
func runOnMainThread(thread:(()->Void)?,main:(()->Void)?){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
        //        block 一些耗时操作
        if thread != nil{
            thread!()
        }
        dispatch_async(dispatch_get_main_queue()){
            //        主线程结果处理
            if main != nil{
                main!()
            }
            
        }
        
    }
}

func runOnMainThread(main main:(()->Void)?){
    runOnMainThread(nil, main: main)
}

//获取当前页面的viewController
func getVc()->UIViewController?{
    
    var vc:UIViewController?
    //    var mwindow = UIApplication.sharedApplication().keyWindow
    //
    //    let windows:[UIWindow] = UIApplication.sharedApplication().windows
    //    for w in windows
    //    {
    //        if w.windowLevel == UIWindowLevelNormal{
    //            mwindow = w
    //            break
    //        }
    //    }
    //
    //    let mview:UIView! = mwindow!.subviews.first
    //
    //    let responder = mview?.nextResponder()
    //
    //    if responder != nil {
    //        if responder?.isKindOfClass(UIViewController) != nil {
    //            vc = responder as? UIViewController
    //
    //        }
    //    }
    //    else{
    //        vc = mwindow!.rootViewController!
    //    }
    if var topController = UIApplication.sharedApplication().delegate?.window!!.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
            print("top = \(topController)")
        }
        if topController.isKindOfClass(UITabBarController) {
            topController = (topController as! UITabBarController).selectedViewController!
        }
        
        if topController.isKindOfClass(UINavigationController){
            
        }
        
        vc = topController
        // topController should now be your topmost view controller
    }
    return vc!
    
}

public func toast(msg:String?){
    
    var msgShow = "Error!"
    if msg != nil {
        msgShow = msg!
    }
    let vc = getVc()
    if vc == nil {
        return
    }
    
    let view = vc!.view
    let lab = UILabelExtension()
    lab.text = msgShow
    lab.sizeToFit()
    lab.layer.cornerRadius = 5
    lab.layer.masksToBounds = true
    lab.textColor = UIColor.whiteColor()
    lab.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.6)
    let size = UIScreen.mainScreen().bounds.size
    let cx = size.width / 2
    let cy = size.height - 100
    let selfSize = lab.frame.size
    if size.width <= selfSize.width {
        lab.lineBreakMode = .ByWordWrapping
        lab.numberOfLines = 0
        let s = lab.sizeThatFits(CGSizeMake(size.width - 40 , size.height))
        lab.frame = CGRect(origin: lab.frame.origin, size: s)
    }
    
    runOnMainThread(nil, main: {
        view.addSubview(lab)
        lab.center = CGPointMake(cx, cy)
        lab.alpha = 0
        UIView.animateWithDuration(1, animations: {
            lab.alpha = 1
            }, completion: {
                _ in
                UIView.animateWithDuration(1, animations: {
                    lab.alpha = 0
                    }, completion: {
                        _ in
                        
                        lab.removeFromSuperview()
                })
        })
    })
    
    
    
    
}

func data2Json(data:NSData)->[String:AnyObject]?{
    do { let dic = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! [String:AnyObject]
        return dic
    }
    catch{
        print("Json Error")
        return nil
    }
}


func getCurrentView() ->UIView{
    var window = UIApplication.sharedApplication().keyWindow
    if(window?.windowLevel != UIWindowLevelNormal){
        let windows = UIApplication.sharedApplication().windows
        for tempwindow in windows{
            if tempwindow.windowLevel == UIWindowLevelNormal{
                window = tempwindow
                break
            }
        }
        
    }
    let frontView = window?.subviews.first
    return frontView!
}


import UIKit
import Security

class Keychain {
    
    class func save(key: String, data: NSData) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    class func load(key: String) -> NSData? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ]
        
        var dataTypeRef: AnyObject?
        let status = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = dataTypeRef as! NSData? {
                return data
            }
        }
        return nil
    }
    
    class func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    
    class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
}

//获取ip
public func getIFAddresses() -> String {
    var addresses = [String]()
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddr) == 0 {
        
        // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
            let flags = Int32(ptr.memory.ifa_flags)
            var addr = ptr.memory.ifa_addr.memory
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    var ret = ""
    if addresses.count > 0 {
        ret = addresses.first!
    }
    
    return ret
}

//截屏
func screenshot(v:UIView){
    //    UIGraphicsGetCurrentContext()
    UIGraphicsBeginImageContextWithOptions(v.bounds.size, true, 0.0)
    v.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    toast(String.keyForValue("savealbum"))
}

class ResBundle{
    static func getResBundle()->NSBundle{
        let path = NSBundle.mainBundle().pathForResource("jodoSDKRes", ofType: "bundle")
        let bundle = NSBundle(path: path!)
        return bundle!
    }
    
    
}

