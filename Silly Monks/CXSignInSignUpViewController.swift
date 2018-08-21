//
//  CXSignInSignUpViewController.swift
//  Silly Monks
//
//  Created by Sarath on 07/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

protocol CXSingInDelegate {
    func didGoogleSignIn()
}

class CXSignInSignUpViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }

    var emailAddressField: UITextField!
    var passwordField: UITextField!
    var signInBtn:UIButton!
    var signUpBtn:UIButton!
    var skipBtn:UIButton!
    var backButton:UIButton!
    var forgotPwdBtn:UIButton!
    
    var cScrollView:UIScrollView!
    var keyboardIsShown:Bool!
    
    var googleBtn:GIDSignInButton!
    
    var orgID:String! = CXConstant.MALL_ID
    var profileImageStr:String!
    var profileImagePic:UIImageView!
    var delegate:CXSingInDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor();
        
        self.keyboardIsShown = false
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.customizeHeaderView()
        self.customizeMainView()
        
        NotificationCenter.default.addObserver(self, selector:#selector(CXSignInSignUpViewController.googleSignUp(_:)), name: NSNotification.Name(rawValue: "GoogleSignUp"), object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("GoogleSignUp")
    }
    func customizeHeaderView() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        //self.backButton.hidden = false
        self.backButton = UIButton (type: UIButtonType.custom) as UIButton
        self.backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.backButton.setImage(lImage, for: UIControlState())
        self.backButton.backgroundColor = UIColor.clear
        self.backButton.addTarget(self, action: #selector(CXSignInSignUpViewController.backAction), for: .touchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.fixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: self.backButton)]
        
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 40);
        tLabel.backgroundColor = UIColor.clear
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Sign in or Sign up"
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.textColor = UIColor.white
        self.navigationItem.titleView = tLabel
        
    }
    
    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-65))
        self.cScrollView.backgroundColor = UIColor.clear
        self.cScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
        
        self.view.addSubview(self.cScrollView)
        
        let logo: UIImageView = UIImageView.init(frame: CGRect(x: self.view.frame.size.width/2-45, y: 5, width: 90, height: 90))
        logo.image = UIImage(named: "smlogo1.png")
//        logo.layer.cornerRadius = 50
//        logo.clipsToBounds = true
        self.cScrollView.addSubview(logo)
        
        if !UserDefaults.standard.bool(forKey: "FIRST_TIME_LOGIN"){
            self.backButton.isHidden = true
            self.skipBtn = self.createButton(CGRect(x: self.view.frame.size.width - 100, y: 15, width: 60 ,height: 30), title: "SKIP", tag: 1000, bgColor: UIColor.navBarColor())
            self.skipBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.skipAction), for: .touchUpInside)
            UserDefaults.standard.set(true, forKey: "FIRST_TIME_LOGIN")
            self.cScrollView.addSubview(self.skipBtn)
        }
        
        let hLabel : UILabel = UILabel()
        hLabel.frame = CGRect(x: 20, y: logo.frame.size.height+logo.frame.origin.y+5, width: self.view.frame.size.width-40, height: 35);
        hLabel.backgroundColor = UIColor.clear
        hLabel.font = UIFont.init(name: "Roboto-Bold", size:15)//25
        hLabel.text = "Sign-in with:"
        hLabel.textAlignment = NSTextAlignment.center
        hLabel.textColor = UIColor.black
        
        self.cScrollView.addSubview(hLabel)
        
        let fbLoginBtn = FBSDKLoginButton.init(frame: CGRect(x: (self.view.frame.size.width-200)/2, y: hLabel.frame.size.height+hLabel.frame.origin.y+10, width: 200, height: 40))
        fbLoginBtn.delegate = self
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        self.cScrollView.addSubview(fbLoginBtn)
        
        
        self.googleBtn = GIDSignInButton.init(frame: CGRect(x: fbLoginBtn.frame.origin.x, y: fbLoginBtn.frame.origin.y+fbLoginBtn.frame.size.height+20, width: 200, height: 30))
        self.cScrollView.addSubview(self.googleBtn)
        
        let sepLabel : UILabel = UILabel()
        sepLabel.frame = CGRect(x: 20, y: self.googleBtn.frame.size.height+self.googleBtn.frame.origin.y+20, width: self.view.frame.size.width-40, height: 20);
        sepLabel.backgroundColor = UIColor.clear
        sepLabel.font = UIFont.init(name: "Roboto-Regular", size: 13)
        sepLabel.text = "----------------- OR -------------------"
        sepLabel.textAlignment = NSTextAlignment.center
        sepLabel.textColor = UIColor.black
        self.cScrollView.addSubview(sepLabel)
        
        self.emailAddressField = self.createField(CGRect(x: 30, y: sepLabel.frame.size.height+sepLabel.frame.origin.y+5, width: self.view.frame.size.width-60, height: 40), tag: 1, placeHolder: "Email address")
        
        let mailImg = UIImageView.init(image: UIImage(named:"mail_icon.png"))
        mailImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)//sLabel.frame.size.height+sLabel.frame.origin.y+50
        self.emailAddressField.leftViewMode = UITextFieldViewMode.always
        self.emailAddressField.leftView = mailImg
        
        self.cScrollView.addSubview(self.emailAddressField)
        
        self.passwordField = self.createField(CGRect(x: 30, y: self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+20, width: self.view.frame.size.width-60, height: 40), tag: 2, placeHolder: "Password")
        let lockImg = UIImageView.init(image: UIImage(named:"lock_icon.png"))
        lockImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.passwordField.leftViewMode = UITextFieldViewMode.always
        self.passwordField.leftView = lockImg
        self.passwordField.isSecureTextEntry = true
        self.cScrollView.addSubview(self.passwordField)
        
        self.signInBtn = self.createButton(CGRect(x: 25, y: self.passwordField.frame.size.height+self.passwordField.frame.origin.y+15, width: self.view.frame.size.width-50, height: 40), title: "Sign in", tag: 3, bgColor: UIColor.navBarColor())
        self.signInBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.signInAction), for: .touchUpInside)
        self.cScrollView.addSubview(self.signInBtn)
        
        self.forgotPwdBtn = self.createPlainTextButton(CGRect(x: 10, y: self.signInBtn.frame.size.height+self.signInBtn.frame.origin.y+5, width: self.view.frame.size.width-20, height: 30), title: "Forgot password?", tag: 98)
        self.forgotPwdBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.forgotPasswordAction), for: .touchUpInside)
        self.cScrollView.addSubview(self.forgotPwdBtn)
        
        self.signUpBtn = self.createPlainTextButton(CGRect(x: 25, y: self.forgotPwdBtn.frame.size.height+self.forgotPwdBtn.frame.origin.y+5,width: self.view.frame.size.width-50, height: 30), title: "Want to sign up?", tag: 5)
        self.signUpBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.signUpAction), for: .touchUpInside)
        self.cScrollView.addSubview(self.signUpBtn)
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Response \(result)")
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,email,last_name,gender,picture.type(large),id"]).start { (connection, result, error) -> Void in
            //print ("FB Result is \(result)")
            if result != nil {
                //TODO:MAHESH
               /*let strFirstName: String = (result.object(forKey: "first_name") as? String)!
                let strLastName: String = (result.object(forKey: "last_name") as? String)!
                let gender: String = (result.object(forKey: "gender") as? String)!
                let email: String = (result.object(forKey: "email") as? String)!
                self.profileImageStr = (result.object(forKey: "picture")?.object(forKey: "data")?.object(forKey: "url") as? String)!*/
               // print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) \(self.profileImageStr)")
                
        
                UserDefaults.standard.set(self.profileImageStr, forKey: "PROFILE_PIC")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateProfilePic"), object: nil)
        // self.registeringWithSillyMonks(email, firstname: strFirstName, lastname: strLastName, gender: gender, profilePic: self.profileImageStr)
            }
            
        }
        
    }
    
    func registeringWithSillyMonks(_ email:String, firstname:String, lastname:String, gender:String, profilePic:String){
        
        var urlString : String = CXConstant.sharedInstance.PRODUCTION_BASE_URL + "/MobileAPIs/regAndloyaltyAPI?"
        urlString = urlString + ("orgId="+self.orgID)
        urlString = urlString + ("&userEmailId="+email)
        urlString = urlString + "&dt=DEVICES "
        urlString = urlString + ("&firstName="+firstname)
        urlString = urlString + ("&lastName="+lastname)
        urlString = urlString + ("&gender="+gender)
        urlString = urlString + ("&filePath="+profilePic)
        urlString = urlString + "&isLoginWithFB=true"
        
        print("Url Encoded string is \(urlString)")
        
        SMSyncService.sharedInstance.startSyncProcessWithUrl(urlString.addingPercentEscapes(using: String.Encoding.utf8)!) { (responseDict) in
           // print("Login response \(responseDict)")
            let userIdStr:String = (String)(describing: responseDict.value(forKey: "UserId"))
            CXDBSettings.sharedInstance.removeTheFavaourites(userIdStr)
            let status: Int = Int(responseDict.value(forKey: "status") as! String)!
            if status == 1 {
                UserDefaults.standard.set(responseDict.value(forKey: "UserId"), forKey: "USER_ID")
                UserDefaults.standard.set(responseDict.value(forKey: "emailId"), forKey: "USER_EMAIL")
                UserDefaults.standard.set(responseDict.value(forKey: "firstName"), forKey: "FIRST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "lastName"), forKey: "LAST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "gender"), forKey: "GENDER")
                self.showAlertView("Login successfully.", status: 1)
                
            } else {
                self.showAlertView("Please enter valid credentials", status: status)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    
    // Google
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: NSError!) {
        //  myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func  createPlainTextButton(_ frame:CGRect,title: String,tag:Int) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.backgroundColor = UIColor.clear
        return button
        
    }
    
    func googleSignUp(_ notification: Notification){
        
        let dic = notification.object as! NSDictionary
        let orgID:String! = CXConstant.MALL_ID
        let firstName = dic["given_name"] as! String
        var gender = ""
        let lastName = dic["family_name"] as! String
        let keys : NSArray = (dic.allKeys as NSArray)
        if  keys.contains("gender") {
            gender = dic["gender"] as! String
        }else{
        }
        let  profilePic = dic["picture"] as! String
        let  email = dic["email"] as! String
        
        print("\(email)\(firstName)\(lastName)\(gender)\(profilePic)\(orgID)")
        UserDefaults.standard.set(profilePic, forKey: "PROFILE_PIC")
        UserDefaults.standard.synchronize()

        self.registeringWithSillyMonks(email,firstname:firstName, lastname: lastName, gender: gender, profilePic:profilePic)
         NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateProfilePic"), object: nil)

    }
    
    
    func showAlertView(_ message:String, status:Int) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Smart Movie Ticket", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                UIAlertAction in
                if status == 1 {
                    if self.backButton.isHidden {
                        self.skipAction()
                    }else{
                        
                        self.delegate?.didGoogleSignIn()
                        self.navigationController?.popViewController(animated: true)
                                           }
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func sendSignDetails() {
        let signInUrl = CXConstant.sharedInstance.PRODUCTION_BASE_URL + "/MobileAPIs/loginConsumerForOrg?orgId="+orgID+"&email="+self.emailAddressField.text!+"&dt=DEVICES&password="+self.passwordField.text!
        SMSyncService.sharedInstance.startSyncProcessWithUrl(signInUrl) { (responseDict) in
            // print("Login response \(responseDict)")
            let userIdStr:String = (String)(describing: responseDict.value(forKey: "UserId"))
            CXDBSettings.sharedInstance.removeTheFavaourites(userIdStr)
            let status: Int = Int(responseDict.value(forKey: "status") as! String)!
            
            if status == 1 {
                UserDefaults.standard.set(responseDict.value(forKey: "UserId"), forKey: "USER_ID")
                UserDefaults.standard.set(responseDict.value(forKey: "emailId"), forKey: "USER_EMAIL")
                UserDefaults.standard.set(responseDict.value(forKey: "firstName"), forKey: "FIRST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "lastName"), forKey: "LAST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "gender"), forKey: "GENDER")
                UserDefaults.standard.set(nil, forKey: "PROFILE_PIC")
                UserDefaults.standard.synchronize()
                self.showAlertView("Login successfully", status: status)
                
            } else {
                self.showAlertView("Please enter valid credentials", status: status)
            }
        }
    }
    
    func signInAction() {
        // print ("Sign In action")
        self.view.endEditing(true)
        if self.isValidEmail(self.emailAddressField.text!) {
            self.sendSignDetails()
        } else {
                let alert = UIAlertController(title: "Smart Movie Ticket", message: "Please enter valid email.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                //print("Please enter valid email")
        }
    }
    
    func signUpAction() {
       // print ("Sign Up action")
        self.view.endEditing(true)
        let signUpView = CXSignUpViewController.init()
        signUpView.orgID = self.orgID
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    
    func skipAction() {
       // print ("Skip action")
        let homeView = HomeViewController.init()
        let sideMenu = SMMenuViewController.init()
        let  navController: SMNavigationController = SMNavigationController(menuViewController: sideMenu,contentViewController: homeView)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = navController
        appDelegate.window!.makeKeyAndVisible()
    }
    
    func forgotPasswordAction() {
        self.view.endEditing(true)
        let fpView = CX_ForgotPasswordViewController.init()
        self.navigationController?.pushViewController(fpView, animated: true)
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBtnAction() {
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    
    func createField(_ frame:CGRect, tag:Int, placeHolder:String) -> UITextField {
        let txtField : UITextField = UITextField()
        txtField.frame = frame;
        txtField.delegate = self
        txtField.tag = tag
        txtField.placeholder = placeHolder
        txtField.font = UIFont.init(name:"Roboto-Regular", size: 15)
        txtField.autocapitalizationType = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
    }
    
    func createButton(_ frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        return button
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
