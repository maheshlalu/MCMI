//
//  CXGalleryViewController.swift
//  Silly Monks
//
//  Created by Sarath on 10/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage
import mopub_ios_sdk

import CoreLocation
class CXGalleryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout {
    
    var galleryCollectionView: UICollectionView!
    var spinner:DTIActivityIndicatorView!// = DTIActivityIndicatorView()
   var imageViewCntl: CXImageViewController!
    var activityIndicatorView: DTIActivityIndicatorView!
      var bottomAd: MPAdView!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    var stores : NSMutableArray!
    var headerStr : String!
    var viewControllers : NSMutableArray!
    var imageItemsDict:NSMutableDictionary = NSMutableDictionary()
    
    var galleryImages: [UIImage] = []
    var imagesCache: NSCache = NSCache()
    var leftAndRightCount : NSInteger = 0
    var interstitialAdController:MPInterstitialAdController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.stores.removeObjectAtIndex(0)
        print("Gallery Stores \(self.stores)")
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.activityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:(self.view.frame.size.width-60)/2, y:200.0, width:60.0, height:60.0))
            self.activityIndicatorView.hidden = false
            self.view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startActivity()
        }
        
        self.customizeHeaderView()
       
        self.performSelector(#selector(CXGalleryViewController.threadAction), withObject: self, afterDelay: 1.0, inModes: [NSDefaultRunLoopMode])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func threadAction() {
       
        self.customizeMainView()
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.addTarget(self, action: #selector(CXGalleryViewController.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Gallery - \(headerStr)"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func customizeMainView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        self.galleryCollectionView = UICollectionView.init(frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50), collectionViewLayout: layout)
        self.galleryCollectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
    
        self.galleryCollectionView.alwaysBounceVertical = true
        
        self.galleryCollectionView.backgroundColor = UIColor.clearColor()
        self.galleryCollectionView.registerClass(CXGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCellIdentifier")
        self.view.addSubview(self.galleryCollectionView)
        
         self.activityIndicatorView.stopActivity()
         self.addTheBottomAdd()
    }
    //MARK:Add The bottom add
    func addTheBottomAdd(){
        let bottomAddView : UIView = UIView(frame:CGRectMake(0, self.galleryCollectionView.frame.size.height+5, self.galleryCollectionView.frame.size.width, 49))
        //bottomAddView.backgroundColor = UIColor.greenColor()
        self.bottomAd = SampleAppInstanceProvider.sharedInstance.buildMPAdViewWithAdUnitID(CXConstant.mopub_banner_ad_id, size: CGSizeMake(self.view.frame.size.width, 49))
        self.bottomAd.frame =  CGRectMake(50, 0, self.view.frame.size.width, 50)
        if CXConstant.currentDeviceScreen() == IPHONE_5S{
            self.bottomAd = SampleAppInstanceProvider.sharedInstance.buildMPAdViewWithAdUnitID(CXConstant.mopub_banner_ad_id, size: CGSizeMake(self.view.frame.size.width, 40))
            self.bottomAd.frame =  CGRectMake(0, 0, self.view.frame.size.width, 39)
        }
        //self.bottomAd.backgroundColor = UIColor.redColor()
        self.bottomAd.autoresizingMask =  [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
        bottomAddView.addSubview(self.bottomAd)
        self.bottomAd.loadAd()
       self.view.addSubview(bottomAddView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBtnAction() {
        
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.stores.count;
       // return galleryImages.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "GalleryCellIdentifier"
        let cell: CXGalleryCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?CXGalleryCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CXGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        cell.picView.image = nil
        cell.activity.hidden = true
        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let gallImage :String = store.valueForKey("URL") as! String
        
        
        cell.picView.sd_setImageWithURL(NSURL(string: gallImage)!,
                                                 placeholderImage: UIImage(named: "smlogo.png"),
                                                 options: SDWebImageOptions.RefreshCached,
                                                 completed: { (image, error, cacheType, imageURL) -> () in
                                                   // print("Downloaded and set! and Image size \(image?.size)")
                                                    self.imageItemsDict.setValue(image, forKey: String(indexPath.row))
                                                    //collectionView.reloadItemsAtIndexPaths([indexPath])
            }
        )
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath) indexPath Row\(indexPath.row)")

      //  NSNumber(int: UIPageViewControllerSpineLocation.Mid)
        
        let o = UIPageViewControllerSpineLocation.Mid.rawValue //toRaw makes it conform to AnyObject
        let k = UIPageViewControllerOptionSpineLocationKey
        let options = NSDictionary(object: o, forKey: k)
        
        let pageCntl : CXPageViewController = CXPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: options as! [String : AnyObject])
        self.viewControllers = NSMutableArray()
        for var i = 0; i <= self.stores.count-1; i++ {
            let store :NSDictionary = self.stores[i] as! NSDictionary
            let gallImage :String = store.valueForKey("URL") as! String
            let imageControl = CXImageViewController.init()
            imageControl.imagePath = gallImage
            imageControl.pageIndex = i
            self.viewControllers.addObject(imageControl)
        }
        pageCntl.setViewControllers([viewControllers[indexPath.item] as! UIViewController], direction: .Forward, animated: true) { (animated) in
            
        }
        pageCntl.doubleSided = false
        pageCntl.dataSource = self
        
        self.presentViewController(pageCntl, animated: true) { 
            
        }
       /*self.navigationController?.setNavigationBarHidden(true, animated: true)
        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let gallImage :String = store.valueForKey("URL") as! String

        let imageControl = CXImageViewController.init()
        imageControl.imagePath = gallImage
        self.navigationController?.pushViewController(imageControl, animated: false)*/
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cWidth = collectionView.frame.size.width;
        let reqImgWidth = (cWidth-30)/2
        let ratioValue = 480/reqImgWidth
        let reqImgHeight = 800/ratioValue
        
        return CGSizeMake(reqImgWidth, reqImgHeight)
    }
}

extension CXGalleryViewController : UIPageViewControllerDataSource {
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        self.leftAndRightCount += 1
        if self.leftAndRightCount  == 10 {
            self.leftAndRightCount = 0
            self.addTheInterstitialCustomAds()
        }
        let imageControl : CXImageViewController = (viewController as? CXImageViewController)!
          self.imageViewCntl =  imageControl
        //imageControl.swipeCount = self.leftAndRightCount
        if(imageControl.pageIndex == 0){
        return nil
        }
        return self.viewControllers![imageControl.pageIndex - 1] as! UIViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
     
        self.leftAndRightCount += 1
        if self.leftAndRightCount  == 10 {
            self.leftAndRightCount = 0
            self.addTheInterstitialCustomAds()
        }
        
        let imageControl : CXImageViewController = (viewController as? CXImageViewController)!
        self.imageViewCntl =  imageControl
        //imageControl.swipeCount = self.leftAndRightCount
        if(imageControl.pageIndex < (self.viewControllers?.count)!-1){
            return self.viewControllers![imageControl.pageIndex + 1] as! UIViewController
        }
        return nil
        
    }
    
    func addTheInterstitialCustomAds(){
        self.interstitialAdController = SampleAppInstanceProvider.sharedInstance.buildMPInterstitialAdControllerWithAdUnitID(CXConstant.mopub_interstitial_ad_id)
        self.interstitialAdController.delegate = self
        self.interstitialAdController.loadAd()
        self.interstitialAdController.showFromViewController(self.imageViewCntl)
        
       // if let dataaDelegate = UIApplication.sharedApplication().delegate
        
       //delegate.window!!.rootViewController
        
    }
}



extension CXGalleryViewController: MPInterstitialAdControllerDelegate {
    
    
    func interstitialDidAppear(interstitial: MPInterstitialAdController!) {
        self.interstitialAdController.showFromViewController(self.imageViewCntl)
    }
    
    //[[[[UIApplication sharedApplication] delegate] window] rootViewController]
    
}




//http://stackoverflow.com/questions/25305945/use-of-undeclared-type-viewcontroller-when-unit-testing-my-own-viewcontroller
