//
//  CollectionViewItemCell.swift
//  SampleSwiftTable
//
//  Created by Rama kuppa on 26/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CollectionViewItemCell: UICollectionViewCell {
    
    
    var textLabel: UILabel!
    var imageView: UIImageView!
    var cellBackGroundView : UIView!
    var activity: DTIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellBackGroundView = UIView(frame: CGRect(x: 5, y: 0, width: CXConstant.collectiViewCellSize.width-10, height: CXConstant.collectiViewCellSize.height))
        contentView.addSubview(cellBackGroundView)
        
        cellBackGroundView.layer.cornerRadius = 1.0
        cellBackGroundView.layer.borderColor = CXConstant.collectionCellborderColor.CGColor
        cellBackGroundView.layer.borderWidth = 2.0
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 25, width: frame.size.width, height: CXConstant.collectiViewCellSize.height-50))
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.contentMode = UIViewContentMode.ScaleToFill
        contentView.addSubview(imageView)
        
        
        let textFrame = CGRect(x: 0, y: 5, width: cellBackGroundView.frame.size.width, height: 30)
        textLabel = UILabel(frame: textFrame)
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: "Roboto-Bold",size: 15)
        textLabel.textColor = CXConstant.titleLabelColor
        textLabel.backgroundColor = UIColor.clearColor()
        cellBackGroundView.addSubview(textLabel)
        
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:(self.cellBackGroundView.frame.size.width - 60)/2, y:(self.cellBackGroundView.frame.size.height - 60)/2, width:60.0, height:60.0))
        self.cellBackGroundView.addSubview(self.activity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

