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
    
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet var userGender: UILabel!
    var imgURL: URL!
       
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
        self.imgView.layer.borderColor = UIColor.white.cgColor
        self.customizeHeaderView()
        
        self.view.backgroundColor = UIColor.smBackgroundColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(lImage, for: UIControlState())
        button.addTarget(self, action: #selector(SMProfileViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 40);
        tLabel.backgroundColor = UIColor.clear
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "MY PROFILE"
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.textColor = UIColor.white
        self.navigationItem.titleView = tLabel
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setDPImage() {
        self.strProfile = UserDefaults.standard.value(forKey: "PROFILE_PIC") as? String
        if self.strProfile != nil{
        self.imgURL = URL(string: strProfile)!
        let request: URLRequest = URLRequest(url: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse?,data: Data?,error: NSError?) -> Void in
                if error == nil {
                    self.imgView.image = UIImage(data: data!)
                }else{
                    
                }
        } as! (URLResponse?, Data?, Error?) -> Void)
        }else{
        
            self.imgView.image = UIImage(named: "profile_placeholder.png")
        
        }
        
         self.setUserData()
    }
    
    func setUserData(){

            
            self.userFullName.text = (UserDefaults.standard.value(forKey: "FIRST_NAME") as? String)!  + " " + (UserDefaults.standard.value(forKey: "LAST_NAME") as? String)!
            self.fullNameLbl.text = self.userFullName.text
            self.userGender.text = UserDefaults.standard.value(forKey: "GENDER") as? String
        if userGender.text == nil {
            self.userGender.isHidden = true
            self.genderLbl.isHidden = true
        }
        else {
            let genderStr:NSString = (UserDefaults.standard.value(forKey: "GENDER") as? NSString)!
            if genderStr.isEqual(to: "0") {
                self.userGender.isHidden = true
                self.genderLbl.isHidden = true
            }
        }
         self.userEmailLbl.text = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        
    }

    @IBAction func logoutAction(_ sender: AnyObject) {
        showAlertView("Are You Sure??", status: 1)
    
    }
    
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Smart Movie Ticket", message: message, preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                let str:AnyObject! = UserDefaults.standard.value(forKey: "USER_ID") as AnyObject
                UserDefaults.standard.set(str, forKey: "LAST_LOGIN_ID")
                
                UserDefaults.standard.removeObject(forKey: "USER_ID")
                UserDefaults.standard.removeObject(forKey: "FIRST_NAME")
                UserDefaults.standard.removeObject(forKey: "LAST_NAME")
                UserDefaults.standard.removeObject(forKey: "EMAIL")
                UserDefaults.standard.removeObject(forKey: "GENDER")
                UserDefaults.standard.removeObject(forKey: "PROFILE_PIC")
                UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
                
                UserDefaults.standard.synchronize()
                
                
                
                // for FB signout
                FBSDKLoginManager().logOut()
                
                // for Google signout
                GIDSignIn.sharedInstance().signOut()
                GIDSignIn.sharedInstance().disconnect()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LogoutNotification"), object: nil)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
