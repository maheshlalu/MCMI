//
//  CXGalleryMoreCollectionViewCell.swift
//  Silly Monks
//
//  Created by CX_One on 8/22/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXGalleryMoreCollectionViewCell: UICollectionViewCell {
    
    var picView:UIImageView!
    var infoLabel: UILabel!
    var activity: DTIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.shadowColor = UIColor.blackColor().CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        
        self.picView = UIImageView.init(frame: CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height))
        self.picView.userInteractionEnabled = true
        self.picView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.picView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:0, y:0, width:60.0, height:60.0))
        self.activity.center = self.picView.center
        self.picView.addSubview(self.activity)
        
        self.contentView.addSubview(self.picView)
        
        self.infoLabel = UILabel.init(frame: CGRectMake(0, self.picView.frame.size.height-40, self.picView.frame.size.width, 40))
        self.infoLabel.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        self.infoLabel.font = UIFont(name:"Roboto-Regular",size:13)
        self.infoLabel.numberOfLines = 0
        self.infoLabel.textAlignment = NSTextAlignment.Center
        self.infoLabel.textColor = UIColor.darkGrayColor()
        self.picView.addSubview(self.infoLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
