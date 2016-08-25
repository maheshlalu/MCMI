//
//  SampleAppInstanceProvider.swift
//  Silly Monks
//
//  Created by Mahesh Y on 8/25/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import mopub_ios_sdk

private var _sharedInstance:SampleAppInstanceProvider! = SampleAppInstanceProvider()

class SampleAppInstanceProvider: NSObject {

    class var sharedInstance : SampleAppInstanceProvider {
        return _sharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    
    func buildMPAdViewWithAdUnitID(banerID:String,size:CGSize) -> MPAdView {
        
        let addView : MPAdView = MPAdView(adUnitId: banerID, size: size)
        return addView
        
    }
    
    func buildMPInterstitialAdControllerWithAdUnitID(banerID:String) -> MPInterstitialAdController{
        
        let interStitialAdCnt : MPInterstitialAdController = MPInterstitialAdController(forAdUnitId: banerID)
        return interStitialAdCnt
    }
    
}
