//
//  BLConfigureProgressViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/8.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit

class BLConfigureProgressViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let kRatio = 0.768
    let kScale = 0.889
    
    var startVC: BLConfigureStartViewController?
    var configureWifiVC: BLConfigureWifiViewController?
    var configringVC: BLConfiguringViewController?
    var configDevice: BLDNADevice?

    var subViewControllers: [Any?] = []
    var selectIndex = 0
    
    class func viewController() -> BLConfigureProgressViewController {
        let vc = UIStoryboard.init(name: "BL-Device", bundle: nil).instantiateViewController(withIdentifier: "BLConfigureProgressViewController")
        
        return vc as! BLConfigureProgressViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewInit()
        self.startVC = BLConfigureStartViewController.viewController()
        self.configureWifiVC = BLConfigureWifiViewController.viewController()
        self.configringVC = BLConfiguringViewController.viewController()
        self.subViewControllers.append(self.startVC)
        self.subViewControllers.append(self.configureWifiVC)
        self.subViewControllers.append(self.configringVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectIndex = 0
        self.collectionView.scrollToItem(at: IndexPath.init(item: selectIndex, section: 0), at: .centeredHorizontally, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var discLayout: BLDiscPickFlowLayout!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        switch selectIndex {
        case 0:
            selectIndex += 1
        case 1:
            selectIndex += 1
            self.configuringDeviceWiFi()
        default:
            break
        }
        
        self.collectionView.scrollToItem(at: IndexPath.init(item: selectIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func configuringDeviceWiFi() {
        self.updateBottomButton(state: false, device: nil)
        //开始配网
        let (ssid, password) = (self.configureWifiVC?.getWiFiInfo())!
        self.configringVC?.startConfigDevice(ssid: ssid, password: password, callback: { (ret, device)  in
            self.configDevice = device
            self.updateBottomButton(state: ret, device: device)
        })
    }
    
    private func updateBottomButton(state: Bool, device: BLDNADevice?) {
        DispatchQueue.main.async {
            if state {
                self.bottomButton.setTitle("下一步", for: .normal)
                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.isEnabled = true
                
                let addDeviceVC = BLDeviceAddToFamilyViewController.viewController()
                addDeviceVC.device = device
                
                self.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(addDeviceVC, animated: true)
            } else {
                self.bottomButton.setTitle("配置设备", for: .normal)
                self.bottomButton.backgroundColor = UIColor.gray
                self.bottomButton.isEnabled = false
            }
        }
    }
    
    private func viewInit() {
        self.title = "设备配置"
        discLayout.scale = kScale
        discLayout.minimumInteritemSpacing = 0
        discLayout.minimumLineSpacing = 0
        discLayout.scrollDirection = .horizontal
        let size = self.view.bounds.size
        discLayout.headerReferenceSize = CGSize.init(width: size.width * CGFloat((1 - kRatio) / 2), height: size.height)
        discLayout.footerReferenceSize = self.discLayout.headerReferenceSize
        discLayout.scaleWidth = Double(size.width)
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        bottomButton.setTitle("下一步", for: .normal)
    }
    
    // MARK: --- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "CELL"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let vc = self.subViewControllers[indexPath.row] as! UIViewController
        
        if !cell.contentView.subviews.contains(vc.view) {
            cell.contentView.addSubview(vc.view)
            vc.view.frame = cell.contentView.bounds
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.bounds.size
        return CGSize.init(width: size.width * CGFloat(kRatio), height: size.height * CGFloat(kRatio))
    }
}
