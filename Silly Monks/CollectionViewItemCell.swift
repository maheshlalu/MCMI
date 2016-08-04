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
        
        //20, 0, UIScreen.mainScreen().bounds.size.width-40, CXConstant.tableViewHeigh-10
        //x: 5, y: 0, width: CXConstant.collectiViewCellSize.width-10, height: CXConstant.collectiViewCellSize.height
        cellBackGroundView = UIView(frame: CGRect(x: 5, y: -70, width: UIScreen.mainScreen().bounds.size.width, height:CXConstant.collectiViewCellSize.height))
        cellBackGroundView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(cellBackGroundView)
        
//        cellBackGroundView.layer.cornerRadius = 1.0
//        cellBackGroundView.layer.borderColor = CXConstant.collectionCellborderColor.CGColor
//        cellBackGroundView.layer.borderWidth = 2.0
      
        imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: frame.size.width+50, height: CXConstant.collectiViewCellSize.height-10))
        imageView.backgroundColor = UIColor.clearColor()
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.contentMode = UIViewContentMode.ScaleToFill
        contentView.addSubview(imageView)
        
         /*
        let textFrame = CGRect(x: 0, y: 10, width: cellBackGroundView.frame.size.width, height: 50)
        textLabel = UILabel(frame: textFrame)
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: "Roboto-Bold",size: 15)
        textLabel.textColor = UIColor.darkGrayColor()
        textLabel.backgroundColor = UIColor.clearColor()
        cellBackGroundView.addSubview(textLabel)
        */
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:(self.cellBackGroundView.frame.size.width - 60)/2, y:(self.cellBackGroundView.frame.size.height - 60)/2, width:60.0, height:60.0))
        self.cellBackGroundView.addSubview(self.activity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

