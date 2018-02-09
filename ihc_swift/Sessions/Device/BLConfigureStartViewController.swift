//
//  BLConfigureStartViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/8.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLConfigureStartViewController: BaseViewController {

    class func viewController() -> BLConfigureStartViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLConfigureStartViewController")
        
        return vc as! BLConfigureStartViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.introductionLabel.text = "设备配网介绍 设备配网介绍 设备配网介绍 设备配网介绍 设备配网介绍 设备配网介绍 设备配网介绍 "
        self.pilotLampLabel.text = "设备配网说明 设备配网说明 设备配网说明 设备配网说明 设备配网说明 设备配网说明 设备配网说明 "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var pilotLampLabel: UILabel!
    
    @IBAction func lampStatusAction(_ sender: UIButton) {
        
    }
    
}
