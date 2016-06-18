//
//  CX_ForgotPasswordViewController.swift
//  Silly Monks
//
//  Created by Sarath on 13/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CX_ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    var emailAddressField: UITextField!
    var sendBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor();
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
        button.addTarget(self, action: #selector(CX_ForgotPasswordViewController.backAction), forControlEvents: .TouchUpInside)
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Forgot password"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
        
//        let rImage = UIImage(named: "sm_right_pic.png") as UIImage?
//        let rButton = UIButton (type: UIButtonType.Custom) as UIButton
//        rButton.frame = CGRectMake(0, 0, 35, 35)
//        rButton.setImage(rImage, forState: .Normal)
//        rButton.addTarget(self, action: #selector(CX_ForgotPasswordViewController.sendButtonAction), forControlEvents: .TouchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rButton)
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    
    func customizeMainView() {
        let hLabel : UILabel = UILabel()
        hLabel.frame = CGRectMake(20, 60, self.view.frame.size.width-40, 35);
        hLabel.backgroundColor = UIColor.clearColor()
        hLabel.font = UIFont.init(name: "Roboto-Bold", size: 25)
        hLabel.text = "Forgot password"
        hLabel.textAlignment = NSTextAlignment.Center
        hLabel.textColor = UIColor.darkGrayColor()
        
        self.view.addSubview(hLabel)
        
        let sLabel : UILabel = UILabel()
        sLabel.frame = CGRectMake(20, hLabel.frame.size.height+hLabel.frame.origin.y, self.view.frame.size.width-40, 20);
        sLabel.backgroundColor = UIColor.clearColor()
        sLabel.font = UIFont.init(name: "Roboto-Regular", size: 13)
        sLabel.text = "Get your password"
        sLabel.textAlignment = NSTextAlignment.Center
        sLabel.textColor = UIColor.blackColor()
        self.view.addSubview(sLabel)
        
        self.emailAddressField = self.createField(CGRectMake(30, sLabel.frame.size.height+sLabel.frame.origin.y+50, self.view.frame.size.width-60, 40), tag: 1, placeHolder: "Email address")
        self.view.addSubview(self.emailAddressField)
        
        
        self.sendBtn = self.createButton(CGRectMake(25, self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+30, self.view.frame.size.width-50, 40), title: "SEND", tag: 3, bgColor: UIColor.smOrangeColor())
        self.sendBtn.addTarget(self, action: #selector(CX_ForgotPasswordViewController.sendButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.sendBtn)
    
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Silly Monks", message:message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sendButtonAction() {//"Please enter valid email address."
        self.view.endEditing(true)
        print("Send button")
        if self.isValidEmail(self.emailAddressField.text!) {
            let forgotUrl = "http://sillymonksapp.com:8081/MobileAPIs/forgotpwd?email="+self.emailAddressField.text!
            SMSyncService.sharedInstance.startSyncProcessWithUrl(forgotUrl) { (responseDict) in
               // print("Forgot mail response \(responseDict)")
                let message = responseDict.valueForKey("result") as? String
                self.showAlert(message!)
            }
        } else {
            self.showAlert("Please enter valid email address.")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return button
    }
    
    
    func isValidEmail(email: String) -> Bool {
        //print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
