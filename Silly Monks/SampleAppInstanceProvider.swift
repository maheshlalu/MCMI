//
//  SampleAppInstanceProvider.swift
//  Silly Monks
//
//  Created by Mahesh Y on 8/25/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
//import <;MoPubSDK>

private var _sharedInstance:SampleAppInstanceProvider! = SampleAppInstanceProvider()

class SampleAppInstanceProvider: NSObject {

    class var sharedInstance : SampleAppInstanceProvider {
        return _sharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    
    func buildMPAdViewWithAdUnitID(_ banerID:String,size:CGSize) -> MPAdView {
        
        let addView : MPAdView = MPAdView(adUnitId: banerID, size: size)
        return addView
        
    }
    
    func buildMPInterstitialAdControllerWithAdUnitID(_ banerID:String) -> MPInterstitialAdController{
        
        let interStitialAdCnt : MPInterstitialAdController = MPInterstitialAdController(forAdUnitId: banerID)
        return interStitialAdCnt
    }
    
}
