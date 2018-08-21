//
//  CXGalleryMoreViewController.swift
//  Silly Monks
//
//  Created by CX_One on 8/11/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import SDWebImage
//import mopub_ios_sdk
import CoreLocation

class CXGalleryMoreViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var galleryCollectionView: UICollectionView!
    //var spinner:DTIActivityIndicatorView!// = DTIActivityIndicatorView()
   // var activityIndicatorView: DTIActivityIndicatorView!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    var stores : NSMutableArray!
    var galleryStoreJSON: NSDictionary!
    
    var imageItemsDict:NSMutableDictionary = NSMutableDictionary()
    
    var galleryImages: [UIImage] = []
    var placer: MPCollectionViewAdPlacer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.stores.removeObject(at: 0)
       // print("Gallery Stores \(self.stores)")
        //TODO:MAHESH
        DispatchQueue.main.async { [unowned self] in
          /*  self.activityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:(self.view.frame.size.width-60)/2, y:200.0, width:60.0, height:60.0))
            self.activityIndicatorView.isHidden = false
            self.view.addSubview(self.activityIndicatorView)*/
           // self.activityIndicatorView.startActivity()
        }
        
        self.customizeHeaderView()
        self.perform(#selector(CXGalleryViewController.threadAction), with: self, afterDelay: 1.0, inModes: [RunLoopMode.defaultRunLoopMode])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func threadAction() {
        
        self.customizeMainView()
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(lImage, for: UIControlState())
        button.addTarget(self, action: #selector(CXGalleryViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 40);
        tLabel.backgroundColor = UIColor.clear
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Gallery"
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.textColor = UIColor.white
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
        
        self.galleryCollectionView = UICollectionView.init(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: layout)
        self.galleryCollectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        
        self.galleryCollectionView.alwaysBounceVertical = true
        
        self.galleryCollectionView.backgroundColor = UIColor.clear
        self.galleryCollectionView.register(CXGalleryMoreCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCellIdentifier")
        self.view.addSubview(self.galleryCollectionView)
        
       // self.activityIndicatorView.stopActivity()
        
        //self.setUpNativeAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBtnAction() {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.stores.count;
        // return galleryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "GalleryCellIdentifier"
        let cell: CXGalleryMoreCollectionViewCell! = collectionView.mp_dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CXGalleryMoreCollectionViewCell
        if cell == nil {
            collectionView.register(UINib(nibName: "CXGalleryMoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        cell.picView.image = nil
       // cell.activity.isHidden = true
        let store :NSMutableDictionary = self.stores[indexPath.row] as! NSMutableDictionary
        let gallImage :String = store.value(forKey: "URL") as! String
        
        
        cell.picView.sd_setImage(with: URL(string: gallImage)!,
                                        placeholderImage: UIImage(named: "smlogo.png"),
                                        options: SDWebImageOptions.refreshCached,
                                        completed: { (image, error, cacheType, imageURL) -> () in
                                            //print("Downloaded and set! and Image size \(image?.size)")
                                            self.imageItemsDict.setValue(image, forKey: String(indexPath.row))
                                            //collectionView.reloadItemsAtIndexPaths([indexPath])
            }
        )
        let albumName = store.value(forKey: "albumName") as? String
        cell.infoLabel.text = albumName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let store :NSDictionary = self.stores[indexPath.row] as! NSDictionary
        let galleryView =  CXGalleryViewController.init()
        let albumName = store.value(forKey: "albumName") as? String
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
            return CGSize(width: UIScreen.main.bounds.width, height: 250);

            //return CGSizeMake(reqImgWidth, reqImgHeight)
            //return CGSizeMake(maxWidth, 250);
        };
        
        let config = MPStaticNativeAdRenderer.rendererConfiguration(with: settings)
        
        // TODO: Create your own UITableViewCell subclass that implements MPNativeAdRendering
        //  self.placer = MPTableViewAdPlacer(tableView: self.productsTableView, viewController: self, rendererConfigurations: [config])
        
        let addPostion : MPClientAdPositioning = MPClientAdPositioning()
        addPostion.addFixedIndexPath(IndexPath(row: 0, section: 0))
        addPostion.enableRepeatingPositions(withInterval: 9)
        
        self.placer = MPCollectionViewAdPlacer(collectionView: self.galleryCollectionView, viewController: self, adPositioning: addPostion, rendererConfigurations: [config])
        
        // We have configured the test ad unit ID to place ads at fixed
        // cell positions 2 and 10 and show an ad every 10 cells after
        // that.
        //
        // TODO: Replace this test id with your personal ad unit id
        self.placer.loadAds(forAdUnitID: CXConstant.NATIVEADD_UNITI_ID, targeting: targeting)
    }
    
   
    
}

