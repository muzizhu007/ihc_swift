//
//  BLNetworkCommonHeader.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/6.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation

struct BLNetworkCommonHeader : Codable {
    var userid: String = BLAccountService.sharedInstance.userId!
    var loginsession: String = BLAccountService.sharedInstance.loginSession!
    var familyid: String = BLFamilyService.sharedInstance.currentFamilyId!
    var licenseid: String = BLLet.shared().configParam.licenseId!
    var language: String = "ch"
    var system: String = "ios11"
    var appplatform: String = "bl"
    var appversion: String = "0.1"
    var locate: String = "中国"
}
