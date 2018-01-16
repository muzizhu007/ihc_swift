//
//  BLAccountContainerViewController.swift
//  ihc_swift
//
//  Created by zjjllj on 2017/11/6.
//  Copyright © 2017年 zjjllj. All rights reserved.
//

import UIKit
import FSPagerView
import IQKeyboardManagerSwift

class BLAccountContainerViewController: BaseViewController,FSPagerViewDataSource,FSPagerViewDelegate {
    
    fileprivate let imageNames = ["login_banner1_CH","login_banner2_CH","login_banner3_CH"]
    var childNavigationController : UINavigationController!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
        }
    }
    
    @IBOutlet weak var pagerControl: FSPageControl! {
        didSet {
            self.pagerControl.numberOfPages = self.imageNames.count
            self.pagerControl.contentHorizontalAlignment = .right
            self.pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBOutlet weak var showView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewInit()
        pagerView.delegate = self
        pagerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func viewController() -> BLAccountContainerViewController {
        let vc = UIStoryboard.init(name: "BL-Account", bundle: nil).instantiateViewController(withIdentifier: "BLAccountContainerViewController")
        
        return vc as! BLAccountContainerViewController;
    }
    
    func viewInit() -> Void {
        let vc = BLSignInViewController.viewController()
        
        childNavigationController = UINavigationController.init(rootViewController: vc)
        childNavigationController.setNavigationBarHidden(true, animated: false)
        self.addChildViewController(childNavigationController)
        
        showView.addSubview(childNavigationController.view)
    }
    
    // MARK:- FSPagerView DataSource
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pagerControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
}
