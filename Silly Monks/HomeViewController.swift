//
//  ViewController.swift
//  Silly Monks
//
//  Created by Sarath on 16/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

import GoogleMobileAds
import MagicalRecord
import SDWebImage


class HomeViewController: UIViewController  ,UITableViewDelegate,UITableViewDataSource,CXDBDelegate{
    //MARK: Intialize
    var catTableView = UITableView();
    var bannerView: DFPBannerView!
    var activityIndicatorView: DTIActivityIndicatorView!
    var storedOffsets = [Int: CGFloat]()
    var resultDic : NSDictionary = NSDictionary()
    var categoryList : NSArray = NSArray()
    var imageCache:NSCache = NSCache()
    var refreshControl: UIRefreshControl!
    var singleMalls : NSMutableArray = NSMutableArray()
    var malls : NSMutableArray = NSMutableArray()
    var mallIDs: NSMutableArray = NSMutableArray()
    var splashImageView: UIImageView!
    var sidePanelView:UIView!
    var transparentView:UIView!
    var isPanelOpened:Bool!
    
    var signInBtn:UIButton!
    var aboutUsBtn:UIButton!
    var termsConditionsBtn:UIButton!
    var contactUsBtn:UIButton!
    var advertiseBtn:UIButton!
    var shareAppBtn:UIButton!
    var fbButton:UIButton!
    var twitterButton:UIButton!
    var googlePlusButton:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPanelOpened = false
       //self.setUpSplashAnimation()
        self.homeViewCustomization()
        CXDBSettings.sharedInstance.delegate = self
//        self.stopImageAnimation()
        
        
        //self.performSelector(#selector(HomeViewController.stopImageAnimation), withObject: self, afterDelay: 4)
    }
    
//    func setUpSplashAnimation() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.splashImageView = UIImageView.init(frame: self.view.frame)
//        let url = NSBundle.mainBundle().URLForResource("silly", withExtension: "gif")
//        self.splashImageView.image = UIImage.animatedImageWithAnimatedGIFURL(url!)
//        self.view.addSubview(self.splashImageView)
//        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(HomeViewController.stopImageAnimation), userInfo: nil, repeats: false)
//    }
//    
//    func stopImageAnimation() {
//        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//            self.splashImageView.hidden = true
//            self.homeViewCustomization()
//        }
//    }
    
    func homeViewCustomization() {
        self.customizeHeaderView()
        self.addGoogleBannerView()
        self.imageCache = NSCache.init()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.activityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:150.0, y:200.0, width:60.0, height:60.0))
        if CXDBSettings.sharedInstance.getAllMallsInDB().count == 0 {
            self.view.addSubview(self.activityIndicatorView)
            self.initialSync()
        } else {
            self.getCategoryItems()
        }
        self.designHomeTableView()
         self.customizeSidePanelView()

    }
    func customizeSidePanelView() {
        self.transparentView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.transparentView.backgroundColor = UIColor.blackColor()
        self.transparentView.alpha = 0.4
        self.view.addSubview(self.transparentView)
        self.transparentView.hidden = true
        self.sidePanelView = UIView.init(frame: CGRectMake(-250, 0, 250, self.view.frame.size.height))
        self.sidePanelView.backgroundColor = UIColor.smBackgroundColor()
        self.sidePanelView.alpha = 0.95
        self.designSidePanel()
        self.view.addSubview(self.sidePanelView)
    }
    
    func designSidePanel() {
        self.signInBtn = self.createButton(CGRectMake(10, 5, self.sidePanelView.frame.size.width-20, 50), title: "SIGN IN", tag: 1, bgColor: UIColor.clearColor())
        self.signInBtn.addTarget(self, action: #selector(HomeViewController.signInAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.signInBtn)
        
        
        let profileImage = UIImageView.init(frame: CGRectMake(self.signInBtn.frame.size.width+self.signInBtn.frame.origin.x-80, 0, 70, 70))
        profileImage.image = UIImage(named:"smlogo.png")
        profileImage.layer.cornerRadius = 25
        profileImage.layer.masksToBounds = true
        self.sidePanelView.addSubview(profileImage)
        
        self.aboutUsBtn = self.createButton(CGRectMake(10, self.signInBtn.frame.size.height+self.signInBtn.frame.origin.y+5, self.sidePanelView.frame.size.width-20, 50), title: "About Sillymonks", tag: 1, bgColor: UIColor.clearColor())
        self.aboutUsBtn.addTarget(self, action: #selector(HomeViewController.aboutUsAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.aboutUsBtn)
        
        self.termsConditionsBtn = self.createButton(CGRectMake(10, self.aboutUsBtn.frame.size.height+self.aboutUsBtn.frame.origin.y+5, self.sidePanelView.frame.size.width-20, 50), title: "Terms & Conditions", tag: 1, bgColor: UIColor.clearColor())
        self.termsConditionsBtn.addTarget(self, action: #selector(HomeViewController.termsAndCondAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.termsConditionsBtn)
        
        self.contactUsBtn = self.createButton(CGRectMake(10, self.termsConditionsBtn.frame.size.height+self.termsConditionsBtn.frame.origin.y+5, self.sidePanelView.frame.size.width-20, 50), title: "Contact Us", tag: 1, bgColor: UIColor.clearColor())
        self.contactUsBtn.addTarget(self, action: #selector(HomeViewController.contactUsAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.contactUsBtn)
        
        self.advertiseBtn = self.createButton(CGRectMake(10, self.contactUsBtn.frame.size.height+self.contactUsBtn.frame.origin.y+5, self.sidePanelView.frame.size.width-20, 50), title: "Advertise  With Us", tag: 1, bgColor: UIColor.clearColor())
        self.advertiseBtn.addTarget(self, action: #selector(HomeViewController.advertiseWithUsAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.advertiseBtn)

        
        self.shareAppBtn = self.createButton(CGRectMake(10, self.advertiseBtn.frame.size.height+self.advertiseBtn.frame.origin.y+5, self.sidePanelView.frame.size.width-20, 40), title: "SHARE THE APP", tag: 1, bgColor: UIColor.clearColor())
        self.shareAppBtn.addTarget(self, action: #selector(HomeViewController.shareAppAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.shareAppBtn.backgroundColor = UIColor.navBarColor()
        self.shareAppBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.shareAppBtn.layer.cornerRadius = 6.0
        self.shareAppBtn.layer.masksToBounds = true
        self.shareAppBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.sidePanelView.addSubview(self.shareAppBtn)
        
        let followLbl = UILabel.init(frame: CGRectMake(10, self.shareAppBtn.frame.size.height+self.shareAppBtn.frame.origin.y+10, self.sidePanelView.frame.size.width-20, 30))
        followLbl.font = UIFont(name: "Roboto-Bold", size: 15)
        followLbl.text = "Follow Us"
        self.sidePanelView.addSubview(followLbl)
        
        let dimension = (self.sidePanelView.frame.size.width - 30 - 30)/3
        
        self.fbButton = self.createImageButton(CGRectMake(15, followLbl.frame.size.height+followLbl.frame.origin.y+5, dimension, dimension), tag: 23, bImage: UIImage(named: "Facebook.png")!)
        self.fbButton.addTarget(self, action: #selector(HomeViewController.fbAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.fbButton)
        
        self.twitterButton = self.createImageButton(CGRectMake(self.fbButton.frame.size.width+self.fbButton.frame.origin.x + 15, followLbl.frame.size.height+followLbl.frame.origin.y+10, dimension, dimension), tag: 24, bImage: UIImage(named: "Twitter.png")!)
        self.twitterButton.addTarget(self, action: #selector(HomeViewController.twitterAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.twitterButton)
        
        self.googlePlusButton = self.createImageButton(CGRectMake(self.twitterButton.frame.size.width+self.twitterButton.frame.origin.x + 15, followLbl.frame.size.height+followLbl.frame.origin.y+10, dimension, dimension), tag: 25, bImage: UIImage(named: "Google_Plus.png")!)
        self.googlePlusButton.addTarget(self, action: #selector(HomeViewController.googleAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.sidePanelView.addSubview(self.googlePlusButton)
        
        let powerLbl = UILabel.init(frame: CGRectMake(10, self.googlePlusButton.frame.size.height+self.googlePlusButton.frame.origin.y+20, 100, 35))
        powerLbl.text = "Powered by"
        powerLbl.font = UIFont(name:"Roboto-Regular",size: 14)
        self.sidePanelView.addSubview(powerLbl)
        
        let logoImage = UIImageView.init(frame: CGRectMake(powerLbl.frame.size.width+powerLbl.frame.origin.x+5, powerLbl.frame.origin.y-10, 120, 50))
        logoImage.image = UIImage(named: "logo_store.jpg")
        self.sidePanelView.addSubview(logoImage)
        
    }
    
    func panelBtnAction() {
        if self.isPanelOpened == true {
            self.isPanelOpened = false
            self.moveSideBarToXposition(-250, shouldHideBackView: true)
        } else {
            self.isPanelOpened = true
            self.transparentView.hidden = false
            self.moveSideBarToXposition(0, shouldHideBackView: false)
        }
    }
    
    func signInAction() {
        self.panelBtnAction()
        let signInView = CXSignInSignUpViewController.init()
        self.navigationController?.pushViewController(signInView, animated: true)
    }
    
    func aboutUsAction() {
        self.panelBtnAction()
        let aboutUsView = CXAboutUsViewController.init()
        self.navigationController?.pushViewController(aboutUsView, animated: true)
    }
    
    func termsAndCondAction() {
        self.panelBtnAction()
        let termsView = CXTermsAndConditionsViewController.init()
        self.navigationController?.pushViewController(termsView, animated: true)
    }
    
    func contactUsAction() {
        self.panelBtnAction()
        let contactUsView = CXContactUsViewController.init()
        self.navigationController?.pushViewController(contactUsView, animated: true)
    }
    
    func advertiseWithUsAction() {
        self.panelBtnAction()
        let advertiseView = CXAdvertiseViewController.init()
        self.navigationController?.pushViewController(advertiseView, animated: true)
    }
    
    func shareAppAction() {
        let infoText = "https://www.sillymonks.com/"
        
        let shareItems:Array = [infoText]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
 
    }
    
    func fbAction() {
        let path = "https://www.facebook.com"
        let url = NSURL(string: path)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func twitterAction() {
        let path = "https://www.twitter.com"
        let url = NSURL(string: path)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func googleAction () {
        let path = "https://www.google.com"
        let url = NSURL(string: path)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func moveSideBarToXposition(iXposition: Float,shouldHideBackView:Bool) {
        let convertedXposition = CGFloat(iXposition)
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.sidePanelView.frame = CGRectMake(convertedXposition, 0, self.sidePanelView.frame.size.width, self.sidePanelView.frame.size.height)
            }, completion: { (finished: Bool) -> Void in
                self.transparentView.hidden = shouldHideBackView
        })
    }
    
    func createButton(frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 18)
        button.titleLabel?.textAlignment = NSTextAlignment.Left
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.backgroundColor = bgColor
        return button
    }
    
    func createImageButton(frame:CGRect,tag:Int,bImage:UIImage) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.yellowColor()
        button.setImage(bImage, forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        return button
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sideMenuController()?.sideMenu?.allowRightSwipe = false
        sideMenuController()?.sideMenu?.allowLeftSwipe = false
        sideMenuController()?.sideMenu?.allowPanGesture = false
    }
    
    func getCategoryItems() {
        self.categoryList = CX_AllMalls.MR_findAll()
    }
    
    func moveAction(){
        self.initialSync()
    }
    
    func initialSync() {
        self.activityIndicatorView.startActivity()
        SMSyncService.sharedInstance.startSyncProcessWithUrl(CXConstant.ALL_MALLS_URL) { (responseDict) -> Void in
            CXDBSettings.sharedInstance.saveAllMallsInDB((responseDict.valueForKey("orgs") as? NSArray)!)
        }
    }
    
    func didFinishAllMallsSaving() {
        self.getCategoryItems();
        self.mallIDs = CXDBSettings.getAllMallIDs()
        self.getSingleMalls()
    }
    
    func didFinishSingleMallSaving(mallId:String) {
        self.mallIDs.removeObject(mallId)
        self.getSingleMalls()
    }
    
    func didFinishStoreSaving(mallId:String) {
        self.mallIDs.removeObject(mallId)
        self.getStores()
    }
    
    func didFinishProductCategories() {
        
    }
    
    func didFinishProducts(proName: String) {
        
    }
    
    func getSingleMalls() {
        if self.mallIDs.count > 0 {
            let mallID = self.mallIDs[0] as? String
            self.getSingleMallWithMall(mallID!)
        } else {
            self.mallIDs = CXDBSettings.getAllMallIDs()
            self.getStores()
        }
    }
    
    func getStores () {
        if self.mallIDs.count > 0 {
            let mallId : String = self.mallIDs[0] as! String
            self.getStoreWithMall(mallId)
        } else {
            self.activityIndicatorView.stopActivity()
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.catTableView.reloadData()
                self.updateMenuItems()
            }
        }
    }
    
    func updateMenuItems() {
        let menuView =  self.sideMenuController()?.sideMenu?.menuViewController as? SMMenuViewController
        menuView!.updateItems()
    }
    
    func getStoreWithMall(mallId:String) {
        let storeUrl = CXConstant.STORE_URL+mallId
        SMSyncService.sharedInstance.startSyncProcessWithUrl(storeUrl) { (responseDict) -> Void in
            if let jobsArray = responseDict.valueForKey("jobs") {
                if jobsArray.count > 0 {
                    CXDBSettings.sharedInstance.saveStoreInDB(jobsArray.objectAtIndex(0) as! NSDictionary)
                }
                else {
                    self.mallIDs.removeObject(mallId)
                    self.getStores()
                }
            }
        }
    }
    
    func getSingleMallWithMall(mallId:String)  {
        let singleMallUrl = CXConstant.SINGLE_MALL_URL+mallId
        SMSyncService.sharedInstance.startSyncProcessWithUrl(singleMallUrl) { (responseDict) -> Void in
            let orgsArray: NSArray = responseDict.valueForKey("orgs")! as! NSArray
            let resDict = orgsArray.objectAtIndex(0) as! NSDictionary
            CXDBSettings.sharedInstance.saveSingleMallInDB(resDict)
        }
    }
    
    func addGoogleBannerView() {
        self.bannerView = CXBannerView.init(bFrame: CGRectMake((self.view.frame.size.width - 360)/2, 0, 360, 180), unitID: "/133516651/AppHome", delegate: self)
        self.view.addSubview(self.bannerView)
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "smlogo.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 50, 50)
        button.addTarget(self, action: #selector(HomeViewController.panelBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        button.setImage(lImage, forState: .Normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Silly Monks"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designHomeTableView(){
        let yAxis = self.bannerView.frame.size.height+self.bannerView.frame.origin.y+5
        self.catTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.catTableView.dataSource = self;
        self.catTableView.delegate = self;
        self.catTableView.backgroundColor = UIColor.clearColor()
        self.catTableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "EventCell")
        self.catTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.catTableView.contentInset = UIEdgeInsetsMake(yAxis, 0,60, 0)//-10
        self.catTableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(self.catTableView)        
    }
    
    func customizeRefreshController() {
        let loadView:UIView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.width, 60))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.frame = CGRectMake(0, 0, 100, 50)
        self.refreshControl.backgroundColor = UIColor.yellowColor()
        self.refreshControl.tintColor = UIColor.blueColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refreshAction), forControlEvents: UIControlEvents.ValueChanged)
        self.catTableView.addSubview(refreshControl) // not required when using UITableViewController
        
        ///refreshControl.endRefreshing()
    }
    
    func refreshAction() {
       // print("Screen refreshing")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return CX_AllMalls.MR_findAll().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "EventCell"
        
        var cell: TableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell
            cell.backgroundColor = UIColor.smBackgroundColor()
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        let allMalls:CX_AllMalls = self.categoryList[indexPath.row] as! CX_AllMalls
        cell.cellTitlelbl.text = allMalls.name
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CXConstant.tableViewHeigh;
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return 1;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mall:CX_AllMalls = CX_AllMalls.MR_findAll()[collectionView.tag] as! CX_AllMalls
        let menuView = SMCategoryViewController.init()
        menuView.mall = mall
        
        if collectionView.tag == 0 {
            menuView.bannerString = CXConstant.TOLLYWOOD_BANNAER
        } else if collectionView.tag == 1 {
            menuView.bannerString = CXConstant.BOLLYWOOD_BANNAER
        } else if collectionView.tag == 2 {
            menuView.bannerString = CXConstant.HOLLYWOOD_BANNAER
        } else if collectionView.tag == 3 {
            menuView.bannerString = CXConstant.MOLLYWOOD_BANNAER
        } else if collectionView.tag == 4 {
            menuView.bannerString = CXConstant.KOLLYWOOD_BANNAER
        } else {
            menuView.bannerString = CXConstant.SANDALWOOD_BANNAER
        }
        
        self.navigationController?.pushViewController(menuView, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "CollectionViewCell"
        let cell: CollectionViewItemCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?CollectionViewItemCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CollectionViewItemCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        cell.imageView.image = nil
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.activity.hidden = true
        let allMall:CX_AllMalls = CX_AllMalls.MR_findAll()[collectionView.tag] as! CX_AllMalls
        if allMall.mid != nil {
            self.configureCell(allMall, cell: cell, indexPath: indexPath)
        } else {
            cell.imageView.image = UIImage(named: "smlogo.png")
        }
        return cell
    }
    
    func configureCell(allMall:CX_AllMalls,cell:CollectionViewItemCell,indexPath:NSIndexPath) {
        if CXDBSettings.sharedInstance.getSingleMalls(allMall.mid!).count > 0 {
            let singleMalls = CXDBSettings.sharedInstance.getSingleMalls(allMall.mid!)
            let singleMall:CX_SingleMall = singleMalls[0] as! CX_SingleMall
            cell.imageView.sd_setImageWithURL(NSURL(string:singleMall.coverImage!)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
            cell.textLabel.text = allMall.name
        } else {
            cell.activity.stopActivity()
            cell.activity.hidden = true
            cell.imageView.image = UIImage(named: "smlogo.png")
        }
    }
}

