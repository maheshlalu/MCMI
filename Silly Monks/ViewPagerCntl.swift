//
//  ViewPagerCntl.swift
//  Silly Monks
//
//  Created by Rama kuppa on 15/08/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class ViewPagerCntl: UIViewController {
    var product:CX_Products!
    var productCategory:CX_Product_Category!
    var products: NSMutableArray!
    @IBOutlet var pager: SHViewPager!
    var itemIndex : NSInteger!
    override func viewDidLoad() {
        super.viewDidLoad()
        products = CXDBSettings.getProductsWithCategory(productCategory)
        products.exchangeObjectAtIndex(itemIndex, withObjectAtIndex: 0)

        pager.frame = CGRectMake(0, 0, self.view.frame.size.width, UIScreen.mainScreen().bounds.size.height)
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
        
        self.customizeHeaderView()
        //self.view.backgroundColor = UIColor.greenColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CXConstant.restrictRotation(true)
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.addTarget(self, action: #selector(ViewPagerCntl.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = self.productCategory.name
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func backAction() {
        let viewController: UIViewController = self.navigationController!.viewControllers[1]
        self.navigationController!.popToViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      pager.pagerWillLayoutSubviews()
//        pager.moveToTargetIndex(itemIndex)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewPagerCntl : SHViewPagerDataSource{
 
    func numberOfPagesInViewPager(viewPager: SHViewPager!) -> Int {
        return CXDBSettings.getProductsWithCategory(productCategory).count
    }
    
    func containerControllerForViewPager(viewPager: SHViewPager!) -> UIViewController! {
        return self
    }
    
    
    func viewPager(viewPager: SHViewPager!, controllerForPageAtIndex index: Int) -> UIViewController! {
        
         let product: CX_Products = products [index] as! CX_Products
        let vc : SMDetailViewController = SMDetailViewController()
         vc.product = product
        vc.productCategory = productCategory
        return vc
    }
    
}

extension ViewPagerCntl:SHViewPagerDelegate{
    
    
}
