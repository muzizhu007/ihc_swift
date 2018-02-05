//
//  BLDeviceListViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/2.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLDeviceListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var deviceListTableView: UITableView!
    
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    
    var moduleList : [String: [BLModuleInfo]] {
        
        //只显示设备类型的模块
        var tmp = [String: [BLModuleInfo]]()
        if let list = BLFamilyService.sharedInstance.moduleInfoList {
            for info in list {
                let type = info.moduleType
                if BLModuleInfo.isDeviceModuleType(type) {
                    let roomId = info.roomId
                    if var modules = tmp[roomId!] {
                        modules.append(info)
                        tmp[roomId!] = modules
                    } else {
                        tmp[roomId!] = [info]
                    }
                }
            }
        }
        
        return tmp
    }
    
    class func viewController() -> BLDeviceListViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLDeviceListViewController")
        
        return vc as! BLDeviceListViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "设备列表"
        // Do any additional setup after loading the view.
        self.deviceListTableView.delegate = self
        self.deviceListTableView.dataSource = self
        self.deviceListTableView.rowHeight = 70.0
        self.deviceListTableView.tableFooterView = UIView.init()
        
        let notificationName = Notification.Name(kDeviceStatusChangeNotification)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDeviceView),
                                               name: notificationName, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateDeviceView() {
        DispatchQueue.main.async {
            self.deviceListTableView.reloadData()
        }
    }
    
    private func changeStatusToText(status: BLDeviceStatusEnum) -> String {
        switch status {
        case .DEVICE_STATE_LAN:
            return "本地"
        case .DEVICE_STATE_REMOTE:
            return "远程"
        case .DEVICE_STATE_OFFLINE:
            return "离线"
        default:
            return "正在获取中..."
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(self.moduleList.keys).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = Array(self.moduleList.keys)[section]
        let modules = self.moduleList[key]
        
        return (modules?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        view.backgroundColor = UIColor.groupTableViewBackground
        
        let key = Array(self.moduleList.keys)[section]
        var roomName = "房间名称"
        for room in BLFamilyService.sharedInstance.roomInfoList! {
            if key == room.roomId {
                roomName = room.name
                break
            }
        }
        let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        label.text = roomName
        label.textColor = UIColor.lightGray
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "BLDEVICELISTCELL"
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identify, for: indexPath) as UITableViewCell
        
        let key = Array(self.moduleList.keys)[indexPath.section]
        let module = self.moduleList[key]![indexPath.row]
        let img = cell.viewWithTag(100) as! UIImageView
        let nameLabel = cell.viewWithTag(101) as! UILabel
        let deviceLabel = cell.viewWithTag(102) as! UILabel
        let statusLabel = cell.viewWithTag(103) as! UILabel
        
        if let path = module.iconPath {
            let url = URL(string: path)
            img.kf.setImage(with: url, placeholder: UIImage(named: "default_module_icon"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLabel.text = module.name
        
        if module.moduleDevs != nil {
            let moduleDev = module.moduleDevs.first
            let did = moduleDev?.did
            let sdid = moduleDev?.sdid
            
            if sdid != nil && sdid != "" {
                if let subDevice = BLDeviceService.sharedInstance.deviceInfoList[sdid!] {
                    deviceLabel.text = subDevice.name
                    statusLabel.text = self.changeStatusToText(status: subDevice.state)
                }
            } else if did != nil && did != "" {
                if let device = BLDeviceService.sharedInstance.deviceInfoList[did!] {
                    deviceLabel.text = device.name
                    statusLabel.text = self.changeStatusToText(status: device.state)
                }
            }
        }
        
        return cell
    }
    
    
}
