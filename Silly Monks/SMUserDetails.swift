//
//  SMUserDetails.swift
//  Silly Monks
//
//  Created by Sarath on 21/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

private var _SingletonSharedInstance:SMUserDetails! = SMUserDetails()

class SMUserDetails: NSObject {
    
    var userFirstName: String!
    var userLastName: String!
    var mobileNumber:String!
    var emailAddress:String!
    var userID:String!
    var macID:String!
    var macJobID:String!
    var orgID: String!
    var gender:String!
    
    class var sharedInstance : SMUserDetails {
        return _SingletonSharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }

    

}
