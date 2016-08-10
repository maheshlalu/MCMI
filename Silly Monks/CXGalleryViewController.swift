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
import LocationManager

class CXGalleryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,MPTableViewAdPlacerDelegate, MPInterstitialAdControllerDelegate {
    
    var galleryCollectionView: UICollectionView!
    var spinner:DTIActivityIndicatorView!
    var activityIndicatorView: DTIActivityIndicatorView!
    let reuseIdentifier = "cell"
    var stores : NSMutableArray!
    var galleryImages: [UIImage] = []
    var imagesCache: NSCache = NSCache()
    var imagesDict:NSMutableDictionary = NSMutableDictionary()
    
    var placer: MPCollectionViewAdPlacer!
    var objects = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.activityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:(self.view.frame.size.width-60)/2, y:200.0, width:60.0, height:60.0))
            self.activityIndicatorView.hidden = false
            self.view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startActivity()
        }
        self.customizeHeaderView()
        self.performSelector(#selector(CXGalleryViewController.threadAction), withObject: self, afterDelay: 1.0, inModes: [NSDefaultRunLoopMode])
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
        
        let lImage = UIImage(named: "smlogo.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 50, 50)
        button.setImage(lImage, forState: .Normal)
        button.addTarget(self, action: #selector(CXGalleryViewController.backAction), forControlEvents: .TouchUpInside)
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
    
    func customizeMainView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        self.galleryCollectionView = UICollectionView.init(frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: layout)
        self.galleryCollectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
    
        self.galleryCollectionView.alwaysBounceVertical = true
        
        self.galleryCollectionView.backgroundColor = UIColor.clearColor()
        self.galleryCollectionView.registerClass(CXGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCellIdentifier")
        
        self.view.addSubview(self.galleryCollectionView)
        
         self.activityIndicatorView.stopActivity()
       // self.setUpmopubs()

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
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "GalleryCellIdentifier"
        let cell: CXGalleryCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?CXGalleryCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CXGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        cell.picView.image = nil
        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let gallImage :String = store.valueForKey("URL") as! String
        cell.activity.hidden = true
        
        cell.picView.sd_setImageWithURL(NSURL(string:gallImage)!, placeholderImage: UIImage(named: "smlogo.png"), options: SDWebImageOptions.RefreshCached) { (image, error, cacheType, url) in
            //print ("Success")
            self.imagesDict.setValue(image, forKey: String(indexPath.row))
            //self.galleryCollectionView.collectionViewLayout.invalidateLayout()
            self.galleryCollectionView.reloadItemsAtIndexPaths([indexPath])
        }
        
        
        
//        if self.imagesCache.objectForKey(gallImage) != nil {
//            cell.picView.image = self.imagesCache.objectForKey(gallImage) as? UIImage
//            cell.activity.stopActivity()
//            cell.activity.hidden = true
//        } else {
//            if !gallImage.isEmpty {
//                cell.activity.hidden = false
//                cell.activity.startActivity()
//                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                    if let imgUrl = NSURL(string: gallImage) {
//                        if let cImageData = NSData(contentsOfURL: imgUrl) {
//                            let cImage = UIImage(data: cImageData)
//                            self.imagesCache.setObject(cImage!, forKey: gallImage)
//                            dispatch_async(dispatch_get_main_queue(), {
//                                let updateCell : CXGalleryCollectionViewCell?
//                                do {
//                                    updateCell  = try collectionView.cellForItemAtIndexPath(indexPath) as? CXGalleryCollectionViewCell
//                                } catch let error as NSError {
//                                    print("\(error)")
//                                }
//                                if updateCell != nil {
//                                    updateCell!.picView.image = cImage
//                                    updateCell!.activity.stopActivity()
//                                }
//                                cell.activity.stopActivity()
//                            })
//                        }
//                    }
//                })
//            } else {
//                cell.activity.stopActivity()
//                cell.activity.hidden = true
//                cell.picView.image = UIImage(named: "smlogo.png")//smnocover//smlogo
//            }
//        }
//        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let gallImage :String = store.valueForKey("URL") as! String

        let imageControl = CXImageViewController.init()
        imageControl.imagePath = gallImage
        self.navigationController?.pushViewController(imageControl, animated: false)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
//        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
//        let gallImage :String = store.valueForKey("URL") as! String
//        
//        if self.imagesCache.objectForKey(gallImage) != nil {
//            gImage = self.imagesCache.objectForKey(gallImage) as! UIImage
//        } else {
//            if !gallImage.isEmpty {
//                //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                if let imgUrl = NSURL(string: gallImage) {
//                    if let cImageData = NSData(contentsOfURL: imgUrl) {
//                        gImage = UIImage(data: cImageData)!
//                        self.imagesCache.setObject(gImage, forKey: gallImage)
//                    }
//                }
//                // })
//            }
//        }
        
        if let image = self.imagesDict.valueForKey(String(indexPath.row)) {
            return image.size
        }
        let gImage: UIImage = UIImage(named: "smlogo.png")!
        let imgSize = gImage.size
        return imgSize
    }
    
    
    //MARK: Setup the Mopubs
    
    func setUpmopubs(){
        
        self.setupAdPlacer()
        
        // Data must be pre-populated into table for ads to appear
        for _ in 1...10 {
            self.insertNewObject(self)
        }
        
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
       // let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let indexPath  = NSIndexPath(forRow: 1, inSection: 0)
//        self.productsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.galleryCollectionView.insertItemsAtIndexPaths([indexPath])
        // TODO: Depending on your use of UITableView, you will need to
        // add "mp_" to other method calls in addition to this one.
        // See http://t.co/mopub-ios-native-category for a list of
        // required replacements.
        self.galleryCollectionView.mp_insertItemsAtIndexPaths([indexPath])
       // self.galleryCollectionView.mp_insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
            return CGSizeMake(maxWidth, 300);
        };
        
        let config = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(settings)
        
        // TODO: Create your own UITableViewCell subclass that implements MPNativeAdRendering
        
       self.placer = MPCollectionViewAdPlacer(collectionView: self.galleryCollectionView, viewController: self, rendererConfigurations: [config])
        //self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, rendererConfigurations: [config])
        
        
        // We have configured the test ad unit ID to place ads at fixed
        // cell positions 2 and 10 and show an ad every 10 cells after
        // that.
        //
        // TODO: Replace this test id with your personal ad unit id
        self.placer.loadAdsForAdUnitID(CXConstant.NATIVEADD_UNITI_ID, targeting: targeting)
    }
    

    
}



//http://stackoverflow.com/questions/25305945/use-of-undeclared-type-viewcontroller-when-unit-testing-my-own-viewcontroller
