//
//  CXAdvertiseViewController.swift
//  Silly Monks
//
//  Created by Sarath on 31/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXAdvertiseViewController: UIViewController,UITextFieldDelegate {
    var submitBtn:UIButton!
    
    var nameField: UITextField!
    var mobileField: UITextField!
    var descField: UITextField!

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
        button.addTarget(self, action: #selector(CXAdvertiseViewController.backAction), forControlEvents: .TouchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Contact Us"
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
        headerLabel.text = "Advertise With Us"
        self.view.addSubview(headerLabel)

        let backView = UIView.init(frame: CGRectMake(10, headerLabel.frame.size.height+headerLabel.frame.origin.y,self.view.frame.size.width-20, 280))
        backView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backView)
        
        let nameLbl = self.createHeaderLabel(CGRectMake(2, 5, backView.frame.size.width-4, 25), title: "Name")
        backView.addSubview(nameLbl)
        self.nameField = self.createField(CGRectMake(2, nameLbl.frame.origin.y+nameLbl.frame.size.height, backView.frame.size.width-4, 40), tag: 1, placeHolder: "Name")
        backView.addSubview(nameField)
        
        let mobileLbl = self.createHeaderLabel(CGRectMake(2, nameField.frame.origin.y+nameField.frame.size.height+2, backView.frame.size.width-4, 25), title: "Mobile")
        backView.addSubview(mobileLbl)
        self.mobileField = self.createField(CGRectMake(2, mobileLbl.frame.origin.y+mobileLbl.frame.size.height, backView.frame.size.width-4, 40), tag: 3, placeHolder: "Mobile")
        backView.addSubview(mobileField)
        self.mobileField.keyboardType = UIKeyboardType.NumberPad
        self.addAccessoryViewToField(self.mobileField)
        
        
        let descLbl = self.createHeaderLabel(CGRectMake(2, mobileField.frame.origin.y+mobileField.frame.size.height+2, backView.frame.size.width-4, 25), title: "Description")
        backView.addSubview(descLbl)
        self.descField = self.createField(CGRectMake(2, descLbl.frame.origin.y+descLbl.frame.size.height, backView.frame.size.width-4, 40), tag: 2, placeHolder: "Description")
        backView.addSubview(descField)
        
        self.submitBtn = self.createButton(CGRectMake(20, descField.frame.size.height+descField.frame.origin.y+15, backView.frame.size.width-40, 40), title: "Submit", tag: 3, bgColor: UIColor.navBarColor())
        self.submitBtn.addTarget(self, action: #selector(CXContactUsViewController.submitAction), forControlEvents: .TouchUpInside)
        backView.addSubview(self.submitBtn)
        
    }
    
    func createHeaderLabel(frame:CGRect, title:String) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.font = UIFont(name: "Roboto-Bold",size: 13)
        label.text = title
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.darkGrayColor()
        return label
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
        return button
    }
    
    func submitAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clearNumPadAction() {
        self.mobileField.text = nil
        self.view.endEditing(true)
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    
    func addAccessoryViewToField(mTextField:UITextField) {
        let numToolBar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numToolBar.barStyle = UIBarStyle.BlackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(CXAdvertiseViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CXAdvertiseViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextField.inputAccessoryView = numToolBar
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
