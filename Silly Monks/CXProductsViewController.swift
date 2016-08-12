//
//  CXProductsViewController.swift
//  Silly Monks
//
//  Created by Sarath on 04/06/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage
import mopub_ios_sdk
import CoreLocation
import LocationManager

class CXProductsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MPTableViewAdPlacerDelegate, MPInterstitialAdControllerDelegate {
    
    var mall: CX_AllMalls!
    var products: NSMutableArray!
    var productCategory: CX_Product_Category!
    var headerTitle:String!
    var placer: MPTableViewAdPlacer!
    var objects = [AnyObject]()

    
    var productsTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
  

        // Do any additional setup after loading the view.
    }
    
    //MARK: Add mopubs
    
    func setUpmopubs(){
        
        self.setupAdPlacer()
        
        // Data must be pre-populated into table for ads to appear
      /*  for _ in 1...10 {
            self.insertNewObject(self)
        }
        */

    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.productsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        // TODO: Depending on your use of UITableView, you will need to
        // add "mp_" to other method calls in addition to this one.
        // See http://t.co/mopub-ios-native-category for a list of
        // required replacements.
        self.productsTableView.mp_insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    
    func setupAdPlacer() {
        let targeting: MPNativeAdRequestTargeting! = MPNativeAdRequestTargeting()
        // TODO: Use the device's location
        targeting.location = CLLocation(latitude: 17.3850, longitude: 78.4867)
        
       /* LocationManager.getCurrentLocation().then { location in
            // targeting.location = CLLocation(latitude: 17.3850, longitude: 78.4867)

            targeting.location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }.error { error in
        }*/
        
        targeting.desiredAssets = Set([kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey])
        
        let settings = MPStaticNativeAdRendererSettings()
        // TODO: Create your own UIView subclass that implements MPNativeAdRendering
        settings.renderingViewClass = NativeAdCell.self
    
        // TODO: Calculate the size of your ad cell given a maximum width
        settings.viewSizeHandler = {(maxWidth: CGFloat) -> CGSize in
            return CGSizeMake(maxWidth, 250);
        };
        
        let config = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(settings)
        
        // TODO: Create your own UITableViewCell subclass that implements MPNativeAdRendering
      //  self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, rendererConfigurations: [config])
        
        let addPostion : MPClientAdPositioning = MPClientAdPositioning()
        addPostion.addFixedIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        addPostion.enableRepeatingPositionsWithInterval(6)
        
        self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, adPositioning: addPostion, rendererConfigurations: [config])
        
        // We have configured the test ad unit ID to place ads at fixed
        // cell positions 2 and 10 and show an ad every 10 cells after
        // that.
        //
        // TODO: Replace this test id with your personal ad unit id
        self.placer.loadAdsForAdUnitID(CXConstant.NATIVEADD_UNITI_ID, targeting: targeting)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.products = CXDBSettings.getProductsWithCategory(self.productCategory)
        self.customizeHeaderView()
        self.customizeMainView()

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

        let viewController: UIViewController = self.navigationController!.viewControllers[1]
        self.navigationController!.popToViewController(viewController, animated: true)

    }
    
    func customizeMainView() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        self.productsTableView = self.customizeTableView(CGRectMake(0, 0,screenWidth, self.view.frame.size.height))
        self.view.addSubview(self.productsTableView)
        self.setUpmopubs()

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
        //        let cell = tableView.mp_dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        var cell: CXProcuctTableViewCell! =  tableView.mp_dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as? CXProcuctTableViewCell
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
    
}