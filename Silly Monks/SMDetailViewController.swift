//
//  SMDetailViewController.swift
//  Silly Monks
//
//  Created by Sarath on 07/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage


class SMDetailViewController: UIViewController, FloatRatingViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var contentImage: UIImage!
    var contentScrollView : UIScrollView!
    var floatRatingView: FloatRatingView!
    var storedOffsets = [Int: CGFloat]()
    var detailTableView: UITableView!
    var product:CX_Products!
    var productCategory:CX_Product_Category!
    var imageCache:NSCache = NSCache()
    var relatedArticles:NSMutableArray!
    var remainingProducts:NSMutableArray!
    var activity:DTIActivityIndicatorView!
    var likeButton: UIButton!
    var ratingValue: String!
    var avgRatingLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:0, y:0, width:60.0, height:60.0))
        self.activity.center = self.view.center
        self.view.addSubview(self.activity)
        
        self.customizeHeaderView()
        self.customizeMainView()
    }
    
    func getRelatedProducts() {
        if (self.product.tagValue != nil){
            self.relatedArticles = CXDBSettings.getRelatedProductsWithCategory(self.product.tagValue!, mallID: self.productCategory.mallID!)
            if self.relatedArticles.containsObject(self.product) {
                self.relatedArticles.removeObject(self.product)
            }
        } else {
            self.relatedArticles = NSMutableArray()
        }
    }
    
    func getRemainingProducts() {
        self.remainingProducts = CXDBSettings.getProductsWithCategory(productCategory)
        if self.remainingProducts.containsObject(self.product) {
            self.remainingProducts.removeObject(self.product)
        }
    }


    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        CXConstant.restrictRotation(true)
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    func customizeHeaderView() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarColor()
        
        let lImage = UIImage(named: "smlogo.png") as UIImage?
        let button = UIButton (type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 50, 50)
        button.setImage(lImage, forState: .Normal)
        button.addTarget(self, action: #selector(SMDetailViewController.backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
        let tLabel : UILabel = UILabel()
        tLabel.frame = CGRectMake(0, 0, 120, 40);
        tLabel.backgroundColor = UIColor.clearColor()
        tLabel.font = UIFont.init(name: "Roboto-Bold", size: 18)
        tLabel.text = "Silly Monks"
        tLabel.textAlignment = NSTextAlignment.Center
        tLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = tLabel
    }
    
    func getProductInfo(produkt:CX_Products, input:String) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(produkt.json!))
        let info : String = json.valueForKey(input) as! String
        return info
    }
    
    func getJobID(input:String) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(self.product.json!))
        let info : String = CXConstant.resultString(json.valueForKey(input)!)
        return info

    }
    
    func customizeMainView() {
        self.getRelatedProducts()
        self.getRemainingProducts()
        
        self.contentScrollView = UIScrollView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.contentScrollView.backgroundColor = UIColor.smBackgroundColor()
        self.contentScrollView.showsVerticalScrollIndicator = false
        
        let contentImageView: UIImageView = UIImageView.init(frame: CGRectMake(0, 0, self.contentScrollView.frame.size.width, (self.contentScrollView.frame.size.width)/2))//10, 20,190
        contentImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let attachements : NSArray = CXDBSettings.getProductAttachments(self.product)
        if attachements.count > 0 {
            let attachment:NSDictionary = attachements.objectAtIndex(0) as! NSDictionary
            let prodImage: String = attachment.valueForKey("URL") as! String
            contentImageView.image = CXConstant.getImageFromUrlString(prodImage)
        } else {
            contentImageView.image = UIImage(named: "smlogo.png")
        }
        contentImageView.userInteractionEnabled = true
        
        let playBtn: UIButton = UIButton.init(type: UIButtonType.Custom)
        playBtn.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
        playBtn.frame = CGRectMake(contentImageView.center.x-25, contentImageView.center.y-25, 50, 50)
        playBtn.addTarget(self, action: #selector(SMDetailViewController.playBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        contentImageView.addSubview(playBtn)
        
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(self.product.json!))
        let brightCoveID = json.valueForKey("brightcove_videoid")
        let youtubeURL = json.valueForKey("YouTube URL")
        
        if brightCoveID?.length() > 0 || youtubeURL?.length() > 0 {
            playBtn.hidden = false
        } else {
            playBtn.hidden = true
        }
        
        self.contentScrollView.addSubview(contentImageView)

        
        let infoText = self.parseProductDescription(self.getProductInfo(product, input: "Description"))
        
        let heightView = self.heightForView(infoText, font: UIFont(name: "Roboto-Regular", size: 14)!, width: self.contentScrollView.frame.size.width-36)
        
        let contView = UIView.init(frame: CGRectMake(10, contentImageView.frame.size.height+contentImageView.frame.origin.y+5, self.contentScrollView.frame.size.width-20, heightView+10+30))
        contView.backgroundColor = UIColor.whiteColor()
        
        let contentTitleLbl :UILabel = self.createHeaderLabel(CGRectMake(10, 5,contView.frame.size.width-10, 50), title: self.getProductInfo(self.product, input: "Name"))
        contView.addSubview(contentTitleLbl)
        
        let contentLabel : UILabel = self.createLable(CGRectMake(8, contentTitleLbl.frame.size.height+contentTitleLbl.frame.origin.y, contView.frame.size.width-14, 50), text: infoText)
        contView.addSubview(contentLabel)
        
        self.contentScrollView.addSubview(contView)
        
        let ratingComentsView: UIView = self.customizeRatCommentsView(CGRectMake(10, contView.frame.size.height+contView.frame.origin.y+5, self.contentScrollView.frame.size.width-20, 60))
        self.contentScrollView.addSubview(ratingComentsView)
        
        let cellls:Int = CXDBSettings.getProductAttachments(self.product).count + 1
        var tableHeight = (CGFloat(cellls)*CXConstant.RELATED_ARTICLES_CELL_HEIGHT)-250
        let cellHeight = (self.contentScrollView.frame.size.width-20)/2
        
        if self.relatedArticles.count > 0 {
            tableHeight = (CGFloat(cellls)*cellHeight)+(2*CXConstant.RELATED_ARTICLES_CELL_HEIGHT)-50
        } else {
            tableHeight = (CGFloat(cellls)*cellHeight)+CXConstant.RELATED_ARTICLES_CELL_HEIGHT-50
        }

        self.detailTableView = self.customizeTableView(CGRectMake(10, ratingComentsView.frame.size.height+ratingComentsView.frame.origin.y+12.5, self.contentScrollView.frame.size.width-20,tableHeight))// y= 25+5
        self.contentScrollView.addSubview(self.detailTableView)
        self.view.addSubview(self.contentScrollView)
        
        let contentHeight = 190+heightView+10+30+60+self.detailTableView.frame.size.height+100
        self.contentScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height:contentHeight)
    }
    
    func playBtnAction() {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(self.product.json!))
        let brightCoveID = json.valueForKey("brightcove_videoid")
        let youtubeURL = json.valueForKey("YouTube URL")
        
        if youtubeURL?.length() > 0 {
            let videoPlayerView = CX_YoutubeVideoPlayerController.init()
            videoPlayerView.playURL = youtubeURL as? String
            self.navigationController?.pushViewController(videoPlayerView, animated: true)
        } else if brightCoveID?.length() > 0 {
            let coder: NSCoder = NSCoder.empty()
            let videoPlayer = CXVideoPlayerViewController.init(coder: coder)
            videoPlayer!.playerID = brightCoveID as? String
            self.navigationController?.pushViewController(videoPlayer!, animated: true)
        }
    }
    
    func customizeRatCommentsView(vFrame: CGRect) -> UIView {
        let rView: UIView = UIView.init()
        rView.backgroundColor = UIColor.whiteColor()
        rView.frame = vFrame
        
        self.avgRatingLabel = UILabel.init()
        self.avgRatingLabel.frame = CGRectMake(2, 2, (rView.frame.size.width-4)/2, 20)
        self.avgRatingLabel.font = UIFont(name:"Roboto-Regular", size:13)
        self.avgRatingLabel.text = "Avg.user ratings:0.0/5"
        self.avgRatingLabel.textAlignment = NSTextAlignment.Left
        self.avgRatingLabel.textColor = UIColor.grayColor()
        rView.addSubview(self.avgRatingLabel)
        
        let likeLbl : UILabel = UILabel.init()
        likeLbl.frame = CGRectMake(self.avgRatingLabel.frame.size.width+self.avgRatingLabel.frame.origin.x, 2, self.avgRatingLabel.frame.size.width, 20)
        likeLbl.font = UIFont(name:"Roboto-Regular", size:13)
        likeLbl.text = "Like"
        likeLbl.textAlignment = NSTextAlignment.Right
        likeLbl.textColor = UIColor.grayColor()
        rView.addSubview(likeLbl)

        self.floatRatingView = self.customizeRatingView(CGRectMake(2, self.avgRatingLabel.frame.size.height+self.avgRatingLabel.frame.origin.y, self.avgRatingLabel.frame.size.width, 30))
        self.floatRatingView.backgroundColor = UIColor.whiteColor()
        rView.addSubview(self.floatRatingView)
        
        let btnWidth: CGFloat = 30
        let space: CGFloat = 5
        let numBtns: CGFloat = 3
        
        let comentBtn = self.createButton(CGRectMake(rView.frame.size.width-((numBtns * btnWidth)+((numBtns-1)*space)), self.floatRatingView.frame.origin.y, btnWidth, btnWidth), img: UIImage(named: "comments_108.png")!)
        comentBtn.addTarget(self, action: #selector(SMDetailViewController.commentAction), forControlEvents: UIControlEvents.TouchUpInside)
        //rView.addSubview(comentBtn)

        let shareBtn = self.createButton(CGRectMake(comentBtn.frame.size.width+comentBtn.frame.origin.x+space, self.floatRatingView.frame.origin.y, btnWidth, btnWidth), img: UIImage(named: "share_108.png")!)
        shareBtn.addTarget(self, action: #selector(SMDetailViewController.shareAction), forControlEvents: UIControlEvents.TouchUpInside)
        rView.addSubview(shareBtn)

        self.likeButton = self.createButton(CGRectMake(shareBtn.frame.size.width+shareBtn.frame.origin.x+space, self.floatRatingView.frame.origin.y, btnWidth, btnWidth), img: UIImage(named: "favourite_unsel_108.png")!)
        self.likeButton.addTarget(self, action: #selector(SMDetailViewController.likeAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.likeButton.setImage(UIImage(named: "favourite_sel_108.png"), forState: UIControlState.Selected)
        rView.addSubview(self.likeButton)

        return rView

    }
    /* http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift  */
    
    func parseProductDescription(desc:String) -> String {
        let normalString : String = desc.html2String
        return normalString
    }
    
    func customizeRatingView(frame:CGRect) -> FloatRatingView {
        let ratView : FloatRatingView = FloatRatingView.init(frame: frame)
        
        ratView.emptyImage = UIImage(named: "star_unsel_108.png")
        ratView.fullImage = UIImage(named: "star_sel_108.png")
        // Optional params
        ratView.delegate = self
        ratView.contentMode = UIViewContentMode.ScaleAspectFit
        ratView.maxRating = 5
        ratView.minRating = 0
        ratView.rating = 0
        ratView.editable = true
        ratView.halfRatings = true
        ratView.floatRatings = false
    
        return ratView
    }
    
    func customizeTableView(tFrame: CGRect) -> UITableView {
        let tabView:UITableView = UITableView.init(frame: tFrame)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.backgroundColor = UIColor.clearColor()
        tabView.registerClass(CXRelatedArticleTableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tabView.registerClass(CXImageDetailTableViewCell.self, forCellReuseIdentifier: "ImageCellID")
        tabView.separatorStyle = UITableViewCellSeparatorStyle.None
        tabView.contentInset = UIEdgeInsetsMake(0, 0,20, 0)///
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.scrollEnabled = false
        return tabView;
    }
    
    func createLable(lFrame:CGRect, text: String) -> UILabel{
        let cLabel = UILabel.init()
        cLabel.frame = CGRectMake(lFrame.origin.x, lFrame.origin.y, lFrame.size.width, cLabel.requiredHeight(text))
        cLabel.backgroundColor = UIColor.whiteColor()
        cLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cLabel.textColor = UIColor.grayColor()
        cLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        cLabel.text = text
        cLabel.textAlignment = NSTextAlignment.Left
        cLabel.numberOfLines = 0
        cLabel.sizeToFit()
        return cLabel
    }
    
    func createHeaderLabel(lFrame:CGRect, title:String) -> UILabel {
        let cLabel = UILabel.init()
        cLabel.frame = CGRectMake(lFrame.origin.x, lFrame.origin.y, lFrame.size.width, 30)
        cLabel.backgroundColor = UIColor.whiteColor()
        cLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cLabel.textColor = UIColor.grayColor()
        cLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        cLabel.text = title
        cLabel.textAlignment = NSTextAlignment.Left
        return cLabel
    }
    
    func createButton(bFrame:CGRect, img:UIImage) -> UIButton {
        let btn: UIButton = UIButton.init(frame: bFrame)
        btn.setImage(img, forState: UIControlState.Normal)
        return btn
        
    }

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBtnAction() {
        
    }
    
    func commentAction() {/*
        let comentsView = CXCommentViewController.init()
        comentsView.headerTitle = self.productCategory.name
        comentsView.orgID = self.product.createdByID
        self.navigationController?.pushViewController(comentsView, animated: true)
 
 */
        

//        if SMUserDetails.sharedInstance.userID.characters.count > 0 {
//            let comentsView = CXCommentViewController.init()
//            comentsView.headerTitle = self.productCategory.name
//            self.navigationController?.pushViewController(comentsView, animated: true)
//        } else {
//            let signInView = CXSignInSignUpViewController.init()
//            signInView.orgID = self.product.createdByID
//            self.navigationController?.pushViewController(signInView, animated: true)
//        }
        
    }
    func shareAction() {
        let img: UIImage!
        
        let attachements : NSArray = CXDBSettings.getProductAttachments(self.product)
        if attachements.count > 0 {
            let attachment:NSDictionary = attachements.objectAtIndex(0) as! NSDictionary
            let prodImage: String = attachment.valueForKey("URL") as! String
            img = CXConstant.getImageFromUrlString(prodImage)
        } else {
            img = UIImage(named: "smlogo.png")
        }
        
        let infoText = self.parseProductDescription(self.getProductInfo(product, input: "Description"))
        
        let shareItems:Array = [infoText, img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    func likeAction(likeBtn:UIButton) {
        likeBtn.selected = !likeBtn.selected
        let jobId = self.getJobID("jobTypeId")
        if likeBtn.selected {
            let likeURL = "http://sillymonksapp.com:8081/Services/saveOrUpdateSocialActivity?orgId=3&userId="+""+"&jobId="+jobId+"&noOfLikes="+"1"
            SMSyncService.sharedInstance.startSyncProcessWithUrl(likeURL, completion: { (responseDict) in
            })
        } else {
            let likeURL = "http://sillymonksapp.com:8081/Services/saveOrUpdateSocialActivity?orgId=3&userId="+""+"&jobId="+jobId+"&noOfLikes="+"-1"
            SMSyncService.sharedInstance.startSyncProcessWithUrl(likeURL, completion: { (responseDict) in
              //  print(responseDict)
            })
        }
    }
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        if NSUserDefaults.standardUserDefaults().valueForKey("USER_ID") == nil{
            ratingView.rating = 0
            let signInView = CXSignInSignUpViewController.init()
            signInView.orgID = self.product.createdByID
            self.navigationController?.pushViewController(signInView, animated: true)
        }
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
       // ratingView.rating = 0
        self.ratingValue = NSString(format: "%.1f", self.floatRatingView.rating) as String
        self.avgRatingLabel.text = "Avg.user ratings:"+self.ratingValue+"/5"
        //print ("Rating is \(self.ratingValue)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.relatedArticles.count > 0 {
                return 2
            }
            return 1//self.detailItems.count
        }
        return CXDBSettings.getProductAttachments(self.product).count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let identifier = "DetailCell"
            
            var cell: CXRelatedArticleTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXRelatedArticleTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "CXRelatedArticleTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXRelatedArticleTableViewCell
            }
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
            if self.relatedArticles.count > 0 {
                if indexPath.row == 0 {
                    cell.headerLbl.text = "Related Articles"
                } else {
                    cell.headerLbl.text = self.productCategory.name
                }
            } else {
                cell.headerLbl.text = self.productCategory.name
            }
            return cell;
        } else {
            let identifier = "ImageCellID"
            
            var cell: CXImageDetailTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXImageDetailTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "CXImageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CXImageDetailTableViewCell
            }
            let attachment:NSDictionary = CXDBSettings.getProductAttachments(self.product).objectAtIndex(indexPath.row) as! NSDictionary
            cell.detailImageView.image = nil
            cell.activity.hidden = true
            let prodImage :String = attachment.valueForKey("URL") as! String
            
            cell.detailImageView.sd_setImageWithURL(NSURL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
            cell.descLabel.text = attachment.valueForKey("Image_Name") as? String
            return cell;
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return CXConstant.RELATED_ARTICLES_CELL_HEIGHT;
        }
        return CXConstant.DETAIL_IMAGE_CELL_HEIGHT
    }
    
    
    func heightForView(text:String,font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}


extension SMDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if self.relatedArticles.count > 0 {
            if collectionView.tag == 0 {
                return self.relatedArticles.count
            }
            return self.remainingProducts.count
        }
        
        return self.remainingProducts.count;
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "DetailCollectionViewCell"
        let cell: CXDetailCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?CXDetailCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "CXDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        let product: CX_Products
        if self.relatedArticles.count > 0 {
            if collectionView.tag == 0 {
                product = self.relatedArticles[indexPath.row] as! CX_Products
            } else {
                product = self.remainingProducts[indexPath.row] as! CX_Products
            }
        } else {
            product = self.remainingProducts[indexPath.row] as! CX_Products
        }
        self.customizeCollectionCell(cell, product: product)
        return cell
    }
    
    func customizeCollectionCell(cell: CXDetailCollectionViewCell,product:CX_Products) {
        let prodImage :String = CXDBSettings.getProductImage(product)
        cell.activity.hidden = true
        
        cell.detailImageView.sd_setImageWithURL(NSURL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
        cell.infoLabel.text = CXDBSettings.getProductInfo(product)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.relatedArticles.count > 0 {
            if collectionView.tag == 0 {
                self.product = self.relatedArticles[indexPath.row] as! CX_Products
            } else {
                self.product = self.remainingProducts[indexPath.row] as! CX_Products
            }
        } else {
            self.product = self.remainingProducts[indexPath.row] as! CX_Products
        }
        
        self.contentScrollView.removeFromSuperview()
        self.contentScrollView = nil
        self.activity.startActivity()
        self.customizeMainView()
        self.activity.stopActivity()
    }
}

extension UILabel {
    
    func requiredHeight(content: String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.text = content
        label.sizeToFit()
        
        return label.frame.height
    }

}

class InsetLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWithData: data)
    }
}


