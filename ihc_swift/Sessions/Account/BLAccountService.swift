//
//  BLAccountService.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/18.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLAccountService: NSObject {
    var userId : String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "userId")
        }
        set(newValue) {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "userId")
        }
    }

    var loginSession : String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: "loginSession")
        }
        set(newValue) {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "loginSession")
        }
    }
    
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
