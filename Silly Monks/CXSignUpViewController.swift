//
//  CXSignUpViewController.swift
//  Silly Monks
//
//  Created by NUNC on 5/19/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

enum SignUpMembers {
    case FIRST_NAME
    case LAST_NAME
    case MOBILE_NUMBER
    case EMAIL_ADDRESS
    case PASSWORD
}


class CXSignUpViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {
    
    var cScrollView:UIScrollView!
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var mobileNumField: UITextField!
    var emailAddressField: UITextField!
    var passwordField:UITextField!
    
    var signInBtn:UIButton!
    var signUpBtn: UIButton!
    
    var orgID:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeHeaderView()
        self.customizeMainView()
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
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(CXSignUpViewController.backAction), forControlEvents: .TouchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Sign up"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65))
        self.cScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600)
        self.view.addSubview(self.cScrollView)
        
        let signUpLbl = UILabel.createHeaderLabel(CGRectMake(20, 0, self.cScrollView.frame.size.width-40, 40), text: "Sign Up",font:UIFont.init(name: "Roboto-Bold", size: 18)!)
        self.cScrollView.addSubview(signUpLbl)
        let signUpSubLbl = UILabel.createHeaderLabel(CGRectMake(20, signUpLbl.frame.origin.y+signUpLbl.frame.size.height, self.cScrollView.frame.size.width-40, 40), text: "Sign up with email address",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.cScrollView.addSubview(signUpSubLbl)
        
        self.firstNameField = self.createField(CGRectMake(30, signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+20, self.cScrollView.frame.size.width-60, 40), tag: 1, placeHolder: "First Name")
        self.cScrollView.addSubview(self.firstNameField)
        
        self.lastNameField = self.createField(CGRectMake(30, self.firstNameField.frame.size.height+self.firstNameField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 2, placeHolder: "Last Name")
        self.cScrollView.addSubview(self.lastNameField)
        
        self.mobileNumField = self.createField(CGRectMake(30, self.lastNameField.frame.size.height+self.lastNameField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 3, placeHolder: "Mobile Number")
        self.mobileNumField.keyboardType = UIKeyboardType.NumberPad
        self.addAccessoryViewToField(self.mobileNumField)
        self.cScrollView.addSubview(self.mobileNumField)
        
        self.emailAddressField = self.createField(CGRectMake(30, self.mobileNumField.frame.size.height+self.mobileNumField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 4, placeHolder: "Email Address")
        self.emailAddressField.keyboardType = UIKeyboardType.EmailAddress
        self.cScrollView.addSubview(self.emailAddressField)
        
        self.passwordField = self.createField(CGRectMake(30, self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 5, placeHolder: "Password")
        self.passwordField.secureTextEntry = true
        self.cScrollView.addSubview(self.passwordField)
        
        self.signUpBtn = self.createButton(CGRectMake(25, self.passwordField.frame.size.height+self.passwordField.frame.origin.y+30, self.view.frame.size.width-50, 40), title: "SIGN UP", tag: 3, bgColor: UIColor.smOrangeColor())
        self.signUpBtn.addTarget(self, action: #selector(CXSignUpViewController.signUpBtnAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signUpBtn)
        
        self.signInBtn = self.createButton(CGRectMake(25, self.signUpBtn.frame.size.height+self.signUpBtn.frame.origin.y+30, self.view.frame.size.width-50, 40), title: "SIGN IN", tag: 3, bgColor: UIColor.navBarColor())
        self.signInBtn.addTarget(self, action: #selector(CXSignUpViewController.signInBtnAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signInBtn)
        
    }
    func clearNumPadAction() {
        self.mobileNumField.text = nil
        self.view.endEditing(true)
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    
    func addAccessoryViewToField(mTextField:UITextField) {
        let numToolBar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numToolBar.barStyle = UIBarStyle.BlackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(CXSignUpViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CXSignUpViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextField.inputAccessoryView = numToolBar
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func sendSignUpDetails() {
        //http://sillymonksapp.com:8081/MobileAPIs/regAndloyaltyAPI?orgId=3&userEmailId

//        NSLog("Print values orgid: %@ email: %@ firstname: %@ lastname: %@ psw: %@ ", orgID, self.emailAddressField.text, self.firstNameField.text, self.lastNameField.text, self.passwordField.text)
        let signUpUrl = "http://sillymonksapp.com:8081/MobileAPIs/regAndloyaltyAPI?orgId="+orgID+"&userEmailId="+self.emailAddressField.text!+"&dt=DEVICES&firstName="+self.firstNameField.text!.urlEncoding()+"&lastName="+self.lastNameField.text!.urlEncoding()+"&password="+self.passwordField.text!.urlEncoding()
        SMSyncService.sharedInstance.startSyncProcessWithUrl(signUpUrl) { (responseDict) in
            print("Sign up response \(responseDict)")
            
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("UserId"), forKey: "USER_ID")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("emailId"), forKey: "USER_EMAIL")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("firstName"), forKey: "FIRST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("lastName"), forKey: "LAST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("gender"), forKey: "GENDER")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "PROFILE_PIC")
            NSUserDefaults.standardUserDefaults().synchronize()
            
             let message = responseDict.valueForKey("msg") as? String
            
           let alert = UIAlertController(title: "Silly Monks", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                //self.moveBackView()
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func moveBackView() {
        let navControllers:NSArray = (self.navigationController?.viewControllers)!
        let prevController = navControllers.objectAtIndex(navControllers.count-3)
        self.navigationController?.popToViewController(prevController as! UIViewController, animated: true)
    }
    
    func signUpBtnAction() {
        self.view.endEditing(true)
        if self.firstNameField.text?.characters.count > 0
            && self.lastNameField.text?.characters.count > 0
            && self.emailAddressField.text?.characters.count > 0
            && self.passwordField.text?.characters.count > 0 &&
            self.mobileNumField.text?.characters.count > 0 {
            if !self.isValidEmail(self.emailAddressField.text!) {
                let alert = UIAlertController(title: "Silly Monks", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if self.mobileNumField.text?.characters.count < 10 {
                let alert = UIAlertController(title: "Silly Monks", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                   // self.navigationController?.popViewControllerAnimated(true)
                    
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            self.sendSignUpDetails()
            
        } else {
            let alert = UIAlertController(title: "Silly Monks", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func signInBtnAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    func createField(frame:CGRect, tag:Int, placeHolder:String) -> UITextField {
        let txtField : UITextField = UITextField()
        txtField.frame = frame;
        txtField.delegate = self
        txtField.tag = tag
        txtField.placeholder = placeHolder
        txtField.font = UIFont.init(name:"Roboto-Regular", size: 15)
        txtField.autocapitalizationType = .None
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
    }
    
    func createButton(frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        return button
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.cScrollView.endEditing(true)
    }
    
    func isValidEmail(email: String) -> Bool {
       // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let scrollPoint = CGPointMake(0, textField.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.cScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            if  range.length==1 && string.characters.count == 0 {
                return true
            }
            if textField.text?.characters.count >= 10 {
                return false
            }
            let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
            return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }

}

extension UILabel {
    static func createHeaderLabel(frame :CGRect,text:String, font:UIFont) -> UILabel {
        let cLabel = UILabel.init(frame: frame)
        cLabel.font = font//UIFont.init(name: "Roboto-Bold", size: 18)
        cLabel.text = text
        cLabel.textAlignment = NSTextAlignment.Center
        cLabel.textColor = UIColor.darkGrayColor()
        return cLabel
    }
}
