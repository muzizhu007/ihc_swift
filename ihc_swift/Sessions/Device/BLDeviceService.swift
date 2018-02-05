//
//  BLDeviceService.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/2.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation

class BLDeviceService: NSObject, BLControllerDelegate {
    
    var deviceInfoList : [String: BLDNADevice] = [String: BLDNADevice]()
        
    static let sharedInstance = BLDeviceService()
    private override init() {
        super.init()
        BLLet.shared().controller.delegate = self
    }
    
    func updateLocalDevices() {
        
        if BLFamilyService.sharedInstance.deviceInfoList != nil && BLFamilyService.sharedInstance.deviceInfoList!.count > 0 {
            for familyDevice in BLFamilyService.sharedInstance.deviceInfoList! {
                let device = self.changeFamilyDeviceToLocal(familyDevice: familyDevice)
                if let localDevice = self.deviceInfoList[device.did] {
                    localDevice.controlId = device.controlId
                    localDevice.controlKey = device.controlKey
                    
                    self.deviceInfoList[device.did] = localDevice
                } else {
                    self.deviceInfoList[device.did] = device
                }
            }
        }
        
        if BLFamilyService.sharedInstance.subdevInfoList != nil && BLFamilyService.sharedInstance.subdevInfoList!.count > 0 {
            for familyDevice in BLFamilyService.sharedInstance.subdevInfoList! {
                let device = self.changeFamilyDeviceToLocal(familyDevice: familyDevice)
                if let localDevice = self.deviceInfoList[device.did] {
                    localDevice.controlId = device.controlId
                    localDevice.controlKey = device.controlKey
                    
                    self.deviceInfoList[device.did] = localDevice
                } else {
                    self.deviceInfoList[device.did] = device
                }
            }
        }
        
        BLLet.shared().controller.addDeviceArray(Array(self.deviceInfoList.values))
    }
    
    //将家庭信息里的设备信息转化为BLDNADevice
    private func changeFamilyDeviceToLocal(familyDevice: BLFamilyDeviceInfo) -> BLDNADevice {
        let device = BLDNADevice.init()
        
        if familyDevice.sDid != nil && familyDevice.sDid != "" {
            device.did = familyDevice.sDid
            device.pDid = familyDevice.did
        } else {
            device.did = familyDevice.did
        }
        
        device.mac = familyDevice.mac
        device.pid = familyDevice.pid
        device.name = familyDevice.name
        device.password = UInt(familyDevice.password)
        device.type = UInt(familyDevice.type)
        device.controlId = UInt(familyDevice.terminalId)
        device.controlKey = familyDevice.aesKey
        
        return device
    }
    
    //BLControllerDelegate
    func shouldAdd(_ device: BLDNADevice) -> Bool {
        return false
    }
    
    func onDeviceUpdate(_ device: BLDNADevice, isNewDevice: Bool) {
        //按照本地扫描到的设备信息为主
        if self.deviceInfoList[device.did] != nil {
            self.deviceInfoList[device.did] = device
        }
    }

    func statusChanged(_ device: BLDNADevice, status: BLDeviceStatusEnum) {
        //按照本地扫描到的设备信息为主
        if self.deviceInfoList[device.did] != nil {
            self.deviceInfoList[device.did] = device
            
            let notificationName = Notification.Name(kDeviceStatusChangeNotification)
            NotificationCenter.default.post(name: notificationName, object: self, userInfo: nil)
        }
    }
}
