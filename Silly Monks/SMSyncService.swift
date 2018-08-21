//
//  SMSyncService.swift
//  Silly Monks
//
//  Created by Sarath on 23/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

private var _SingletonSharedInstance:SMSyncService! = SMSyncService()

open class SMSyncService: NSObject , URLSessionDelegate{
    class var sharedInstance : SMSyncService {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    open func startSyncProcessWithUrl(_ iUrl:String, completion:@escaping (_ responseDict:NSDictionary) -> Void) {
       // print("Requested Url:\(iUrl)")
        let urlPath: String = iUrl
        let url: URL = URL(string: urlPath)!
        let request1: URLRequest = URLRequest(url: url)
        //let session = NSURLSession.sharedSession()
        
        URLSession.shared.dataTask(with: request1) { (resData, response, sError) in
            var jsonData : NSDictionary = NSDictionary()
            if sError == nil && resData != nil && response != nil {
                do {
                    jsonData = try JSONSerialization.jsonObject(with: resData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                } catch {
                    //print("Error in parsing\(sError?.description)")
                }
                
                completion(jsonData)
            } else {
                //print("Error in parsing\(sError?.description)")
            }
        }.resume()
    }
        
//    public func startSyncWithUrl(cUrl:String) {
//        let urlPath: String = cUrl
//        let url: NSURL = NSURL(string: urlPath)!
//        let request1: NSURLRequest = NSURLRequest(URL: url)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request1) { (resData:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
//            var jsonData : NSDictionary = NSDictionary()
//            do {
//                jsonData = try NSJSONSerialization.JSONObjectWithData(resData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
//            } catch {
//                print("Error in parsing")
//            }
//            print("All Malls \(jsonData)")
//        }
//        task.resume()
//    }
    
    
    open func checkProductCategoryCountSyncProcessWithUrl(_ iUrl:String, completion:@escaping (_ responseDict:NSMutableArray) -> Void) {
       // print("Requested Url:\(iUrl)")
        let urlPath: String = iUrl
        let url: URL = URL(string: urlPath)!
        let request1: URLRequest = URLRequest(url: url)
        //let session = NSURLSession.sharedSession()
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 30
        urlconfig.timeoutIntervalForResource = 60
        let session = URLSession(configuration: urlconfig, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request1, completionHandler: { (resData:Data?, response:URLResponse?, sError:NSError?) -> Void in
            var jsonData : NSMutableArray = NSMutableArray()
            if sError == nil && resData != nil && response != nil {
                do {
                    jsonData = try JSONSerialization.jsonObject(with: resData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSMutableArray
                } catch {
                    print("Error in parsing\(sError?.description)")
                }
                
                completion(jsonData)
            } else {
                print("Error in parsing\(sError?.description)")
            }
        } as! (Data?, URLResponse?, Error?) -> Void) 
        task.resume()
    }

    
}
