//
//  BLSignInViewController.swift
//  ihc_swift
//
//  Created by zjjllj on 2017/11/7.
//  Copyright © 2017年 zjjllj. All rights reserved.
//

import UIKit

class BLSignInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        let phone = phoneTextField.text
        let password = passwordTextField.text
        
        let blLet = BLLet.shared()
        blLet?.account.login(phone!, password: password!, completionHandler: { (result) in
            print("Login Error:\(result.error) Msg:\(result.msg)")
            
            if result.succeed() {
                // 跳转到主页面
                
            }
        })
    }
    
    class func viewController() -> BLSignInViewController {
        let vc = UIStoryboard.init(name: "BL-Account", bundle: nil).instantiateViewController(withIdentifier: "BLSignInViewController")
        
        return vc as! BLSignInViewController;
    }
    
    
}
