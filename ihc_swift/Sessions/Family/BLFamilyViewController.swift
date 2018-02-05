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

class BLFamilyViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {

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
        
        var rightImg = UIImage(named: "icon_add")
        rightImg = rightImg?.withRenderingMode(.alwaysOriginal)
        let rightItem = UIBarButtonItem(image: rightImg, style: .plain, target: self, action: #selector(BLFamilyViewController.popRightItemView(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
        
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
    
    //修改左上角显示item
    private func updateLeftBarItem() {
        let leftItem = UIBarButtonItem(title: BLFamilyService.sharedInstance.familyBaseInfo?.familyName, style: UIBarButtonItemStyle.plain, target: self, action: #selector(BLFamilyViewController.popLeftItemView(_:)))
        leftItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    //更新家庭信息页面
    private func updateFamilyView() {
        BLFamilyService.sharedInstance.queryCurrentFamilyAllInfo { (ret, msg) in
            if ret {
                DispatchQueue.main.async {
                    self.updateLeftBarItem()
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
    
    //item 对应的长按事件
    @objc private func collectionViewLongGesture(_ gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let item = gesture.view?.tag
            self.deleteFamilyModuleView(item: item!)
        default:
            break
        }
    }
    
    //右上角弹出页面
    @objc private func popRightItemView(_ sender: Any) {
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 100, height: 50)
        
        let addDeviceBtn = UIButton(frame: CGRect(x: 10, y: 15, width: 80, height: 20))
        addDeviceBtn.tag = 101
        addDeviceBtn.addTarget(self, action: #selector(BLFamilyViewController.buttonClick(_:)), for: UIControlEvents.touchUpInside)
        addDeviceBtn.setTitle("添加设备", for: UIControlState.normal)
        addDeviceBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        
        vc.view.addSubview(addDeviceBtn)
        
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = self as UIPopoverPresentationControllerDelegate
        ppc?.barButtonItem = navigationItem.rightBarButtonItem
        ppc?.sourceView = sender as? UIView
        
        present(vc, animated: true, completion: nil)
    }
    
    //左上角弹出页面
    @objc private func popLeftItemView(_ sender: Any) {
        let allFamilyIdList = BLFamilyService.sharedInstance.allFamilyInfoList!
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 100, height: 20 + 30 * allFamilyIdList.count)
        
        for (index, _) in allFamilyIdList.enumerated() {
            
            let familyBtn = UIButton(frame: CGRect(x: 10, y: 15 + 30 * index, width: 80, height: 20))
            familyBtn.tag = 200 + index
            familyBtn.addTarget(self, action: #selector(BLFamilyViewController.buttonClick(_:)), for: UIControlEvents.touchUpInside)
            familyBtn.setTitle("家庭 \(index)", for: UIControlState.normal)
            familyBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            
            vc.view.addSubview(familyBtn)
        }
        
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = self as UIPopoverPresentationControllerDelegate
        ppc?.barButtonItem = navigationItem.leftBarButtonItem
        ppc?.sourceView = sender as? UIView
        
        present(vc, animated: true, completion: nil)
    }
    
    //按钮点击事件
    @objc private func buttonClick(_ sender: UIButton) {
        print("button tag : \(sender.tag)")
        
        switch sender.tag {
        case 101:
            print("添加设备")
        case 200..<300:
            let index = sender.tag - 200
            BLFamilyService.sharedInstance.currentFamilyId = BLFamilyService.sharedInstance.allFamilyInfoList![index].familyId
            updateFamilyView()
        default:
            break
        }
        
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
