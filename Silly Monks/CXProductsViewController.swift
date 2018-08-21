//
//  CXProductsViewController.swift
//  Silly Monks
//
//  Created by Sarath on 04/06/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage
//import mopub_ios_sdk
import CoreLocation

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
        self.products = CXDBSettings.getProductsWithCategory(self.productCategory)
        self.customizeHeaderView()
        self.customizeMainView()

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
    
    func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date() as AnyObject, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.productsTableView.insertRows(at: [indexPath], with: .automatic)
        
        // TODO: Depending on your use of UITableView, you will need to
        // add "mp_" to other method calls in addition to this one.
        // See http://t.co/mopub-ios-native-category for a list of
        // required replacements.
        self.productsTableView.mp_insertRows(atIndexPaths: [indexPath], with: .automatic)
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
            return CGSize(width: maxWidth, height: 250);
        };
        
        let config = MPStaticNativeAdRenderer.rendererConfiguration(with: settings)
        
        // TODO: Create your own UITableViewCell subclass that implements MPNativeAdRendering
      //  self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, rendererConfigurations: [config])
        
        let addPostion : MPClientAdPositioning = MPClientAdPositioning()
        addPostion.addFixedIndexPath(IndexPath(row: 0, section: 0))
        addPostion.enableRepeatingPositions(withInterval: 6)
        
        self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, adPositioning: addPostion, rendererConfigurations: [config])
        
        // We have configured the test ad unit ID to place ads at fixed
        // cell positions 2 and 10 and show an ad every 10 cells after
        // that.
        //
        // TODO: Replace this test id with your personal ad unit id
        self.placer.loadAds(forAdUnitID: CXConstant.NATIVEADD_UNITI_ID, targeting: targeting)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   

    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(lImage, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(CXProductsViewController.backAction), for: .touchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.fixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 40);
        tLabel.backgroundColor = UIColor.clear
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = self.productCategory.name
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.textColor = UIColor.white
        self.navigationItem.titleView = tLabel
        
    }
    
    func backAction() {

        let viewController: UIViewController = self.navigationController!.viewControllers[1]
        self.navigationController!.popToViewController(viewController, animated: true)

    }
    
    func customizeMainView() {
        let screenWidth = UIScreen.main.bounds.size.width
        self.productsTableView = self.customizeTableView(CGRect(x: 0, y: 0,width: screenWidth, height: self.view.frame.size.height))
        self.view.addSubview(self.productsTableView)
//        self.setUpmopubs()

    }

    func customizeTableView(_ tFrame: CGRect) -> UITableView {
        let tabView:UITableView = UITableView.init(frame: tFrame)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.backgroundColor = UIColor.clear
        tabView.register(CXProcuctTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tabView.separatorStyle = UITableViewCellSeparatorStyle.none
        tabView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.contentInset = UIEdgeInsetsMake(0, 0, 65, 0)
        tabView.showsVerticalScrollIndicator = false
        tabView.isScrollEnabled = true
        return tabView;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ProductCell"
        //        let cell = tableView.mp_dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        var cell: CXProcuctTableViewCell! =  tableView.mp_dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? CXProcuctTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "CXProcuctTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CXProcuctTableViewCell
            cell.backgroundColor = UIColor.smBackgroundColor()
        }
        let produkt = self.products[indexPath.row] as? CX_Products
        self.configureProductCell(cell, product: produkt!)
        return cell;
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {return .delete}
        return .none
    }
    
    /*
     
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CXConstant.PRODUCT_CELL_HEIGHT;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: CX_Products = self.products[indexPath.row] as! CX_Products
        let detailView = SMDetailViewController.init()
        detailView.product = product
        detailView.productCategory = self.productCategory
        
       /* let detailView = ViewPagerCntl.init()
        detailView.product = product
        detailView.itemIndex = indexPath.row
        detailView.productCategory = self.productCategory*/
        self.navigationController?.pushViewController(detailView, animated: true)


    }
    
    func configureProductCell(_ cell: CXProcuctTableViewCell,product:CX_Products) {
        let prodImage :String = self.getInitialAttachmentProduct(product)
        cell.productImageView.sd_setImage(with: URL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.refreshCached)
        cell.productDesc.text =  CXDBSettings.getProductInfo(product)
    }

    
    func getInitialAttachmentProduct(_ product: CX_Products) -> String {
        let attachements : NSArray = CXDBSettings.getProductAttachments(product)
        var prodImgUrl = ""
        if attachements.count > 0 {
            let attachment:NSDictionary = attachements.object(at: 0) as! NSDictionary
            prodImgUrl = attachment.value(forKey: "URL") as! String
        }
        return prodImgUrl
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
