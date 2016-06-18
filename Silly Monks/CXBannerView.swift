//
//  CXBannerView.swift
//  Silly Monks
//
//  Created by Sarath on 25/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CXBannerView: DFPBannerView {
    
    init (bFrame : CGRect, unitID : String, delegate:UIViewController) {
        super.init(frame : bFrame)
        self.backgroundColor = UIColor.blackColor()
        self.adUnitID = unitID
        self.rootViewController = delegate
        self.loadRequest(DFPRequest())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
