//
//  BLSceneViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/6/15.
//  Copyright © 2018 zjjllj. All rights reserved.
//

import UIKit

class BLSceneViewController: BaseViewController {

    class func viewController() -> BLSceneViewController {
        let vc = UIStoryboard.init(name: "BL-Scene", bundle: nil).instantiateViewController(withIdentifier: "BLSceneViewController")
        
        return vc as! BLSceneViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
