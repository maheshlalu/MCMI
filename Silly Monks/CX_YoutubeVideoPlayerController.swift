//
//  CX_YoutubeVideoPlayerController.swift
//  Silly Monks
//
//  Created by Sarath on 05/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


class CX_YoutubeVideoPlayerController: UIViewController,UIWebViewDelegate{

    var videoContainerView: UIView!
    
    var videoPlayer: YTPlayerView!
    var titleLabel : UILabel!
    var playURL : String!
    var activity: DTIActivityIndicatorView!
    
    var fWebView:UIWebView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeHeader()
        CXConstant.restrictRotation(false)
        
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:0, y:0, width:60.0, height:60.0))
        self.activity.center = self.view.center
        self.view.addSubview(self.activity)
        self.activity.startActivity()
        
        if self.playURL.lowercaseString.rangeOfString("facebook") != nil {
            self.fWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65))
            self.fWebView.delegate = self
            let wUrl = NSURL(string: self.playURL)
            let request = NSURLRequest(URL: wUrl!)
            self.fWebView.loadRequest(request)
            self.view.addSubview(self.fWebView)
        } else {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            
            let vFrame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)
            self.videoPlayer =  YTPlayerView(frame:vFrame)
            let playerVars: [NSObject : AnyObject] = ["origin": "http://www.youtube.com"]
            let videoID = self.extractYoutubeID(self.playURL)
            self.videoPlayer.loadWithVideoId(videoID, playerVars: playerVars)
            self.view.addSubview(self.videoPlayer)
        }
    }
    
    func extractYoutubeID(youtubeURL: String) -> String {
        let yURL = youtubeURL.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let url = NSURL(string: yURL)
        let videoID = videoIDFromYouTubeURL(url!)
        return videoID!
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

   override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            text="Portrait"
        case .PortraitUpsideDown:
            text="PortraitUpsideDown"
        case .LandscapeLeft:
            text="LandscapeLeft"
        case .LandscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }

    
    func customizeHeader() {
        let leftBtn = UIButton(type: UIButtonType.Custom)
        leftBtn.frame = CGRectMake(0, 0, 40, 40)
        leftBtn.setImage(UIImage(named: "smlogo.png"), forState:.Normal)
        leftBtn.addTarget(self, action:#selector(CXVideoPlayerViewController.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRectMake(0, 0, 120, 40);
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        self.titleLabel.text = "Youtube Video"
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = self.titleLabel
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //print ("webViewDidStartLoad")
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        //print ("webViewDidFinishLoad")
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        //print ("didFailLoadWithError \(error)")
    }
}
