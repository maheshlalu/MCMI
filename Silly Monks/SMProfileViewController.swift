//
//  SMProfileViewController.swift
//  SMSample
//
//  Created by CX_One on 7/28/16.
//  Copyright © 2016 CX_One. All rights reserved.
//

import UIKit

class SMProfileViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    var strProfile : String!

    @IBOutlet var userEmailLbl: UILabel!

    @IBOutlet var fullNameLbl: UILabel!
    @IBOutlet var userFullName: UILabel!
    
    @IBOutlet var userGender: UILabel!
       
//    @IBAction func favoritesBtnAction(sender: AnyObject) {
//        
//        let favoritesViewController = UserFavoritesViewController(nibName: "UserFavoritesViewController", bundle: nil)
//        self.navigationController?.pushViewController(favoritesViewController, animated: true)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDPImage()
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2
        self.imgView.clipsToBounds = true
        self.imgView.layer.borderWidth = 3.0
        self.imgView.layer.borderColor = UIColor.whiteColor().CGColor
        self.customizeHeaderView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 40, 40)
        button.setImage(lImage, forState: .Normal)
        button.addTarget(self, action: #selector(SMProfileViewController.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "MY PROFILE"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func setDPImage() {
        self.strProfile = NSUserDefaults.standardUserDefaults().valueForKey("PROFILE_PIC") as? String
        let imgURL: NSURL = NSURL(string: strProfile)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.imgView.image = UIImage(data: data!)
                }
        })
        self.setUserData()
    }
    
    func setUserData(){
        
        self.userFullName.text = (NSUserDefaults.standardUserDefaults().valueForKey("FIRST_NAME") as? String)!  + " " + (NSUserDefaults.standardUserDefaults().valueForKey("LAST_NAME") as? String)!
        self.fullNameLbl.text = self.userFullName.text
        self.userGender.text = NSUserDefaults.standardUserDefaults().valueForKey("GENDER") as? String
        self.userEmailLbl.text = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String

        
        /*
         NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "USER_ID")
         NSUserDefaults.standardUserDefaults().setObject(strFirstName, forKey: "FIRST_NAME")
         NSUserDefaults.standardUserDefaults().setObject(strLastName, forKey: "LAST_NAME")
         NSUserDefaults.standardUserDefaults().setObject(gender, forKey: "GENDER")
         NSUserDefaults.standardUserDefaults().setObject(self.profileImageStr, forKey: "PROFILE_PIC")
         NSUserDefaults.standardUserDefaults().synchronize()
         */
        
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
