//
//  CXconstant.swift
//  SampleSwiftTable
//
//  Created by Rama kuppa on 27/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit



var IPHONE_4S = "iPhone_4s"
var IPHONE_5S = "iPhone_5s"
var IPHONE_6 = "iPhone_6"
var IPHONE_6PLUS = "iPhone_6Plus"
var NOT_IPHONE = "Not_iPhone"

private var _SingletonSharedInstance:CXConstant! = CXConstant()




class CXConstant: NSObject {
    
    class var sharedInstance : CXConstant {
        return _SingletonSharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    
    static let homeScreenTableViewHeight : CGFloat = 225
    static let tableViewHeigh : CGFloat = 275
    
    static let someString : String = "Some Text" // struct
    static let collectiViewCellSize :  CGSize = CGSize(width: UIScreen.mainScreen().bounds.size.width-20,height: tableViewHeigh)
    
    static let collectionViewFrame : CGRect = CGRectMake(8, 30, UIScreen.mainScreen().bounds.size.width-20, tableViewHeigh-50)
    
    static let HOME_COLLECTION_FRAME : CGRect = CGRectMake(10, 20, UIScreen.mainScreen().bounds.size.width-20, tableViewHeigh-50)
    
    static let titleLabelColor : UIColor = UIColor(red: 240.0/255.0, green: 40.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    
    static let collectionCellborderColor : UIColor = UIColor(red: 191.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1.0)
    
    
    static let DetailTableView_Width = UIScreen.mainScreen().bounds.width-20
    // static let DetailCollectionCellSize :  CGSize = CGSize(width: 180,height: tableViewHeigh-50)
    static let DetailCollectionCellSize :  CGSize = CGSize(width: 135,height: tableViewHeigh-80)
    
    //135, 200
    
    //CGSize(width: UIScreen.mainScreen().bounds.size.width-20,height: tableViewHeigh-50)
    
    ///
    
    static let DetailCollectionViewFrame : CGRect = CGRectMake(4, 10, DetailTableView_Width-8, tableViewHeigh-50)
    
    
    
    static let DETAIL_IMAGE_TABLE_WIDTH:CGFloat = UIScreen.mainScreen().bounds.width-20
    static let DETAIL_IMAGE_CELL_HEIGHT:CGFloat = DETAIL_IMAGE_TABLE_WIDTH/2
    
    static let RELATED_ARTICLES_CELL_HEIGHT:CGFloat = 280
    
    
    static let PRODUCT_CELL_HEIGHT:CGFloat = PRODUCT_IMAGE_HEIGHT+55
    
    static let PRODUCT_IMAGE_HEIGHT:CGFloat = (UIScreen.mainScreen().bounds.width - 8)/2
    
    
    
    
    //CGRectMake(8, 30, UIScreen.mainScreen().bounds.size.width-20, tableViewHeigh-50)
    
    //
    
    static let HOME_BANNAER = "/133516651/AppHome"
    static let TOLLYWOOD_BANNAER = "/133516651/AppTollyBanner"
    static let BOLLYWOOD_BANNAER = "/133516651/AppBollyBanner"
    static let HOLLYWOOD_BANNAER = "/133516651/AppHollyBanner"
    static let KOLLYWOOD_BANNAER = "/133516651/AppKollyBanner"
    static let MOLLYWOOD_BANNAER = "/133516651/AppMollyBanner"
    static let SANDALWOOD_BANNAER = "/133516651/AppSandalBanner"
    
    
    // BrightCove Directives
    
    //   static let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM2oOQVwTaK5uvR6L0gtvjmrZCT88aVOc6a3n2Mw7BBVAImkiPF27Xr4lDTnN1D1qL4motncIJf55cdpQB6oR147RsXjI4PecVoyvWgQ_Or7fNyT5Nglba1hUpt"
    
    static let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM2oOQVwTaK5uvR6L0gtvjmrZCT88aVOc6a3n2Mw7BBVAImkiPF27Xr4lDTnN1D1qL4motncIJf55cdpQB6oR147RsXjI4PecVoyvWgQ_Or7fNyT5Nglba1hUpt-LRW23BinBju-"
    
    // static let kViewControllerAccountID = "4652941494001"
    
    
    static let kViewControllerAccountID = "4652941494001"//4652941494001
    
    //let kViewControllerVideoID = "3987127390001"
    
    
    
    // Sevices URLs
    
    static let ALL_MALLS_URL = "http://52.74.102.199:8081/services/getmasters?type=allMalls"
    static let SINGLE_MALL_URL = "http://m.sillymonks.com:8081/Services/getMasters?type=singleMall&mallId=" //3
    static let STORE_URL = "http://52.74.102.199:8081/services/getmasters?type=stores&mallId="
    static let NATIVEADD_UNITI_ID = "4af8f892da924673aa0d9db92b49cc10"
    
    
    static let PRODUCT_CATEGORY_URL = "http://52.74.102.199:8081/services/getmasters?type=ProductCategories&mallId="
    
    
    static func restrictRotation(isRestricted: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.restrictRotation = isRestricted
        
    }
    
    
    
    
    
    func productURL(productType:String, mallId: String) -> String {
        let escapedString = productType.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let reqString = "http://52.74.102.199:8081/services/getmasters?type="+escapedString!+"&mallId="+mallId
        return reqString
    }
    
    func checkProductCountURL(productType:String, mallId: String) -> String {
        let escapedString = productType.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let reqString = "http://sillymonksapp.com:8081/Services/categoryJobsCount?"+"mallId="+mallId+"&type="+escapedString!
        //http://sillymonksapp.com:8081/Services/categoryJobsCount?mallId=3&type=movies
        //type="+escapedString!
        return reqString
    }
    
    static func resultString(input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }
    
    func convertDictionayToString(dictionary:NSDictionary) -> NSString {
        var dataString: String!
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            //print("JSON data is \(jsonData)")
            dataString = String(data: jsonData, encoding: NSUTF8StringEncoding)
            //print("Converted JSON string is \(dataString)")
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            dataString = ""
            print(error)
        }
        return dataString
    }
    
    func convertStringToDictionary(string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
            //print("Error in parsing")
        }
        return jsonDict
    }
    
    static func getImageFromUrlString(imgUrlString:String) ->UIImage {
        
        if let imgUrl = NSURL(string:imgUrlString) {
            if let cImageData = NSData(contentsOfURL: imgUrl) {
                let cImage = UIImage(data: cImageData)
                if cImage != nil {
                    return cImage!
                }
            }
        }
        return UIImage(named:"smlogo.png")!
        
        //        let imgUrl = NSURL(string: imgUrlString)
        //        let cImageData = NSData(contentsOfURL: imgUrl!)
        //        let cImage = UIImage(data: cImageData!)
        //        if cImage != nil {
        //            return cImage!
        //        }
        //        return UIImage(named:"smnocover.png")!
    }
    
    
    static func getSideMenuItems() -> NSMutableArray {
        let menuItemsArray = NSMutableArray()
        for menuItem in (CXDBSettings.sharedInstance.getAllMallsInDB().valueForKeyPath("name") as? NSArray)!{
            let category = menuItem.stringByReplacingOccurrencesOfString("Silly Monks", withString: "")
            menuItemsArray.addObject((category.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())))
        }
        return menuItemsArray
    }
    
    static func currentDeviceScreen() -> NSString {
        let bounds = UIScreen.mainScreen().bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            return IPHONE_4S
        case 568.0:
            print("iPhone 5")
            return IPHONE_5S
        case 667.0:
            print("iPhone 6")
            return IPHONE_6
        case 736.0:
            print("iPhone 6+")
            return IPHONE_6PLUS
            
        default:
            print("not an iPhone")
            return NOT_IPHONE
        }
    }
    
    
    static func saveDataInUserDefaults(userDetails: SMUserDetails) {
        NSUserDefaults.standardUserDefaults().setObject(userDetails.userFirstName, forKey: "FIRST_NAME")
        NSUserDefaults.standardUserDefaults().setObject(userDetails.userLastName, forKey: "LAST_NAME")
        NSUserDefaults.standardUserDefaults().setObject(userDetails.emailAddress, forKey: "EMAIL")
        NSUserDefaults.standardUserDefaults().setObject(userDetails.userID, forKey: "USER_ID")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}

extension String {
    
    func urlEncoding() -> String {
        let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        //print("escapedString: \(escapedString)")
        return escapedString!
    }
}
