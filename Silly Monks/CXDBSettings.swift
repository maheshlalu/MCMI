//
//  CXDBSettings.swift
//  Silly Monks
//
//  Created by Sarath on 28/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

protocol CXDBDelegate {
    func didFinishAllMallsSaving()
    func didFinishSingleMallSaving(mallId:String)
    func didFinishStoreSaving(mallId:String)
    func didFinishProductCategories()
    func didFinishProducts(proName: String)
    
}


private var _SingletonSharedInstance:CXDBSettings! = CXDBSettings()

class CXDBSettings: NSObject {
    
    
    var delegate: CXDBDelegate?
    
    private var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    class var sharedInstance : CXDBSettings {
        return _SingletonSharedInstance
    }

    private override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    func saveAllMallsInDB(allMallsResponseArray:NSArray) {
        //print("All malls to save DB\(allMallsResponseArray)")
        if self.getAllMallsInDB().count == 0 {
            
            MagicalRecord.saveWithBlock({ (localContext) in
                for allMallsResponse in allMallsResponseArray {
                    let enMalls = CX_AllMalls.MR_createInContext(localContext) as! CX_AllMalls
                    enMalls.category = allMallsResponse.valueForKey("category") as? String
                    enMalls.city = allMallsResponse.valueForKeyPath("address.city") as? String
                    enMalls.country = allMallsResponse.valueForKeyPath("address.country.name") as? String
                    enMalls.countryCode = allMallsResponse.valueForKeyPath("address.country.id") as? String
                    // allMallsResponse.valueForKeyPath("address.country.id") as? String
                    enMalls.coverImage = allMallsResponse.valueForKey("Cover_Image") as? String
                    enMalls.currencyType = allMallsResponse.valueForKey("currencyType") as? String
                    enMalls.defStoreID = allMallsResponse.valueForKey("defaultStoreId") as? String
                    enMalls.defStoreItemCode = allMallsResponse.valueForKey("defultStoreItemCode") as? String
                    enMalls.email = allMallsResponse.valueForKey("email") as? String
                    enMalls.fbPageLink = allMallsResponse.valueForKey("FacebookPageLink") as? String
                    enMalls.langCode = allMallsResponse.valueForKey("languageCode") as? String
                    enMalls.langName = allMallsResponse.valueForKey("languageName") as? String
                    enMalls.latitude = allMallsResponse.valueForKey("latitude") as? String
                    enMalls.longitude = allMallsResponse.valueForKey("longitude") as? String
                    enMalls.location = allMallsResponse.valueForKeyPath("address.location") as? String
                    enMalls.logo = allMallsResponse.valueForKey("logo") as? String
                    enMalls.mainCategory = allMallsResponse.valueForKey("mainCategory") as? String
                    enMalls.malDescription = allMallsResponse.valueForKey("description") as? String
                    enMalls.mid = CXConstant.resultString(allMallsResponse.valueForKey("id")!)
                    enMalls.mobile = allMallsResponse.valueForKey("mobile") as? String
                    enMalls.name = allMallsResponse.valueForKey("name") as? String
                    enMalls.offersCount = allMallsResponse.valueForKey("offersCount") as? String
                    enMalls.primaryColor = allMallsResponse.valueForKey("primaryColor") as? String
                    enMalls.promotionUrl = allMallsResponse.valueForKey("promotionUrl") as? String
                    enMalls.publicUrl = allMallsResponse.valueForKey("publicURL") as? String
                    enMalls.secondaryColor = allMallsResponse.valueForKey("secondaryColor") as? String
                    enMalls.state = allMallsResponse.valueForKeyPath("address.state") as? String
                    enMalls.storesCount = allMallsResponse.valueForKey("storesCount") as? String
                    enMalls.website = allMallsResponse.valueForKey("website") as? String
                }
            }) { (success, error) in
                if success == true {
                    if let delegate = self.delegate {
                        delegate.didFinishAllMallsSaving()
                    }
                } else {
                    print("Error\(error)")
                }
            }


            
            /*
            
            let enMalls = CX_AllMalls.MR_createEntity() as! CX_AllMalls
            enMalls.category = allMallsResponse.valueForKey("category") as? String
            enMalls.city = allMallsResponse.valueForKeyPath("address.city") as? String
            enMalls.country = allMallsResponse.valueForKeyPath("address.country.name") as? String
            enMalls.countryCode = allMallsResponse.valueForKeyPath("address.country.id") as? String
            // allMallsResponse.valueForKeyPath("address.country.id") as? String
            enMalls.coverImage = allMallsResponse.valueForKey("Cover_Image") as? String
            enMalls.currencyType = allMallsResponse.valueForKey("currencyType") as? String
            enMalls.defStoreID = allMallsResponse.valueForKey("defaultStoreId") as? String
            enMalls.defStoreItemCode = allMallsResponse.valueForKey("defultStoreItemCode") as? String
            enMalls.email = allMallsResponse.valueForKey("email") as? String
            enMalls.fbPageLink = allMallsResponse.valueForKey("FacebookPageLink") as? String
            enMalls.langCode = allMallsResponse.valueForKey("languageCode") as? String
            enMalls.langName = allMallsResponse.valueForKey("languageName") as? String
            enMalls.latitude = allMallsResponse.valueForKey("latitude") as? String
            enMalls.longitude = allMallsResponse.valueForKey("longitude") as? String
            enMalls.location = allMallsResponse.valueForKeyPath("address.location") as? String
            enMalls.logo = allMallsResponse.valueForKey("logo") as? String
            enMalls.mainCategory = allMallsResponse.valueForKey("mainCategory") as? String
            enMalls.malDescription = allMallsResponse.valueForKey("description") as? String
            enMalls.mid = CXConstant.resultString(allMallsResponse.valueForKey("id")!)
            enMalls.mobile = allMallsResponse.valueForKey("mobile") as? String
            enMalls.name = allMallsResponse.valueForKey("name") as? String
            enMalls.offersCount = allMallsResponse.valueForKey("offersCount") as? String
            enMalls.primaryColor = allMallsResponse.valueForKey("primaryColor") as? String
            enMalls.promotionUrl = allMallsResponse.valueForKey("promotionUrl") as? String
            enMalls.publicUrl = allMallsResponse.valueForKey("publicURL") as? String
            enMalls.secondaryColor = allMallsResponse.valueForKey("secondaryColor") as? String
            enMalls.state = allMallsResponse.valueForKeyPath("address.state") as? String
            enMalls.storesCount = allMallsResponse.valueForKey("storesCount") as? String
            enMalls.website = allMallsResponse.valueForKey("website") as? String
            self.saveContext()

            */
            
            
        }
    }
    
    func saveSingleMallInDB(resDict:NSDictionary) {
       // print ("Single Mall Response \(resDict)")
        
        MagicalRecord.saveWithBlock({ (localContext) in
            let enSMall = CX_SingleMall.MR_createInContext(localContext) as! CX_SingleMall
            enSMall.mallID = CXConstant.resultString(resDict.valueForKey("id")!)
            enSMall.coverImage = resDict.valueForKey("Cover_Image") as? String
            enSMall.mallDesc = resDict.valueForKey("description") as? String
            enSMall.name = resDict.valueForKey("name") as? String
            enSMall.email = resDict.valueForKey("email") as? String
            enSMall.mobile = resDict.valueForKey("mobile") as? String
        }) { (success, error) in
            if success == true {
                if let delegate = self.delegate {
                     delegate.didFinishSingleMallSaving(CXConstant.resultString(resDict.valueForKey("id")!))
                }
            } else {
                print("Error\(error)")
            }
        }

        
        
//        MagicalRecord.saveInBackgroundWithBlock({ (localContext) in
//            let enSMall = CX_SingleMall.MR_createInContext(localContext) as! CX_SingleMall
//            enSMall.mallID = CXConstant.resultString(resDict.valueForKey("id")!)
//            enSMall.coverImage = resDict.valueForKey("Cover_Image") as? String
//            enSMall.mallDesc = resDict.valueForKey("description") as? String
//            enSMall.name = resDict.valueForKey("name") as? String
//            enSMall.email = resDict.valueForKey("email") as? String
//            enSMall.mobile = resDict.valueForKey("mobile") as? String
//            }, completion: {
//                if let delegate = self.delegate {
//                    delegate.didFinishSingleMallSaving(CXConstant.resultString(resDict.valueForKey("id")!))
//                }
//        })
        
        /*
        
        let enSMall  = CX_SingleMall.MR_createEntity() as! CX_SingleMall
        
        enSMall.mallID = CXConstant.resultString(resDict.valueForKey("id")!)
        enSMall.coverImage = resDict.valueForKey("Cover_Image") as? String
        enSMall.mallDesc = resDict.valueForKey("description") as? String
        enSMall.name = resDict.valueForKey("name") as? String
        enSMall.email = resDict.valueForKey("email") as? String
        enSMall.mobile = resDict.valueForKey("mobile") as? String
        self.saveContext()
 
        */
    }
    
    func saveStoreInDB(resDict:NSDictionary) {
        //        let managedObjContext = self.appDelegate.managedObjectContext
        //        let storeEn = NSEntityDescription.entityForName("CX_Stores", inManagedObjectContext: managedObjContext)
        //        let enStore = CX_Stores(entity: storeEn!,insertIntoManagedObjectContext: managedObjContext)
        
        /*
         let enStore = CX_Stores.MR_createEntity() as! CX_Stores
         
         enStore.sID = CXConstant.resultString(resDict.valueForKey("id")!)
         enStore.name = resDict.valueForKey("Name") as? String
         enStore.type = resDict.valueForKey("Type") as? String
         let jsonString = CXConstant.sharedInstance.convertDictionayToString(resDict)
         enStore.json = jsonString as String
         enStore.createdById = CXConstant.resultString(resDict.valueForKey("createdById")!)
         enStore.itemCode = resDict.valueForKey("ItemCode") as? String
         enStore.mallID = CXConstant.resultString(resDict.valueForKey("createdById")!)
         
         self.saveContext()
         */
        
        MagicalRecord.saveWithBlock({ (localContext) in
            let enStore = CX_Stores.MR_createInContext(localContext) as! CX_Stores
            
            enStore.sID = CXConstant.resultString(resDict.valueForKey("id")!)
            enStore.name = resDict.valueForKey("Name") as? String
            enStore.type = resDict.valueForKey("Type") as? String
            let jsonString = CXConstant.sharedInstance.convertDictionayToString(resDict)
            enStore.json = jsonString as String
            enStore.createdById = CXConstant.resultString(resDict.valueForKey("createdById")!)
            enStore.itemCode = resDict.valueForKey("ItemCode") as? String
            enStore.mallID = CXConstant.resultString(resDict.valueForKey("createdById")!)
        }) { (success, error) in
            if success == true {
                if let delegate = self.delegate {
                    delegate.didFinishStoreSaving(CXConstant.resultString(resDict.valueForKey("createdById")!))
                }
            } else {
                print("Error\(error)")
            }
        }

        
        
        
        
//        MagicalRecord.saveInBackgroundWithBlock({ (localContext) in
//            let enStore = CX_Stores.MR_createInContext(localContext) as! CX_Stores
//            
//            enStore.sID = CXConstant.resultString(resDict.valueForKey("id")!)
//            enStore.name = resDict.valueForKey("Name") as? String
//            enStore.type = resDict.valueForKey("Type") as? String
//            let jsonString = CXConstant.sharedInstance.convertDictionayToString(resDict)
//            enStore.json = jsonString as String
//            enStore.createdById = CXConstant.resultString(resDict.valueForKey("createdById")!)
//            enStore.itemCode = resDict.valueForKey("ItemCode") as? String
//            enStore.mallID = CXConstant.resultString(resDict.valueForKey("createdById")!)
//            }, completion: {
//                if let delegate = self.delegate {
//                delegate.didFinishStoreSaving(CXConstant.resultString(resDict.valueForKey("createdById")!))
//                }
//        })
        
        
        
        
        //        do {
        //            try managedObjContext.save()
        //        } catch let error as NSError  {
        //            print("Could not save \(error), \(error.userInfo)")
        //        }
        
    }


    
    func saveProductCategoriesInDB(productCategories:NSArray,catID:String) {
        let predicate:NSPredicate = NSPredicate(format: "createdById = %@", catID)
        
        if CX_Product_Category.MR_findAllWithPredicate(predicate).count == 0 {
            
            MagicalRecord.saveWithBlock({ (localContext) in
                for productCategory in productCategories {
                    let enProCat = CX_Product_Category.MR_createInContext(localContext) as! CX_Product_Category
                    
                    //CX_Product_Category.MR_createEntity() as! CX_Product_Category
                    let createByID : String = CXConstant.resultString(productCategory.valueForKey("createdById")!)
                    enProCat.pid = CXConstant.resultString(productCategory.valueForKey("id")!)
                    enProCat.categoryMall = productCategory.valueForKey("Category_Mall") as? String
                    enProCat.itemCode = productCategory.valueForKey("ItemCode") as? String
                    enProCat.createdByFullName = productCategory.valueForKey("createdByFullName") as? String
                    enProCat.createdById = createByID
                    enProCat.mallID = createByID
                    enProCat.publicUrl = productCategory.valueForKey("publicURL") as? String
                    enProCat.name = productCategory.valueForKey("Name") as? String
                    enProCat.productDescription = productCategory.valueForKey("Description") as? String
                    enProCat.storeID = productCategory.valueForKey("storeId") as? String
                    enProCat.currentJobStatus = productCategory.valueForKey("Current_Job_Status") as? String
                    enProCat.packageName = productCategory.valueForKey("PackageName") as? String
                    enProCat.createdOn = productCategory.valueForKey("createdOn") as? String
                    enProCat.jobTypeID = CXConstant.resultString(productCategory.valueForKey("jobTypeId")!)
                    // productCategory.valueForKey("jobTypeId") as? String
                    enProCat.jobTypeName = productCategory.valueForKey("jobTypeName") as? String
                    enProCat.overallRating = productCategory.valueForKey("overallRating") as? String
                    enProCat.totalReviews = productCategory.valueForKey("totalReviews") as? String
                }
            }) { (success, error) in
                if success == true {
                    if let delegate = self.delegate {
                        delegate.didFinishProductCategories()
                    }
                }else {
                    print("Error\(error)")
                }
            }

            
            
            
//            MagicalRecord.saveInBackgroundWithBlock({ (localContext) in
//                for productCategory in productCategories {
//                    let enProCat = CX_Product_Category.MR_createInContext(localContext) as! CX_Product_Category
//                        
//                        //CX_Product_Category.MR_createEntity() as! CX_Product_Category
//                    let createByID : String = CXConstant.resultString(productCategory.valueForKey("createdById")!)
//                    enProCat.pid = CXConstant.resultString(productCategory.valueForKey("id")!)
//                    enProCat.categoryMall = productCategory.valueForKey("Category_Mall") as? String
//                    enProCat.itemCode = productCategory.valueForKey("ItemCode") as? String
//                    enProCat.createdByFullName = productCategory.valueForKey("createdByFullName") as? String
//                    enProCat.createdById = createByID
//                    enProCat.mallID = createByID
//                    enProCat.publicUrl = productCategory.valueForKey("publicURL") as? String
//                    enProCat.name = productCategory.valueForKey("Name") as? String
//                    enProCat.productDescription = productCategory.valueForKey("Description") as? String
//                    enProCat.storeID = productCategory.valueForKey("storeId") as? String
//                    enProCat.currentJobStatus = productCategory.valueForKey("Current_Job_Status") as? String
//                    enProCat.packageName = productCategory.valueForKey("PackageName") as? String
//                    enProCat.createdOn = productCategory.valueForKey("createdOn") as? String
//                    enProCat.jobTypeID = CXConstant.resultString(productCategory.valueForKey("jobTypeId")!)
//                    // productCategory.valueForKey("jobTypeId") as? String
//                    enProCat.jobTypeName = productCategory.valueForKey("jobTypeName") as? String
//                    enProCat.overallRating = productCategory.valueForKey("overallRating") as? String
//                    enProCat.totalReviews = productCategory.valueForKey("totalReviews") as? String
//                }
//                }, completion: {
//                    if let delegate = self.delegate {
//                        delegate.didFinishProductCategories()
//                    }
//            })
//
            
            
            
            
            
            /*
             
             let enProCat = CX_Product_Category.MR_createEntity() as! CX_Product_Category
             let createByID : String = CXConstant.resultString(productCategory.valueForKey("createdById")!)
             enProCat.pid = CXConstant.resultString(productCategory.valueForKey("id")!)
             enProCat.categoryMall = productCategory.valueForKey("Category_Mall") as? String
             enProCat.itemCode = productCategory.valueForKey("ItemCode") as? String
             enProCat.createdByFullName = productCategory.valueForKey("createdByFullName") as? String
             enProCat.createdById = createByID
             enProCat.mallID = createByID
             enProCat.publicUrl = productCategory.valueForKey("publicURL") as? String
             enProCat.name = productCategory.valueForKey("Name") as? String
             enProCat.productDescription = productCategory.valueForKey("Description") as? String
             enProCat.storeID = productCategory.valueForKey("storeId") as? String
             enProCat.currentJobStatus = productCategory.valueForKey("Current_Job_Status") as? String
             enProCat.packageName = productCategory.valueForKey("PackageName") as? String
             enProCat.createdOn = productCategory.valueForKey("createdOn") as? String
             enProCat.jobTypeID = CXConstant.resultString(productCategory.valueForKey("jobTypeId")!)
             // productCategory.valueForKey("jobTypeId") as? String
             enProCat.jobTypeName = productCategory.valueForKey("jobTypeName") as? String
             enProCat.overallRating = productCategory.valueForKey("overallRating") as? String
             enProCat.totalReviews = productCategory.valueForKey("totalReviews") as? String
             self.saveContext()

             
             */
            
        }
    }
    
    
    //func saveProductsInDB(products:NSArray,productCategory:CX_Product_Category) {
    func saveProductsInDB(products:NSArray,productCatName:String) {
        MagicalRecord.saveWithBlock({ (localContext) in
            for prod in products {
                let enProduct = CX_Products.MR_createInContext(localContext) as! CX_Products
                // CX_Products.MR_createEntity() as! CX_Products
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct.createdByID = createByID
                enProduct.mallID = createByID
                enProduct.itemCode = prod.valueForKey("ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct.json = jsonString as String
                //print("Parsing \(enProduct.json)")
                enProduct.name = prod.valueForKey("Name") as? String
                enProduct.pID = CXConstant.resultString(prod.valueForKey("jobTypeId")!)
                //prod.valueForKey("jobTypeId") as? String
                enProduct.type = prod.valueForKey("jobTypeName") as? String
                enProduct.mallID = createByID
                enProduct.tagValue = prod.valueForKey("Tag") as? String
                // self.saveContext()
            }

            }) { (success, error) in
                if success == true {
                    if let delegate = self.delegate {
                        delegate.didFinishProducts(productCatName)
                    }
                } else {
                    print("Error\(error)")
                }
        }
        
        
        
        
//        MagicalRecord.saveInBackgroundWithBlock({ (localContext) in
//            for prod in products {
//                let enProduct = CX_Products.MR_createInContext(localContext) as! CX_Products
//                   // CX_Products.MR_createEntity() as! CX_Products
//                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
//                enProduct.createdByID = createByID
//                enProduct.mallID = createByID
//                enProduct.itemCode = prod.valueForKey("ItemCode") as? String
//                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
//                enProduct.json = jsonString as String
//                //print("Parsing \(enProduct.json)")
//                enProduct.name = prod.valueForKey("Name") as? String
//                enProduct.pID = CXConstant.resultString(prod.valueForKey("jobTypeId")!)
//                //prod.valueForKey("jobTypeId") as? String
//                enProduct.type = prod.valueForKey("jobTypeName") as? String
//                enProduct.mallID = createByID
//                enProduct.tagValue = prod.valueForKey("Tag") as? String
//               // self.saveContext()
//            }
//            }, completion: {
//                if let delegate = self.delegate {
//                    delegate.didFinishProducts(productCatName)
//                }
//        })
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
       //NSManagedObjectContext.MR_contextForCurrentThread().MR_saveToPersistentStoreAndWait()
        //NSManagedObjectContext.MR_defaultContext().MR_saveNestedContexts()
    }
        
    
   
    
   static func getAllMallIDs() -> NSMutableArray {
        let mallIDs = NSMutableArray()
        for mall in CX_AllMalls.MR_findAll() {
            let aMall = mall as! CX_AllMalls
             mallIDs.addObject(aMall.mid!)
        }
        return mallIDs
    }
    
    static func getProductNames() -> NSMutableArray {
        let proNames = NSMutableArray()
        for prod in CX_Product_Category.MR_findAll() {
            let product = prod as! CX_Product_Category
            proNames.addObject(product.name!)
        }
        return proNames
    }
    
    
    func getAllMallsInDB() -> NSArray{
//        let managedContext = self.appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "CX_AllMalls")
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//            return results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
        
        return CX_AllMalls.MR_findAllWithPredicate(nil)!
        
        
//        let items = CX_AllMalls.MR_findAll as! NSArray
//        
//        //let itemsArray = items as? NSArray
//        
   //     return itemsArray!
        
        //CX_AllMalls.findAll
        
        //return NSArray()
    }
    
    func getAllSingleMallsInDB() -> NSArray{
        
        return CX_SingleMall.MR_findAllWithPredicate(nil)
        
//        let managedContext = self.appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "CX_SingleMall")
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//            return results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return NSArray()
    }

    
    func getSingleMalls(mallID:String) -> NSArray {
        //let small:CX_SingleMall!
        let predicate: NSPredicate = NSPredicate(format: "mallID == %@",mallID)
        let singleMalls :NSArray = CX_SingleMall.MR_findAllWithPredicate(predicate)
            //CXDBSettings.sharedInstance.getRequiredItemsFromDB("CX_SingleMall", predicate: predicate)
        return singleMalls
//        if singleMalls.count  > 0 {
//            small = singleMalls[0] as! CX_SingleMall
//            return small
//        } 
        
        //  singleMalls.lastObject as! CX_SingleMall
    }
    
    
    func getRequiredItemsFromDB(entity:String,predicate:NSPredicate) -> NSArray {
//        let managedContext = self.appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: entity)
//        fetchRequest.predicate = predicate
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//            return results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
        return NSArray()
    }
    
    
    // Products
    
    static func getProductsWithCategory(proCategory:CX_Product_Category) -> NSMutableArray {
        let predicate: NSPredicate = NSPredicate(format: "type == %@ && mallID == %@",proCategory.name!,proCategory.mallID!)
        let productCatList :NSArray = CX_Products.MR_findAllWithPredicate(predicate)
        
           // CXDBSettings.sharedInstance.getRequiredItemsFromDB("CX_Products", predicate: predicate)
        let proKatList : NSMutableArray = NSMutableArray(array: productCatList)
        return proKatList
    }
    
    static func getRelatedProductsWithCategory(tagName:String, mallID: String) -> NSMutableArray {
        var relProKatList = NSMutableArray()
        if tagName != "q:Tags" {
            let predicate: NSPredicate = NSPredicate(format: "tagValue == %@ && mallID == %@",tagName,mallID)
            let productCatList :NSArray = CX_Products.MR_findAllWithPredicate(predicate)
                //CXDBSettings.sharedInstance.getRequiredItemsFromDB("CX_Products", predicate: predicate)
            relProKatList = NSMutableArray(array: productCatList)
            return relProKatList
        }
        return relProKatList
    }
    
    static func getProductImage(produkt:CX_Products) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(produkt.json!))
       // print("Json is \(json)")
        let imgUrl : String = json.valueForKey("Image_URL") as! String
        return imgUrl
    }
    
    static func getProductInfo(produkt:CX_Products) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(produkt.json!))
       // print("Json is \(json)")
        let info : String = json.valueForKey("Name") as! String
        return info
    }
    
    static func getProductAttachments(produkt:CX_Products) -> NSArray {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(produkt.json!))
        let attachements: NSArray = json.valueForKey("Attachments") as! NSArray
        return attachements
    }

    // Stores
    
    static func getStoreJSON(mallID: String) -> NSDictionary {
        let predicate: NSPredicate = NSPredicate(format: "mallID == %@",mallID)
        let stores :NSArray = CX_Stores.MR_findAllWithPredicate(predicate)
            //CXDBSettings.sharedInstance.getRequiredItemsFromDB("CX_Stores", predicate: predicate)
        if stores.count > 0 {
            let store : CX_Stores = stores.lastObject as! CX_Stores
            let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(store.json!))
            //print("Store JSON \(json)")
            return json;
        }
        return NSDictionary()
    }
    
    static func getStoreInfo(json: NSDictionary) -> NSMutableArray {
        if let attachments = json.valueForKey("Attachments") as? NSArray {
            let reqItems = attachments.filter({
                $0["isCoverImage"] as! String == "true"
            })
            //print("Required items \(reqItems)")
            
            return NSMutableArray(array: reqItems)
        }
        return NSMutableArray()
       // let attachments: NSArray = json.valueForKey("Attachments") as! NSArray
       
    }
    
    static func getGalleryItems(json:NSDictionary,albumName:String) -> NSMutableArray {
        let attachments: NSArray = json.valueForKey("Attachments") as! NSArray
        let reqItems = attachments.filter({
            $0["albumName"] as! String == albumName
        })
       // print("Required items \(reqItems)")
        
        let rqItems : NSMutableArray = NSMutableArray(array: reqItems)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "Id", ascending: true)
        let sortedResults: NSArray = rqItems.sortedArrayUsingDescriptors([descriptor])
        
        return  NSMutableArray(array: sortedResults)
    }
    
    
    
    
    
//    func getAllProductCategories(predicate:NSPredicate) -> NSArray {
//        let managedContext = self.appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "CX_Product_Category")
//        fetchRequest.predicate = predicate
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//            return results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return NSArray()
//    }
    
}



extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
