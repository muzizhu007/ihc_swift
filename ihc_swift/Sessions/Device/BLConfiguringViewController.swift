//
//  BLConfiguringViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/8.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit
import UICircularProgressRing

class BLConfiguringViewController: BaseViewController {

    @IBOutlet weak var circularProgressView: UICircularProgressRingView!
    
    class func viewController() -> BLConfiguringViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLConfiguringViewController")
        
        return vc as! BLConfiguringViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BLDeviceService.sharedInstance.canEasyConfigDevice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startConfigDevice(ssid: String, password: String,
                           callback: @escaping (_ ret: Bool, _ device: BLDNADevice?) -> ()) {

        BLDeviceService.sharedInstance.easyConfigDevice(ssid: ssid, password: password) { (ret, msg, device) in
            self.updateUI()
            callback(ret, device)
        }
        
        self.animateTheViews()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.circularProgressView.setProgress(value: 100, animationDuration: 1)
        }
    }
    
    private func viewInit() {
        circularProgressView.animationStyle = kCAMediaTimingFunctionLinear
        circularProgressView.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func animateTheViews() {
        
        // You can set the animationStyle like this
        circularProgressView.setProgress(value: 100, animationDuration: 120, completion: nil)
    }
    
}
