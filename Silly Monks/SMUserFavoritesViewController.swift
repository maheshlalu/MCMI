//
//  UserFavoritesViewController.swift
//  SMSample
//
//  Created by CX_One on 7/28/16.
//  Copyright © 2016 CX_One. All rights reserved.
//

import UIKit
import SDWebImage

class UserFavoritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userFavoritesArray = NSMutableArray()
    var userFavoritesCategories = NSMutableArray()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.userFavoritesArray = CXDBSettings.sharedInstance.getTheUserFavouritesFromProducts("1")
        
        favoritesTableView.delegate = self;
        favoritesTableView.dataSource = self;
        favoritesTableView.separatorStyle = .None

    }
    func parseProductDescription(desc:String) -> String {
        let normalString : String = desc.html2String
        return normalString
    }
    func getProductInfo(produkt:CX_Products, input:String) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(produkt.json!))
        let info : String = json.valueForKey(input) as! String
        return info
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userFavoritesArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 15.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let identifier = "Custom"
        
        var cell: SMFavoritesCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SMFavoritesCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
        }
        let  product: CX_Products = self.userFavoritesArray[indexPath.section] as! CX_Products
        cell.favouritesTitleLabel.text = product.name
        let prodImage :String = CXDBSettings.getProductImage(product)
        cell.favouritesImageview.sd_setImageWithURL(NSURL(string:prodImage)!, placeholderImage: UIImage(named: "smlogo.png"), options:SDWebImageOptions.RefreshCached)
        cell.favouritesDetailTextView.text = self.parseProductDescription(self.getProductInfo(product, input: "Description"))
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let  product: CX_Products = self.userFavoritesArray[indexPath.section] as! CX_Products
            
            CXDBSettings.sharedInstance.userAddedToFavouriteList(product, isAddedToFavourite: false)
            self.favoritesTableView.beginUpdates()
            self.userFavoritesArray.removeObjectAtIndex(indexPath.section) // also remove an array object if exists.
            self.favoritesTableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Left)
            self.favoritesTableView.endUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let prodCategory:CX_Product_Category = self.userFavoritesCategories[indexPath.section] as! CX_Product_Category
//        let product: CX_Products = self.userFavoritesArray[indexPath.section] as! CX_Products
//        let detailView = ViewPagerCntl.init()
//        detailView.product = product
//        detailView.itemIndex = indexPath.section
//        //detailView.productCategory = prodCategory
//        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title: "Silly Monks", message:message, preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
               
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
