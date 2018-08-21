//
//  CXCommentRatingViewController.swift
//  Silly Monks
//
//  Created by NUNC on 5/23/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXCommentRatingViewController: UIViewController,FloatRatingViewDelegate,UITextViewDelegate {

    var ratingLabel:UILabel!
    var floatRatingView: FloatRatingView!
    var commentsView:UITextView!
    var cScrollView:UIScrollView!
    var jobID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeHeaderView()
        self.customizeMainView()

        // Do any additional setup after loading the view.
    }
    
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "left_aarow.png") as UIImage?
        let button = UIButton (type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(lImage, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(CXCommentRatingViewController.backAction), for: .touchUpInside)
        
        let navSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.fixedSpace,target: nil, action: nil)
        navSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [navSpacer,UIBarButtonItem.init(customView: button)]
        
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 40);
        tLabel.backgroundColor = UIColor.clear
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Comments"
        tLabel.textAlignment = NSTextAlignment.center
        tLabel.textColor = UIColor.white
        self.navigationItem.titleView = tLabel
    }
    
    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-65))
        self.view.addSubview(self.cScrollView)
        
        let labelText = UILabel.init(frame: CGRect(x: 5, y: 0, width: (self.cScrollView.frame.size.width/2)-10, height: 45))
        labelText.text = "YOUR RATING"
        labelText.font = UIFont(name: "Roboto-Regular", size:15)
        labelText.textAlignment = NSTextAlignment.left
        self.cScrollView.addSubview(labelText)
        
        self.ratingLabel = UILabel.init(frame: CGRect(x: labelText.frame.size.width+labelText.frame.origin.x+5, y: 0, width: (self.cScrollView.frame.size.width/2)-10, height: 45))
        self.ratingLabel.text = "0.0"
        self.ratingLabel.font = UIFont(name: "Roboto-Regular",size: 15)
        self.ratingLabel.textAlignment = NSTextAlignment.right
        self.cScrollView.addSubview(self.ratingLabel)
        
        let ratWidth  = self.cScrollView.frame.size.width/2
        
        self.floatRatingView = self.customizeRatingView(CGRect(x: (self.cScrollView.frame.size.width-ratWidth)/2, y: self.ratingLabel.frame.size.height+self.ratingLabel.frame.origin.y,width: ratWidth, height: 40))
        self.floatRatingView.backgroundColor = UIColor.clear
        self.cScrollView.addSubview(self.floatRatingView)
        
        self.commentsView = UITextView.init(frame: CGRect(x: 5, y: self.floatRatingView.frame.size.height+self.floatRatingView.frame.origin.y, width: self.cScrollView.frame.size.width-10, height: 220))
        self.commentsView.delegate = self
        self.commentsView.font = UIFont(name: "Roboto-Regular", size: 15)
        self.commentsView.text = "Wrire at least 50 characters"
        self.commentsView.layer.borderColor = UIColor.darkGray.cgColor
        self.commentsView.layer.borderWidth = 1
        self.cScrollView.addSubview(self.commentsView)
        self.addAccessoryViewToField(self.commentsView)
        
        let submitBtn = UIButton.init(frame: CGRect(x: 10, y: self.commentsView.frame.size.height+self.commentsView.frame.origin.y+10, width: self.cScrollView.frame.size.width-20, height: 40))
        submitBtn.setTitle("Submit", for: UIControlState())
        submitBtn.backgroundColor = UIColor.darkGray
        submitBtn.setTitleColor(UIColor.white, for: UIControlState())
        submitBtn.addTarget(self, action: #selector(CXCommentRatingViewController.submitAction), for: UIControlEvents.touchUpInside)
        self.cScrollView.addSubview(submitBtn)
    }
    
    func submitAction() {
        if self.commentsView.text != nil {
            if self.commentsView.text.characters.count < 50 {
                self.showAlertView("Please enter at least 50 characters.", status: 0)
            }else{
                self.submitTheComments()
            }
        }
    }
    
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Smart Movie Ticket", message: message, preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                //self.navigationController?.popViewControllerAnimated(true)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }


    func customizeRatingView(_ frame:CGRect) -> FloatRatingView {
        let ratView : FloatRatingView = FloatRatingView.init(frame: frame)
        
        ratView.emptyImage = UIImage(named: "star_unsel_108.png")
        ratView.fullImage = UIImage(named: "star_sel_108.png")
        // Optional params
        ratView.delegate = self
        ratView.contentMode = UIViewContentMode.scaleAspectFit
        ratView.maxRating = 5
        ratView.minRating = 0
        ratView.rating = 0
        ratView.editable = true
        ratView.halfRatings = true
        ratView.floatRatings = false
        
        return ratView
    }
    
    func addAccessoryViewToField(_ mTextView:UITextView) {
        let numToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numToolBar.barStyle = UIBarStyle.blackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(CXCommentRatingViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CXCommentRatingViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextView.inputAccessoryView = numToolBar
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    //MARK: Submit the comment
    
        func commentSubiturl(_ userID:String, jobID:String,comment:String,rating:String,commentId:String) ->String{
    
            //let escapedString = productType.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            let reqString = CXConstant.sharedInstance.PRODUCTION_BASE_URL + "/jobs/saveJobCommentJSON?userId="+userID+"&jobId="+jobID+"&comment="+comment+"&rating="+rating+"&disabled=false"
            //http://storeongo.com:8081/jobs/saveJobCommentJSON?/ userId=11&jobId=239&comment=excellent&rating=0.5&commentId=74
            
            let encodedPublicUrl = reqString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

            return encodedPublicUrl
        }

    func submitTheComments(){
        /*
         return getHostUrl(mContext) + "/jobs/saveJobCommentJSON?";
         / userId=11&jobId=239&comment=excellent&rating=0.5&commentId=74 /
         */
        LoadingView.show("Submitting...", animated: true)
        guard let userId = UserDefaults.standard.value(forKey: "USER_ID") else {
            return
        }
        let number = CXConstant.resultString((userId as? AnyObject)!)
        SMSyncService.sharedInstance.startSyncProcessWithUrl(self.commentSubiturl(number, jobID: self.jobID, comment: self.commentsView.text.trimmingCharacters(in: CharacterSet.whitespaces), rating: self.ratingLabel.text!, commentId: "1")) { (responseDict) in
           // print(responseDict)
            DispatchQueue.main.async(execute: { () -> Void in
                LoadingView.hide()
                let alert = UIAlertController(title: "Smart Movie Ticket", message:"Submitted Successfully" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (alert) in
                    let viewcontrollers = self.navigationController?.viewControllers
                    for vc in viewcontrollers!
                    {
                        if vc.isKind(of: SMCategoryViewController.self)
                        {
                            self.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                    }
                    
                }))
                self.present(alert, animated: true, completion: nil)  
            })
            
        }
        
    }
    
    
    /*
     
     
    
     */
    
    func clearNumPadAction() {
        self.view.endEditing(true)
        self.commentsView.text = nil
    }


    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //ratingView.rating = 0
//        let signInView = CXSignInSignUpViewController.init()
//        self.navigationController?.pushViewController(signInView, animated: true)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //ratingView.rating = 0
        self.ratingLabel.text = NSString(format: "%.1f", self.floatRatingView.rating) as String
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Wrire at least 50 characters" {
            textView.text = ""
        }
        
        let scrollPoint = CGPoint(x: 0, y: textView.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.trimmingCharacters(in: CharacterSet.whitespaces)
        if textView.text == nil {
            textView.text = "Wrire at least 50 characters"
        }
        self.cScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.contentOffset = CGPoint(x: 0.0, y: textView.contentSize.height)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        let line : CGRect = textView.caretRectForPosition((textView.selectedTextRange?.start)!)
//        let overFlow: CGFloat = (line.origin.y + line.size.height) - ((textView.contentOffset.y + textView.bounds.size.height) - textView.contentInset.bottom - textView.contentInset.top)
//        if overFlow > 0 {
//            var offset = textView.contentOffset
//            offset.y += overFlow+7
//            UIView.animateWithDuration(0.2, animations: { 
//                textView.setContentOffset(offset, animated: true)
//            })
//        }
        
        
        
        
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
