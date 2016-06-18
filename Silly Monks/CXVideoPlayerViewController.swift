//
//  CXVideoPlayerViewController.swift
//  Silly Monks
//
//  Created by Sarath on 23/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXVideoPlayerViewController: UIViewController, BCOVPlaybackControllerDelegate {
    var playerID : String!
    let playbackService = BCOVPlaybackService(accountId: CXConstant.kViewControllerAccountID, policyKey: CXConstant.kViewControllerPlaybackServicePolicyKey)!
    let playbackController :BCOVPlaybackController!
    var videoContainerView: UIView!
    var titleLabel : UILabel!
    var isBarHidden: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        let manager = BCOVPlayerSDKManager.sharedManager();
        playbackController = manager.createPlaybackControllerWithViewStrategy(manager.defaultControlsViewStrategy())
        super.init(coder: aDecoder)
        playbackController.analytics.account = CXConstant.kViewControllerAccountID
        playbackController.delegate = self
        playbackController.autoAdvance = true
        playbackController.autoPlay = true
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.playerID, forKey: "playerID")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeHeader()
        CXConstant.restrictRotation(false)
         UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        
        self.videoContainerView = self.view
        
        playbackController.view.frame = videoContainerView.bounds
        playbackController.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        videoContainerView.addSubview(playbackController.view)
        requestContentFromPlaybackService()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(CXVideoPlayerViewController.tapAction))
        tapGesture.numberOfTapsRequired = 1
        videoContainerView.addGestureRecognizer(tapGesture)
        
        self.isBarHidden = false
    }
    
    func tapAction() {
        if self.isBarHidden == true {
            self.isBarHidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.isBarHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        switch UIDevice.currentDevice().orientation {
        case .Portrait, .PortraitUpsideDown, .Unknown:
            return true
        default:
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
        return UIInterfaceOrientationMask.All
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft;
    }
    
    func customizeHeader() {
        let leftBtn = UIButton(type: UIButtonType.Custom)
        leftBtn.frame = CGRectMake(0, 0, 35, 35)
        leftBtn.setImage(UIImage(named: "smlogo.png"), forState:.Normal)
        leftBtn.addTarget(self, action:#selector(CXVideoPlayerViewController.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRectMake(0, 0, 120, 40);
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        self.titleLabel.text = "Video"
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = self.titleLabel
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func requestContentFromPlaybackService() {
        playbackService.findVideoWithVideoID(self.playerID, parameters: nil) { (video:BCOVVideo!, jsonResponse: [NSObject : AnyObject]!, error:NSError!) -> Void in
            if let v = video {
                self.playbackController.setVideos([v])
            } else {
                NSLog("ViewController Debug - Error retrieving video: %@", error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
