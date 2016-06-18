//
//  CXProductsViewController.swift
//  Silly Monks
//
//  Created by Sarath on 04/06/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage

class CXProductsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var mall: CX_AllMalls!
    var products: NSMutableArray!
    var productCategory: CX_Product_Category!
    var headerTitle:String!
    
    var productsTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.products = CXDBSettings.getProductsWithCategory(self.productCategory)
        self.customizeHeaderView()
        self.customizeMainView()


        // Do any additional setup after loading the view.
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(CXProductsViewController.backAction), forControlEvents: .TouchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func customizeMainView() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        self.productsTableView = self.customizeTableView(CGRectMake(0, 0,screenWidth, self.view.frame.size.height))
        self.view.addSubview(self.productsTableView)
    }

    func customizeTableView(tFrame: CGRect) -> UITableView {
        let tabView:UITableView = UITableView.init(frame: tFrame)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.backgroundColor = UIColor.clearColor()
        tabView.registerClass(CXProcuctTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tabView.separatorStyle = UITableViewCellSeparatorStyle.None
        tabView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        tabView.showsVerticalScrollIndicator = false
        tabView.scrollEnabled = true
        return tabView;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "ProductCell"
        
        var cell: CXProcuctTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXProcuctTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CXProcuctTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXProcuctTableViewCell
            cell.backgroundColor = UIColor.smBackgroundColor()
        }
        let produkt = self.products[indexPath.row] as? CX_Products
        self.configureProductCell(cell, product: produkt!)
        return cell;
    }
    
    
    /*
     
     */
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CXConstant.PRODUCT_CELL_HEIGHT;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let product: CX_Products = self.products[indexPath.row] as! CX_Products
        let detailView = SMDetailViewController.init()
        detailView.product = product
        detailView.productCategory = self.productCategory
        self.navigationController?.pushViewController(detailView, animated: true)

    }
    
    func configureProductCell(cell: CXProcuctTableViewCell,product:CX_Products) {
        let prodImage :String = self.getInitialAttachmentProduct(product)
        
        cell.productImageView.sd_setImageWithURL(NSURL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
        cell.productDesc.text =  CXDBSettings.getProductInfo(product)
    }

    
    func getInitialAttachmentProduct(product: CX_Products) -> String {
        let attachements : NSArray = CXDBSettings.getProductAttachments(product)
        var prodImgUrl = ""
        if attachements.count > 0 {
            let attachment:NSDictionary = attachements.objectAtIndex(0) as! NSDictionary
            prodImgUrl = attachment.valueForKey("URL") as! String
        }
        return prodImgUrl
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
