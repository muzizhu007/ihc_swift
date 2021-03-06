//
//  MainViewController.swift
//  ihc_swift
//
//  Created by zjjllj on 2017/11/5.
//  Copyright © 2017年 zjjllj. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    class func viewController() -> MainViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        let familyVC = BLFamilyViewController.viewController()
        let fc = UINavigationController(rootViewController: familyVC)
        vc.setTabBarItem(item: fc.tabBarItem, title: "家", image: "tab_home_normal", selected_image: "tab_home_selected")
        
        let sceneVC = BLSceneViewController.viewController()
        let sc = UINavigationController(rootViewController: sceneVC)
        vc.setTabBarItem(item: sc.tabBarItem, title: "场景", image: "tab_scene_normal", selected_image: "tab_scene_selected")
        
        let deviceVC = BLDeviceListViewController.viewController()
        let dc = UINavigationController(rootViewController: deviceVC)
        vc.setTabBarItem(item: dc.tabBarItem, title: "设备", image: "tab_device_normal", selected_image: "tab_device_selected")
        
        let meVC = BLAboutMeViewController.viewController()
        let mc = UINavigationController(rootViewController: meVC)
        vc.setTabBarItem(item: mc.tabBarItem, title: "我", image: "tab_me_normal", selected_image: "tab_me_selected")

        let controllers = [fc, sc, dc, mc]
        vc.viewControllers = controllers
        return vc;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setTabBarItem(item : UITabBarItem, title : String, image : String, selected_image : String) {
        
        item.title = title
        item.image = UIImage(named: image)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item.selectedImage = UIImage(named: selected_image)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.gray], for: .normal)
        item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], for: .selected)
        
        
    }
    
}
