//
//  BLJSBridge.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/31.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation
import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc protocol BLJSBridgeJSExports : JSExport {
    func exec()
}

// Custom class must inherit from `NSObject`
@objc class BLJSBridge : NSObject, BLJSBridgeJSExports {
    func exec() {
        
    }
}
