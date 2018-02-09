//
//  BLConfigureWifiViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/8.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BLConfigureWifiViewController: BaseViewController {

    @IBOutlet weak var ssidInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    
    class func viewController() -> BLConfigureWifiViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLConfigureWifiViewController")
        
        return vc as! BLConfigureWifiViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ssidInputField.text = "BroadLink_ZJJ"
        self.passwordInputField.text = "1234567890"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWiFiInfo() -> (String, String) {
        return (self.ssidInputField.text!, self.passwordInputField.text!)
    }
}
