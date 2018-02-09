//
//  BLProductListViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/6.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit
import Moya

class BLProductListViewController: BaseViewController {

    class func viewController() -> BLProductListViewController {
        let vc = UIStoryboard.init(name: "BL-Product", bundle: nil).instantiateViewController(withIdentifier: "BLProductListViewController")
        
        return vc as! BLProductListViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getProductCategoryList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getProductCategoryList() {
        let provider = MoyaProvider<BLProductNetworkApi>()
        provider.request(.categorylist("", [1,3,5,7,9])) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                
                print("Response code: \(statusCode), data: \(data) ")
                
            case .failure(_):
                break
            }
        }
    }
}
