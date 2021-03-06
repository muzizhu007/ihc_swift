//
//  BLFamilyService.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/18.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation

class BLFamilyService: NSObject {
    
    var currentFamilyId : String?
    var currentFamilyVersion : String?
    
    var allFamilyInfoList : [BLFamilyIdInfo]?
    var familyBaseInfo : BLFamilyInfo?
    var roomInfoList : [BLRoomInfo]?
    var moduleInfoList : [BLModuleInfo]?
    var deviceInfoList : [BLFamilyDeviceInfo]?
    var subdevInfoList : [BLFamilyDeviceInfo]?
    
    static let sharedInstance = BLFamilyService()
    private override init() {}

    func queryFamilyIdList(idComplated: @escaping (_ ret: Bool, _ msg : String, _ needInfo: Bool) -> ()) {
        
        BLLet.shared()?.familyManager.queryLoginUserFamilyIdList { (result) in
            var needQuery = false
            if (result.succeed()) {
                
                if let idlist = result.idList {
                    self.allFamilyInfoList = result.idList
                    
                    if self.currentFamilyId == nil {
                        //获取第一个家庭
                        let familyInfo = idlist.first
                        self.currentFamilyId = familyInfo?.familyId
                        self.currentFamilyVersion = familyInfo?.familyVersion
                        needQuery = true
                    } else {
                        //遍历家庭信息，查找知道familyId的家庭信息
                        for familyInfo in result.idList {
                            if self.currentFamilyId == familyInfo.familyId {
                                if self.currentFamilyVersion != familyInfo.familyVersion {
                                    self.currentFamilyVersion = familyInfo.familyVersion
                                    needQuery = true
                                    break
                                }
                            }
                        }
                    }
                }
            } else {
                print("Failed Msg: \(result.msg!) Status : \(result.error)")
            }
            idComplated(result.succeed(), result.msg, needQuery)
        }
    }
    
    func queryAllFamilyInfo(familyId : String, infoComplated: @escaping (_ infoRet: Bool, _ infoMsg : String) -> ()) {
        
        BLLet.shared()?.familyManager.queryFamilyInfo(withIds: [familyId]) { (result) in
            if (result.succeed()) {
                //获取家庭的所有信息
                let familyAllInfo = result.allFamilyInfoArray.first
                self.familyBaseInfo = familyAllInfo?.familyBaseInfo
                self.roomInfoList = familyAllInfo?.roomBaseInfoArray
                self.moduleInfoList = familyAllInfo?.moduleBaseInfo
                self.deviceInfoList = familyAllInfo?.deviceBaseInfo
                self.subdevInfoList = familyAllInfo?.subDeviceBaseInfo
                
                BLDeviceService.sharedInstance.updateLocalDevices()
            } else {
                print("Failed Msg: \(result.msg!) Status : \(result.error)")
            }
            infoComplated(result.succeed(), result.msg)
        }
        
    }
    
    func queryCurrentFamilyAllInfo(complated: @escaping (_ ret: Bool, _ msg : String) -> ()) {
        
        self.queryFamilyIdList(idComplated: { (idret, idmsg, need) in
            if idret && need {
                self.queryAllFamilyInfo(familyId: self.currentFamilyId!, infoComplated: { (infoRet, infoMsg) in
                    complated(infoRet, infoMsg)
                })
            } else {
                complated(false, idmsg)
            }
        })
        
    }
    
    func deleteModuleFromFamily(moduleId : String, delComplated: @escaping (_ ret: Bool, _ msg : String) -> ()) {
        
        BLLet.shared()?.familyManager.delModule(withId: moduleId, fromFamilyId: currentFamilyId!, familyVersion: currentFamilyVersion!, completionHandler: { (result) in
            delComplated(result.succeed(), result.msg)
        })
    }
}
