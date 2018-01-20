//
//  BLFamilyViewController.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/1/19.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class BLFamilyViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    @IBOutlet weak var moduleCollectionView: UICollectionView!
    
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    
    var moduleList : [BLModuleInfo] {
        //只显示设备类型的模块
        var tmp = [BLModuleInfo]()
        if let list = BLFamilyService.sharedInstance.moduleInfoList {
            for info in list {
                let type = info.moduleType
                if BLModuleInfo.isDeviceModuleType(type) {
                    tmp.append(info)
                }
            }
        }
        
        return tmp
    }
    
    class func viewController() -> BLFamilyViewController {
        let vc = UIStoryboard.init(name: "BL-Family", bundle: nil).instantiateViewController(withIdentifier: "BLFamilyViewController")
        
        return vc as! BLFamilyViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named : "navi_bg"), for: .default)
        
        let flowLayout = UICollectionViewFlowLayout();
        self.moduleCollectionView.collectionViewLayout = flowLayout
        self.moduleCollectionView.delegate = self
        self.moduleCollectionView.dataSource = self
        
        self.dispatchTimer_updateFamilyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //更新家庭信息页面
    private func updateFamilyView() {
        BLFamilyService.sharedInstance.queryCurrentFamilyAllInfo { (ret, msg) in
            if ret {
                DispatchQueue.main.async {
                    self.moduleCollectionView.reloadData()
                }
            }
        }
    }
    
    //定时10s更新UI
    private func dispatchTimer_updateFamilyView() {
        self.timer.schedule(deadline: .now(), repeating: 10)
        self.timer.setEventHandler {
            self.updateFamilyView()
        }
        self.timer.activate()
    }
    
    //删除指定item的模块
    private func deleteFamilyModuleView(item : Int) {
        let module = self.moduleList[item]
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "删除", style: .destructive, handler: { (action) in
            BLFamilyService.sharedInstance.deleteModuleFromFamily(moduleId: module.moduleId, delComplated: { (ret, msg) in
                if ret {
                    self.updateFamilyView()
                }
            })
        })
        
        let alert = UIAlertController(title: "⚠️注意", message: "是否要删除模块 ： \(module.name!) ？", preferredStyle: .alert)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0;
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0;
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 120)
    }
    
    //分组个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //CELL 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moduleList.count
    }

    //CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identify:String = "MODULE_CELL"
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath) as UICollectionViewCell
        
        let module = self.moduleList[indexPath.item]
        let img = cell.viewWithTag(101) as! UIImageView
        let label = cell.viewWithTag(102) as! UILabel
        
        if let path = module.iconPath {
            let url = URL(string: path)
            img.kf.setImage(with: url, placeholder: UIImage(named: "default_module_icon"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        label.text = module.name
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(BLFamilyViewController.collectionViewLongGesture(_:)))
        longGesture.minimumPressDuration = 1.0; //时间长短
        cell.tag = indexPath.item;  //将手势和cell的序号绑定
        cell.addGestureRecognizer(longGesture)
        
        return cell
    }
    
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index : \(indexPath.item)")
//        let module = self.moduleList[indexPath.item]
//        let type = module.moduleType
        //跳转到控制页面
    
    }
    
    //item 对应的长按事件
    @objc func collectionViewLongGesture(_ gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let item = gesture.view?.tag
            self.deleteFamilyModuleView(item: item!)
        default:
            break
        }
    }
    
}
