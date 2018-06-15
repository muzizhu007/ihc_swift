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
    var localDeviceList : [String: BLDNADevice] = [String: BLDNADevice]()
    
    let queue = DispatchQueue(label: "com.broadlink.config")
    var deviceConfigState = false

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
    
    func easyConfigDevice(ssid: String, password: String,
                          callback: @escaping (_ ret: Bool, _ msg: String, _ device: BLDNADevice?) -> ()) {
        
        self.queue.async {
            self.localDeviceList.removeAll()
            
            let result: BLDeviceConfigResult = BLLet.shared().controller.deviceConfig(ssid, password: password, version: 3, timeout: 75)
            print("Config Device Msg:\(result.msg!) status:\(result.error)")
            if result.succeed() {
                print("Device IP:\(result.devaddr!) DID:\(result.did!)")
                
                self.deviceConfigState = true
                while self.deviceConfigState {
                    if let device = self.localDeviceList[result.did] {
                        callback(result.succeed(), result.msg, device)
                        self.deviceConfigState = false
                    }
                    sleep(1)
                }
                
            } else {
                callback(result.succeed(), result.msg, nil)
            }
        }
    }
    
    func canEasyConfigDevice() {
        BLLet.shared().controller.deviceConfigCancel()
        self.deviceConfigState = false
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
        
        self.localDeviceList[device.did] = device
    }

    func statusChanged(_ device: BLDNADevice, status: BLDeviceStatusEnum) {
        print("======================Device Did:\(device.did!) state:\(device.state.rawValue)")
        //按照本地扫描到的设备信息为主
        if self.deviceInfoList[device.did] != nil {
            self.deviceInfoList[device.did] = device
            
            let notificationName = Notification.Name(kDeviceStatusChangeNotification)
            NotificationCenter.default.post(name: notificationName, object: self, userInfo: nil)
        }
    }
}
