//
//  BLDeviceAddToFamilyViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/9.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLDeviceAddToFamilyViewController: BaseViewController {
    
    var device: BLDNADevice?

    @IBOutlet weak var showLabel: UILabel!
    
    class func viewController() -> BLDeviceAddToFamilyViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLDeviceAddToFamilyViewController")
        
        return vc as! BLDeviceAddToFamilyViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if device != nil {
            self.showLabel.text = "新设备Did:\n \(self.device!.did!)"
        } else {
            self.showLabel.text = "未发现设备"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
