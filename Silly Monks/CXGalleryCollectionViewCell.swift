//
//  CXGalleryCollectionViewCell.swift
//  Silly Monks
//
//  Created by Sarath on 10/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXGalleryCollectionViewCell: UICollectionViewCell {
    var picView:UIImageView!
    var activity: DTIActivityIndicatorView!
    
//    @IBOutlet var picView : UIImageView!
//    
//    @IBOutlet weak var image: UIImageView!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    

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
        
       // print("Gallery Pic Frame \(self.picView.frame)")
       // self.picView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:0, y:0, width:60.0, height:60.0))
        self.activity.center = self.picView.center
        self.picView.addSubview(self.activity)

        self.contentView.addSubview(self.picView)
        
       // self.addSubview(self.picView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
