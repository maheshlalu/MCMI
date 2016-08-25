//
//  CXGalleryMoreViewController.swift
//  Silly Monks
//
//  Created by CX_One on 8/11/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage
import mopub_ios_sdk
import CoreLocation
import LocationManager

class CXGalleryMoreViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var galleryCollectionView: UICollectionView!
    var spinner:DTIActivityIndicatorView!// = DTIActivityIndicatorView()
    var activityIndicatorView: DTIActivityIndicatorView!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    var stores : NSMutableArray!
    var galleryStoreJSON: NSDictionary!
    
    var imageItemsDict:NSMutableDictionary = NSMutableDictionary()
    
    var galleryImages: [UIImage] = []
    var imagesCache: NSCache = NSCache()
    var placer: MPCollectionViewAdPlacer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.stores.removeObjectAtIndex(0)
       // print("Gallery Stores \(self.stores)")
        
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
        tLabel.text = "Gallery"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func customizeMainView() {
        //let layout = CHTCollectionViewWaterfallLayout()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 50, right: 10)
        
                let cWidth = self.view.frame.size.width
                let reqImgWidth = (cWidth-30)/2
                let ratioValue = 480/reqImgWidth
                let reqImgHeight = 800/ratioValue
        layout.itemSize = CGSize(width: reqImgWidth,height: reqImgHeight)

        //CGSize(width: 135,height: tableViewHeigh-80)
       // layout.minimumColumnSpacing = 10.0
        //layout.minimumInteritemSpacing = 10.0
        
        self.galleryCollectionView = UICollectionView.init(frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: layout)
        self.galleryCollectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        
        self.galleryCollectionView.alwaysBounceVertical = true
        
        self.galleryCollectionView.backgroundColor = UIColor.clearColor()
        self.galleryCollectionView.registerClass(CXGalleryMoreCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCellIdentifier")
        self.view.addSubview(self.galleryCollectionView)
        
        self.activityIndicatorView.stopActivity()
        
        self.setUpNativeAds()
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
        let cell: CXGalleryMoreCollectionViewCell! = collectionView.mp_dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? CXGalleryMoreCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CXGalleryMoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        cell.picView.image = nil
        cell.activity.hidden = true
        let store :NSMutableDictionary = self.stores[indexPath.row] as! NSMutableDictionary
        let gallImage :String = store.valueForKey("URL") as! String
        
        
        cell.picView.sd_setImageWithURL(NSURL(string: gallImage)!,
                                        placeholderImage: UIImage(named: "smlogo.png"),
                                        options: SDWebImageOptions.RefreshCached,
                                        completed: { (image, error, cacheType, imageURL) -> () in
                                            //print("Downloaded and set! and Image size \(image?.size)")
                                            self.imageItemsDict.setValue(image, forKey: String(indexPath.row))
                                            //collectionView.reloadItemsAtIndexPaths([indexPath])
            }
        )
        let albumName = store.valueForKey("albumName") as? String
        cell.infoLabel.text = albumName
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let galleryView =  CXGalleryViewController.init()
        let albumName = store.valueForKey("albumName") as? String
        galleryView.headerStr = albumName
        galleryView.stores = CXDBSettings.getGalleryItems(self.galleryStoreJSON, albumName: albumName!)
        self.navigationController?.pushViewController(galleryView, animated: true)
    }
    
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let cWidth = collectionView.frame.size.width;
//        let reqImgWidth = (cWidth-30)/2
//        let ratioValue = 480/reqImgWidth
//        let reqImgHeight = 800/ratioValue
//        
//        return CGSizeMake(reqImgWidth, reqImgHeight)
//    }
    
    //MARK: Native adds
    
    func setUpNativeAds(){
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
            
            //let reqImgWidth = (maxWidth-30)/2
           // let ratioValue = 480/reqImgWidth
           // let reqImgHeight = 800/ratioValue
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 250);

            //return CGSizeMake(reqImgWidth, reqImgHeight)
            //return CGSizeMake(maxWidth, 250);
        };
        
        let config = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(settings)
        
        // TODO: Create your own UITableViewCell subclass that implements MPNativeAdRendering
        //  self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, rendererConfigurations: [config])
        
        let addPostion : MPClientAdPositioning = MPClientAdPositioning()
        addPostion.addFixedIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        addPostion.enableRepeatingPositionsWithInterval(9)
        
        self.placer = MPCollectionViewAdPlacer(collectionView: self.galleryCollectionView, viewController: self, adPositioning: addPostion, rendererConfigurations: [config])
        
        // We have configured the test ad unit ID to place ads at fixed
        // cell positions 2 and 10 and show an ad every 10 cells after
        // that.
        //
        // TODO: Replace this test id with your personal ad unit id
        self.placer.loadAdsForAdUnitID(CXConstant.NATIVEADD_UNITI_ID, targeting: targeting)
    }
    
   
    
}

