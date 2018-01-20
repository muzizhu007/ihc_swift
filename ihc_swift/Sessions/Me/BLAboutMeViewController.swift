//
//  BLAboutMeViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/19.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLAboutMeViewController: BaseViewController {

    class func viewController() -> BLAboutMeViewController {
        let vc = UIStoryboard.init(name: "BL-Me", bundle: nil).instantiateViewController(withIdentifier: "BLAboutMeViewController")
        
        return vc as! BLAboutMeViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
