//
//  CXImageViewController.swift
//  Silly Monks
//
//  Created by Sarath on 15/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
//import mopub_ios_sdk

import CoreLocation
class CXImageViewController: UIViewController {
    
    var imagePath: String!
    var picView: UIImageView!
    var interstitialAdController:MPInterstitialAdController!

    var picture: UIImage!
    var pageIndex : NSInteger = 0
    var swipeCount : NSInteger = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        //print("swipe count \(swipeCount)")
        if swipeCount == 0{
           // self.addTheInterstitialCustomAds()
        }else if swipeCount % 10 == 0 {
            //self.addTheInterstitialCustomAds()
        }
        
        self.picView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.picView.isUserInteractionEnabled = true
        self.picView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(self.picView)
        
        DispatchQueue.main.async(execute: {
            /*self.activity = DTIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            self.activity.center = self.picView.center                                                                               
            self.picView.addSubview(self.activity)*/
           // self.activity.startActivity()
        })
        
        self.loadImage()
        

        // Do any additional setup after loading the view.
    }
    
    func loadImage() {
        if !self.imagePath.isEmpty {
            DispatchQueue.global( priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                if let imgUrl = URL(string: self.imagePath) {
                    if let cImageData = try? Data(contentsOf: imgUrl) {
                        let cImage = UIImage(data: cImageData)
                        DispatchQueue.main.async(execute: {
                           // self.activity.stopActivity()
                            self.picView.image = cImage
                            self.picture = cImage
                            self.shareAndDownloadBtnChages()
                        })
                    }
                }
            })
        } else {
            self.picView.image = UIImage(named: "smlogo.png")
            self.picView.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
    func shareAndDownloadBtnChages() {
//        let shareBtn = UIButton.init(frame: CGRectMake(self.view.frame.size.width-120, 10, 45, 45))
//        shareBtn.setImage(UIImage(named:"share_108.png"), forState: UIControlState.Normal)
//        shareBtn.addTarget(self, action:#selector(CXImageViewController.shareBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
//        //shareBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
//        self.picView.addSubview(shareBtn)
        
        let downlodBtn = UIButton.init(frame: CGRect(x: self.view.frame.size.width-40,y: 25, width: 30, height: 30))
        downlodBtn.setImage(UIImage(named: "downloadImg"), for: UIControlState())
        downlodBtn.addTarget(self, action: #selector(CXImageViewController.downloadAction), for: UIControlEvents.touchUpInside)
        //downlodBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picView.addSubview(downlodBtn)
        
        let backBtn = UIButton.init(frame:CGRect(x: 10, y: 25, width: 30, height: 30))
        backBtn.setImage(UIImage(named: "left_aarow.png"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(CXImageViewController.backAction), for: UIControlEvents.touchUpInside)
        self.picView.addSubview(backBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        self.dismiss(animated: true) { 
            
        }
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func shareBtnAction() {
        let webUrl = URL(string:self.imagePath)
        let img: UIImage = self.picture
        
        guard let url = webUrl else {
            //print("nothing found")
            return
        }
        
        let shareItems:Array = [img, url] as [Any]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func downloadAction() {
        DispatchQueue.global( priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
             UIImageWriteToSavedPhotosAlbum(self.picture, self, nil, nil)
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Smart Movie Ticket", message: "Image saved successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        })
    }

    
    func completeSelector() {
       // print("Saved success")
        let alert = UIAlertController(title: "Smart Movie Ticket", message: "Image saved successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func addTheInterstitialCustomAds(){
        self.interstitialAdController = SampleAppInstanceProvider.sharedInstance.buildMPInterstitialAdControllerWithAdUnitID(CXConstant.mopub_interstitial_ad_id)
        self.interstitialAdController.delegate = self
        self.interstitialAdController.loadAd()
        self.interstitialAdController.show(from: self)
    }
    
    
    
}

extension CXImageViewController: MPInterstitialAdControllerDelegate {
 
    
    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
       self.interstitialAdController.show(from: self)
    }
    
    
}
