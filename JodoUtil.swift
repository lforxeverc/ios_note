//
//  JodoUtil.swift
//  jodoSDK
//
//  Created by desmo on 15/10/10.
//  Copyright © 2015年 jodo. All rights reserved.
//

import Foundation


//获取当前页面的viewController
func getVc()->UIViewController{
    var vc:UIViewController?
    var mwindow = UIApplication.sharedApplication().keyWindow
    
    let windows:[UIWindow] = UIApplication.sharedApplication().windows
    for w in windows
    {
        if w.windowLevel == UIWindowLevelNormal{
            mwindow = w
            break
        }
    }
    
    let mview:UIView! = mwindow!.subviews.first
    
    let responder = mview?.nextResponder()
    
    if responder != nil {
        if responder?.isKindOfClass(UIViewController) != nil {
            vc = responder as? UIViewController
            
        }
    }
    else{
        vc = mwindow!.rootViewController!
    }
    return vc!
    
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

class ResBundle{
    static func getResBundle()->NSBundle{
        let path = NSBundle.mainBundle().pathForResource("jodoSDKRes", ofType: "bundle")
        let bundle = NSBundle(path: path!)
        return bundle!
    }
}