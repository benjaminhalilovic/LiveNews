//
//  HKUtils.swift
//  Huskatalogen
//
//  Created by Demir Blazevic on 8/29/16.
//  Copyright © 2016 Walter Solutions. All rights reserved.
//

import Foundation
import UIKit


class HKUtils: NSObject {
    
    class func isIOS8OrHigher() -> Bool {
        let os_version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        return ( os_version >= 8.000000)
    }
    
    class func isIOS7OrLower() -> Bool {
        let os_version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        return ( os_version < 8.000000)
    }
    
    class func appDisplayName() -> String? {
        if let bundle = NSBundle.mainBundle().infoDictionary {
            return bundle["CFBundleDisplayName"] as! String?
        }
        
        return nil
    }
    
}

func closure_onmain(closure: () -> ()) {
    if (NSThread.isMainThread()) {
        closure();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), closure);
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


/*extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}*/

extension UIImage  {

}