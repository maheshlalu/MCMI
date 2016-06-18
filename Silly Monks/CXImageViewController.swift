//
//  CXImageViewController.swift
//  Silly Monks
//
//  Created by Sarath on 15/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXImageViewController: UIViewController {
    
    var imagePath: String!
    var picView: UIImageView!
    var activity:DTIActivityIndicatorView!
    var picture: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        
        self.picView = UIImageView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.picView.userInteractionEnabled = true
        self.picView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(self.picView)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.activity = DTIActivityIndicatorView.init(frame: CGRectMake(0, 0, 60, 60))
            self.activity.center = self.picView.center
            self.picView.addSubview(self.activity)
            self.activity.startActivity()
        })
        
        self.loadImage()
        

        // Do any additional setup after loading the view.
    }
    
    func loadImage() {
        if !self.imagePath.isEmpty {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let imgUrl = NSURL(string: self.imagePath) {
                    if let cImageData = NSData(contentsOfURL: imgUrl) {
                        let cImage = UIImage(data: cImageData)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.activity.stopActivity()
                            self.picView.image = cImage
                            self.picture = cImage
                            self.shareAndDownloadBtnChages()
                        })
                    }
                }
            })
        } else {
            self.picView.image = UIImage(named: "smlogo.png")
            self.picView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    func shareAndDownloadBtnChages() {
        let shareBtn = UIButton.init(frame: CGRectMake(self.view.frame.size.width-80, 10, 30, 30))
        shareBtn.setImage(UIImage(named:"share_108.png"), forState: UIControlState.Normal)
        shareBtn.addTarget(self, action:#selector(CXImageViewController.shareBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        //shareBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picView.addSubview(shareBtn)
        
        let downlodBtn = UIButton.init(frame: CGRectMake(shareBtn.frame.size.width+shareBtn.frame.origin.x+10, 10, 30, 30))
        downlodBtn.setImage(UIImage(named: "down_icon.png"), forState: UIControlState.Normal)
        downlodBtn.addTarget(self, action: #selector(CXImageViewController.downloadAction), forControlEvents: UIControlEvents.TouchUpInside)
        //downlodBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.picView.addSubview(downlodBtn)
        
        let backBtn = UIButton.init(frame:CGRectMake(10, 10, 40, 40))
        backBtn.setImage(UIImage(named: "left_aarow.png"), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: #selector(CXImageViewController.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.picView.addSubview(backBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func shareBtnAction() {
        let webUrl = NSURL(string:self.imagePath)
        let img: UIImage = self.picture
        
        guard let url = webUrl else {
            print("nothing found")
            return
        }
        
        let shareItems:Array = [img, url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func downloadAction() {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
             UIImageWriteToSavedPhotosAlbum(self.picture, self, nil, nil)
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Silly Monks", message: "Image saved successfully", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        })
    }

    
    func completeSelector() {
        print("Saved success")
        let alert = UIAlertController(title: "Silly Monks", message: "Image saved successfully", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
