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
    @IBOutlet var pager: SHViewPager!
    override func viewDidLoad() {
        super.viewDidLoad()
        pager.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
        self.view.backgroundColor = UIColor.greenColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pager.pagerWillLayoutSubviews()
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
        
         let product: CX_Products = CXDBSettings.getProductsWithCategory(productCategory) [index] as! CX_Products
        let vc : SMDetailViewController = SMDetailViewController()
         vc.product = product
        vc.productCategory = productCategory
        return vc
    }
    
}

extension ViewPagerCntl:SHViewPagerDelegate{
    
    
}
