//
//  NativeAdCell.swift
//  Silly Monks
//
//  Created by CX_One on 8/4/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import mopub_ios_sdk
class NativeAdCell: UIView , MPNativeAdRendering {
    // MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mainTextLabel: UILabel!
    
    @IBOutlet weak var callToActionButton: UIButton!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var privacyInformationIconImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        // Decorate the call to action button.
        callToActionButton.layer.masksToBounds = false
        callToActionButton.layer.cornerRadius = 6
        
        // Decorate the ad container.
       // containerView.layer.cornerRadius = 6
        
        // Add the background color to the main view.
        backgroundColor = UIColor.clearColor()
        //backgroundColor = UIColor(red: 55/255, green: 31/255, blue: 31/255, alpha: 1.0)
        
    }
    
    // MARK: MPNativeAdRendering
    
    func nativeMainTextLabel() -> UILabel! {
        return self.mainTextLabel
    }
    
    func nativeTitleTextLabel() -> UILabel! {
        return self.titleLabel
    }
    
    func nativeCallToActionTextLabel() -> UILabel! {
        return self.callToActionButton.titleLabel
    }
    
    func nativeIconImageView() -> UIImageView! {
        return self.iconImageView
    }
    
    func nativeMainImageView() -> UIImageView! {
        return self.mainImageView
    }
    
    func nativeVideoView() -> UIView! {
        return self.videoView
    }
    
    func nativePrivacyInformationIconImageView() -> UIImageView! {
        return self.privacyInformationIconImageView
    }
    
    // Return the nib used for the native ad.
    class func nibForAd() -> UINib! {
        return UINib(nibName: "NativeAdCell", bundle: nil)
    }
}
