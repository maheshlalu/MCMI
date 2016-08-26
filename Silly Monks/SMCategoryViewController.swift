      //
//  MenuViewController.swift
//  Silly Monks
//
//  Created by Sarath on 19/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage

class SMCategoryViewController: UIViewController,ENSideMenuDelegate,UITableViewDelegate,UITableViewDataSource,CXDBDelegate {
    var mall: CX_AllMalls!
    var spinner: DTIActivityIndicatorView!
    var bannerView:CXBannerView!
    var mallProductCategories: NSMutableArray!
    var products: NSMutableArray!
    
    var categoryTableView: UITableView!
    var storedOffsets = [Int: CGFloat]()
    var productCategories: NSMutableArray!
    var imagesCache: NSCache!
    var bannerString : String!
    var titleLabel : UILabel!
    var storeInfo: NSMutableArray!
    var storeJSON: NSDictionary!
    var isItemSelected : Bool!
    var isMenuOpened: Bool = true
   // var transparentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeJSON = CXDBSettings.getStoreJSON(self.mall.mid!)
        self.storeInfo = CXDBSettings.getStoreInfo(self.storeJSON)
        CXDBSettings.sharedInstance.delegate = self
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.imagesCache = NSCache()
        self.customizeHeader()
        self.initialSyncOperations()
        self.sideMenuController()?.sideMenu?.delegate = self        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isItemSelected = false
    }
    
    // MARK:initialSyncOperations
    func initialSyncOperations() {
        if self.getAllProductCategoriesFromDB(self.mall.mid!).count == 0 {
            /*if self.spinner == nil {
                self.spinner = DTIActivityIndicatorView(frame: CGRect(x:(self.view.frame.size.width-60)/2, y:200.0, width:60.0, height:60.0))
                self.view.addSubview(self.spinner)
            }*/
            self.productCategorySync()
        } else {
            //Check the today date
            if CXDBSettings.sharedInstance.isToday() {
                
            }else{
                self.productCategories = NSMutableArray()
                let getProductCountUrl = "http://sillymonksapp.com:8081/Services/categoryJobsCount?mallId=3&type=productCategories&status=active"//CXConstant.sharedInstance.checkProductCountURL(productName, mallId: mallId)
                SMSyncService.sharedInstance.checkProductCategoryCountSyncProcessWithUrl(getProductCountUrl) { (responseDict) in
                    print(responseDict)
                    for dataDic in responseDict {
                        let countFromServer : NSNumber =  (dataDic.valueForKey("Count") as? NSNumber)!
                        let nameFromServer : NSString =  (dataDic.valueForKey("Name") as? NSString)!
                        if (countFromServer == CXDBSettings.getProductsCount(nameFromServer)){
                            
                        }else{
                            //If count not equel to server count refresh the data and delete the data with name
                            CXDBSettings.deleteTheProducts(nameFromServer)
                            self.productCategories.addObject(nameFromServer)
                        }
                        
                    }
                    if(self.productCategories.count != 0){
                       
                        /*if self.spinner == nil {
                            self.spinner = DTIActivityIndicatorView(frame: CGRect(x:(self.view.frame.size.width-60)/2, y:200.0, width:60.0, height:60.0))
                            self.view.addSubview(self.spinner)
                        }*/
                        self.getProducts()
                    }else{
                        LoadingView.hide()
                       /* if self.spinner != nil {
                            self.spinner.stopActivity()
                        }*/
                        dispatch_async(dispatch_get_main_queue()) {
                            self.mainViewOperations()
                        }
                    }
                }
                return
            }
            LoadingView.hide()
//            if self.spinner != nil {
//                self.spinner.stopActivity()
//            }
            dispatch_async(dispatch_get_main_queue()) {
                self.mainViewOperations()
            }
        }
    }
    
    func productCategorySync () {
        LoadingView.show("Loading", animated: true)
        //self.spinner.startActivity()
        let reqUrl = CXConstant.PRODUCT_CATEGORY_URL + self.mall.mid!
        SMSyncService.sharedInstance.startSyncProcessWithUrl(reqUrl) { (responseDict) -> Void in
            CXDBSettings.sharedInstance.saveProductCategoriesInDB(responseDict.valueForKey("jobs")! as! NSArray, catID: self.mall.mid!)
        }
    }
    
    func didFinishAllMallsSaving(){
        
    }
    func didFinishSingleMallSaving(mallId:String){
        
    }
    func didFinishStoreSaving(mallId:String){
        
    }
    
    
    func didFinishProductCategories() {
        self.productCategories = CXDBSettings.getProductNames()
        self.getProducts()

    }
    
    func didFinishProducts(proName: String) {
        self.productCategories.removeObject(proName)
        self.getProducts()

    }
    
    func getProducts() {
        if self.productCategories.count > 0 {
            let proCat = self.productCategories[0] as! String
            self.getProuctsOfProductCategory(proCat, mallId: self.mall.mid!)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                LoadingView.hide()
               // self.spinner.stopActivity()
                self.mainViewOperations()
            }
        }
    }
    
   
    
 
    
    
    func arrangeTheProductOrder() -> NSArray {
        //category
        let categoryListByorder : NSMutableArray = NSMutableArray()
        let list : NSArray = self.getAllProductCategoriesFromDB(self.mall.mid!)
        if self.mall.name == "Silly Monks Tollywood" {
        let itemOrderList :  NSArray = ["Premium Content","Tollywood News","Teasers and Trailers","Music","Movies","Reviews","Celebrities"]
        for orderItem in itemOrderList {
            for element in list {
                let allMalls : CX_Product_Category = element as! CX_Product_Category
                 //print("all mall Category Name \(allMalls.name)");

                if orderItem as! String == allMalls.name! {
                   // print("all mall Category Name \(allMalls.name)");
                    categoryListByorder.addObject(allMalls)
                    break
                }
            }
        }
        
        return categoryListByorder;
    }
        return list
    }
    
    func mainViewOperations() {
        //Here we chek the count count of the categories
        
        
        let mallProductCats = self.arrangeTheProductOrder()
        
        
        self.mallProductCategories = NSMutableArray()
        for proCat in mallProductCats {
            let produkts = CXDBSettings.getProductsWithCategory(proCat as! CX_Product_Category)
            if produkts.count > 0 {
                self.mallProductCategories.addObject(proCat)
            }
        }
        
        self.bannerView = CXBannerView.init(bFrame: CGRectMake((self.view.frame.size.width - 360)/2, 0, 360, 180), unitID: self.bannerString!, delegate: self)
        self.view.addSubview(self.bannerView)
        self.customizeMainView()
    }
    
    
    func getAllProductCategoriesFromDB(mallID:String) -> NSMutableArray {
        let predicate: NSPredicate = NSPredicate(format: "createdById = %@", mallID)
        
        //let fetchRequest = CX_Product_Category.MR_requestAllSortedBy("pid", ascending: true)
        let fetchRequest = NSFetchRequest(entityName: "CX_Product_Category")
        fetchRequest.predicate = predicate
        //fetchRequest.entity = productEn
       // self.productCategories =   CX_Product_Category.MR_executeFetchRequest(fetchRequest)
        let productCatList :NSArray = CX_Product_Category.MR_executeFetchRequest(fetchRequest)

        let proKatList : NSMutableArray = NSMutableArray(array: productCatList)
        return proKatList
    }
    
    
    
    func getProuctsOfProductCategory(productName: String,mallId:String) {
        
        //http://sillymonksapp.com:8081/Services/categoryJobsCount?mallId=3&type=movies
        
     
        
        let productUrl = CXConstant.sharedInstance.productURL(productName, mallId: mallId)
        SMSyncService.sharedInstance.startSyncProcessWithUrl(productUrl) { (responseDict) -> Void in
            let response = responseDict.valueForKey("jobs")! as! NSArray
            if response.count > 0 {
               CXDBSettings.sharedInstance.saveProductsInDB(response,productCatName: productName)
            } else {
                self.productCategories.removeObject(productName)
                self.getProducts()
            }
        }
    }
    
    func customizeMainView() {
                                                                                                                                                                                                         if self.categoryTableView != nil {
            self.categoryTableView.removeFromSuperview()
        }
        let yAxis = self.bannerView.frame.size.height+self.bannerView.frame.origin.y+5
        self.categoryTableView = self.customizeTableView(CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height))
        self.categoryTableView.contentInset = UIEdgeInsetsMake(yAxis, 0,65, 0)
        self.view.addSubview(self.categoryTableView)
    }
    
    func customizeTableView(tFrame: CGRect) -> UITableView {
        let tabView:UITableView = UITableView.init(frame: tFrame)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.backgroundColor = UIColor.clearColor()
        tabView.registerClass(CXDetailTableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tabView.separatorStyle = UITableViewCellSeparatorStyle.None
        tabView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.showsVerticalScrollIndicator = false
        tabView.scrollEnabled = true
        return tabView;
    }

    func moveAction(){
        let detailView = SMDetailViewController.init()
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    func customizeHeader() {
        let leftBtn = UIButton(type: UIButtonType.Custom)
        leftBtn.frame = CGRectMake(0, 0, 30, 30)
        leftBtn.setImage(UIImage(named: "men_icon.png"), forState:.Normal)
        leftBtn.addTarget(self, action:#selector(SMCategoryViewController.showSideMenuView), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRectMake(0, 0, 210, 40);
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        self.titleLabel.text = self.mall.name
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = self.titleLabel
    }

    
    override func showSideMenuView() {
        
        if isMenuOpened == true{
            NSLog("menu is open")
            self.view.userInteractionEnabled = false
            sideMenuController()?.sideMenu?.showSideMenu()
            isMenuOpened = false
        }else{
            NSLog("menu is close")
            self.view.userInteractionEnabled = true
            sideMenuController()?.sideMenu?.hideSideMenu()
            isMenuOpened = true
        }
        
    }

    func sideMenuWillOpen() {
        //print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
       // print("sideMenuDidClose")
        self.view.userInteractionEnabled = true
        self.isMenuOpened = true
        let selIndex = sideMenuController()?.sideMenu?.selectedIndexOfMenuItem()
        print ("Selected index\(selIndex)")
        self.customizeViewWithIndex(selIndex!)
        
    }
    
    func sideMenuDidOpen() {
        //print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenuHomePressed() {
        sideMenuController()?.sideMenu?.hideSideMenu()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func customizeViewWithIndex(index:Int) {
        self.mall = CXDBSettings.sharedInstance.getAllMallsInDB().objectAtIndex(index) as? CX_AllMalls
        if self.bannerView != nil {
          self.bannerView.removeFromSuperview()
        }
        if self.categoryTableView != nil {
            self.categoryTableView.removeFromSuperview()
        }
        self.titleLabel.text = self.mall.name
        self.bannerString = self.getBannerStringWithIndex(index)
        self.storeJSON = CXDBSettings.getStoreJSON(self.mall.mid!)
        self.storeInfo = CXDBSettings.getStoreInfo(self.storeJSON)
        self.initialSyncOperations()
    }
    
    func getBannerStringWithIndex(index:Int) -> String {
        if index == 0 {
           return CXConstant.TOLLYWOOD_BANNAER
        } else if index == 1 {
            return CXConstant.BOLLYWOOD_BANNAER
        } else if index == 2 {
            return CXConstant.HOLLYWOOD_BANNAER
        } else if index == 3 {
           return CXConstant.MOLLYWOOD_BANNAER
        } else if index == 4 {
            return CXConstant.KOLLYWOOD_BANNAER
        }
        return CXConstant.SANDALWOOD_BANNAER
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.storeInfo.count > 0 {
            return self.mallProductCategories.count + 1
        }
        return self.mallProductCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "DetailCell"
        var cell: CXDetailTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXDetailTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CXDetailTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXDetailTableViewCell
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.detailCollectionView.allowsSelection = true
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        if indexPath.row == self.mallProductCategories.count {
            cell.headerLbl.text = "Gallery"
            cell.productCategories = nil
        } else {
            let proCat : CX_Product_Category = self.mallProductCategories[indexPath.row] as! CX_Product_Category
            cell.headerLbl.text = proCat.name
            cell.productCategories = proCat
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return CXConstant.tableViewHeigh - 25;
    }
}

extension SMCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == self.mallProductCategories.count {
            if (self.storeInfo.count) <= 4{
                return self.storeInfo.count
            }else{
                return 5
            }
        }
        let prodCategory:CX_Product_Category = self.mallProductCategories[collectionView.tag] as! CX_Product_Category
        if (CXDBSettings.getProductsWithCategory(prodCategory).count) <= 4 {
            return CXDBSettings.getProductsWithCategory(prodCategory).count
        }else{
            return 5
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "DetailCollectionViewCell"
        let cell: CXDetailCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?CXDetailCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CXDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        if indexPath.row == 4 {
            let moreCell = self.customizeMoreCell(collectionView, indexPath: indexPath)
            return moreCell
        }
        
        if collectionView.tag == self.mallProductCategories.count {
            let store :NSDictionary = self.storeInfo[indexPath.row] as! NSDictionary
            let gallImage :String = store.valueForKey("URL") as! String
            cell.activity.hidden = true
            cell.detailImageView.sd_setImageWithURL(NSURL(string:gallImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
            cell.infoLabel.text =  store.valueForKey("albumName") as? String
        } else {
            let prodCategory:CX_Product_Category = self.mallProductCategories[collectionView.tag] as! CX_Product_Category
            let product: CX_Products = CXDBSettings.getProductsWithCategory(prodCategory)[indexPath.row] as! CX_Products
            cell.activity.hidden = true
            let prodImage :String = CXDBSettings.getProductImage(product)
            
            cell.detailImageView.sd_setImageWithURL(NSURL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
            cell.infoLabel.text = CXDBSettings.getProductInfo(product)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%
        
        if indexPath.row == 4 {
            return CGSize(width: CXConstant.DetailCollectionCellSize.width-70, height: CXConstant.DetailCollectionCellSize.height)
        }
        return CXConstant.DetailCollectionCellSize
        
    }
    
    func customizeMoreCell(collectionView:UICollectionView,indexPath:NSIndexPath) -> UICollectionViewCell{
        let collID = "CollectionCellID"
        let cell: UICollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(collID, forIndexPath: indexPath)
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "UICollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collID)
        }
        cell.backgroundColor = UIColor.whiteColor()
        let moreLabel = self.createLable(CGRectMake(0, (cell.frame.size.height - 35)/2, cell.frame.size.width, 35), text: "More")
        cell.addSubview(moreLabel)
        return cell
    }
    
    
    func createLable(lFrame:CGRect, text: String) -> UILabel{
        let cLabel = UILabel.init()
        cLabel.frame = lFrame
        cLabel.backgroundColor = UIColor.whiteColor()
        cLabel.textColor = UIColor.navBarColor()
        cLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        cLabel.text = text
        cLabel.textAlignment = NSTextAlignment.Center
        cLabel.numberOfLines = 0
        return cLabel
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       // print("did select item clicked")
        if (isItemSelected == true) {
            
            return
        }
        isItemSelected = true
        if collectionView.tag == self.mallProductCategories.count {
            if indexPath.row == 4 {
                let galleryDetails = CXGalleryMoreViewController.init()
                galleryDetails.stores = self.storeInfo
                galleryDetails.galleryStoreJSON = self.storeJSON
                self.navigationController?.pushViewController(galleryDetails, animated: true)
            }else{
            let store :NSDictionary = self.storeInfo[indexPath.row] as! NSDictionary
            let galleryView =  CXGalleryViewController.init()
            let albumName = store.valueForKey("albumName") as? String
                galleryView.headerStr = albumName
            galleryView.stores = CXDBSettings.getGalleryItems(self.storeJSON, albumName: albumName!)
            self.navigationController?.pushViewController(galleryView, animated: true)
            }
        } else {
            let prodCategory:CX_Product_Category = self.mallProductCategories[collectionView.tag] as! CX_Product_Category
            if indexPath.row == 4 {
                let productsView = CXProductsViewController.init()
                productsView.productCategory = prodCategory
                self.navigationController?.pushViewController(productsView, animated: true)
            } else {
                let product: CX_Products = CXDBSettings.getProductsWithCategory(prodCategory) [indexPath.row] as! CX_Products
               // let detailView = SMDetailViewController.init()
               // detailView.product = product
                //detailView.productCategory = prodCategory
                
                 let detailView = ViewPagerCntl.init()
                detailView.product = product
                detailView.itemIndex = indexPath.row
                detailView.productCategory = prodCategory
                self.navigationController?.pushViewController(detailView, animated: true)
                
            }
        }
        
    }
    
}

/* http://stackoverflow.com/questions/24176362/nsurlconnection-using-ios-swift */

