//
//  BLSignInViewController.swift
//  ihc_swift
//
//  Created by zjjllj on 2017/11/7.
//  Copyright © 2017年 zjjllj. All rights reserved.
//

import UIKit
import SVProgressHUD

class BLSignInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let phone = phoneTextField.text
        let password = passwordTextField.text
        
        let blLet = BLLet.shared()
        
        SVProgressHUD.show(withStatus: "正在加载...")
        blLet?.account.login(phone!, password: password!, completionHandler: { (result) in
            print("Login Error:\(result.error) Msg:\(result.msg)")
            SVProgressHUD.dismiss()
            if result.succeed() {
                // 存储 userId 和 loginSession
                BLAccountService.sharedInstance.userId = result.userid
                BLAccountService.sharedInstance.loginSession = result.loginsession
                // 跳转到主页面
                BLAccountService.sharedInstance.login()
            }
        })
    }
    
    class func viewController() -> BLSignInViewController {
        let vc = UIStoryboard.init(name: "BL-Account", bundle: nil).instantiateViewController(withIdentifier: "BLSignInViewController")
        
        return vc as! BLSignInViewController;
    }
    
    
}
