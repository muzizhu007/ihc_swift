//
//  BLAccountService.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/18.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLAccountService: NSObject {
    var userId : String?
    var loginSession : String?
    
    static let sharedInstance = BLAccountService()
    private override init() {
    }
    
    func login() {
        DispatchQueue.main.async {
            let mainVC = MainViewController.viewController()
            let delegate = (UIApplication.shared.delegate) as! AppDelegate
            delegate.window?.rootViewController = mainVC
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            let loginVc = BLAccountContainerViewController.viewController()
            let delegate = (UIApplication.shared.delegate) as! AppDelegate
            delegate.window?.rootViewController = loginVc
        }
    }
    
}
