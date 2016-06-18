//
//  CXAboutUsViewController.swift
//  Silly Monks
//
//  Created by NUNC on 5/30/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXAboutUsViewController: UIViewController,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeHeaderView()
        self.customizeMainView()

        // Do any additional setup after loading the view.
    }

    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(CXAboutUsViewController.backAction), forControlEvents: .TouchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "About Us"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func customizeMainView() {
        let headerLabel = UILabel.init(frame: CGRectMake(5, 0, self.view.frame.size.width-10, 40))
        headerLabel.font = UIFont(name: "Roboto-Bold",size: 18)
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.text = "About SillyMonks"
        self.view.addSubview(headerLabel)
        
        
        let cView = UIView.init(frame:CGRectMake(5, headerLabel.frame.origin.y+headerLabel.frame.size.height+5, self.view.frame.size.width-10, 350))
        cView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cView)
        
        let contentView = UITextView.init(frame: CGRectMake(5, 5, cView.frame.size.width-10, 260))
        contentView.delegate = self
        contentView.editable = true
        contentView.font = UIFont(name: "Roboto-Regular",size: 14)
        contentView.textColor = UIColor.grayColor()
        contentView.text = "From Jennifer Lawrence to Shahrukh Khan, from Rajinikanth to Kamal Hassan, from Pawan Kalyan to Mohan Lal. Catch up with all your favourite stars, films, and celeb news right here. We’ve got trailers and reviews from Tollywood, Kollywood, Mollywood, Bollywood and Hollywood, so buckle up and settle down for some glitzy fun! Hang on. Movies ain’t your cup of tea? No problem- Silly Monks’ cup is brimming with short films, music and YouTube news too! Album reviews, band news, short film discussions… we’re not even sure you can handle all this. So what are you waiting for? Take a nice big sip!"
        cView.addSubview(contentView)
        
        let infoLabel = UILabel.init(frame: CGRectMake(5, contentView.frame.size.height+contentView.frame.origin.y, cView.frame.size.width-10, 80))
        infoLabel.numberOfLines = 0
        infoLabel.textColor = UIColor.grayColor()
        infoLabel.font = UIFont(name: "Roboto-Regular",size: 14)
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.text = " The Silly Monks App.\nYour gateway to the world of Entertainment"
        cView.addSubview(infoLabel)
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
