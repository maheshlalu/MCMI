//
//  SMSyncService.swift
//  Silly Monks
//
//  Created by Sarath on 23/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

private var _SingletonSharedInstance:SMSyncService! = SMSyncService()

public class SMSyncService: NSObject , NSURLSessionDelegate{
    class var sharedInstance : SMSyncService {
        return _SingletonSharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    public func startSyncProcessWithUrl(iUrl:String, completion:(responseDict:NSDictionary) -> Void) {
        print("Requested Url:\(iUrl)")
        let urlPath: String = iUrl
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        //let session = NSURLSession.sharedSession()
        
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = 30
        urlconfig.timeoutIntervalForResource = 60
        let session = NSURLSession(configuration: urlconfig, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithRequest(request1) { (resData:NSData?, response:NSURLResponse?, sError:NSError?) -> Void in
            var jsonData : NSDictionary = NSDictionary()
            if sError == nil && resData != nil && response != nil {
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(resData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                } catch {
                    print("Error in parsing\(sError?.description)")
                }
                
                completion(responseDict: jsonData)
            } else {
                print("Error in parsing\(sError?.description)")
            }
        }
        task.resume()
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
    
    
    
}
