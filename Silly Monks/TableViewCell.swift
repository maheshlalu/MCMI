//
//  TableViewCell.swift
//  SampleSwiftTable
//
//  Created by Sarath on 12/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var backGrooundView : UIView = UIView()
    var cellTitlelbl: UILabel = UILabel()
    var collectionView: UICollectionView!
    
    override init(style : UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.smBackgroundColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.designBackGroundView()
        self.designCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func designBackGroundView(){
        
        // backGrooundView.frame = CGRectMake(0, 5, UIScreen.mainScreen().bounds.size.width, CXConstant.tableViewHeigh-10);// x-8
        
        
           // backGrooundView.frame = CGRectMake(20, 0, UIScreen.mainScreen().bounds.size.width-40,200);
            backGrooundView.frame = CGRectMake(20, 0, UIScreen.mainScreen().bounds.size.width-40, CXConstant.homeScreenTableViewHeight-10);// x-8
        
//        backgroundView?.layer.cornerRadius = 1.0
//        backgroundView?.layer.borderWidth = 1.0
//        backgroundView?.layer.borderColor = UIColor.blueColor().CGColor
        backGrooundView.layer.cornerRadius = 1.0
        backGrooundView.layer.borderWidth = 1.0
        backGrooundView.layer.borderColor = UIColor.grayColor().CGColor
        backGrooundView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(backGrooundView)
        
        //Title Lbl
        
        cellTitlelbl.frame = CGRectMake(-15,-25, UIScreen.mainScreen().bounds.size.width, 70)
        cellTitlelbl.text = "Tollywood News"
        cellTitlelbl.font = UIFont.boldSystemFontOfSize(14)
        cellTitlelbl.textAlignment = NSTextAlignment.Center;
        cellTitlelbl.textColor = UIColor.navBarColor()
        backGrooundView.addSubview(cellTitlelbl)
        
        //CeolectionView
    }
    
    func designCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CXConstant.collectiViewCellSize
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.frame = CXConstant.collectionViewFrame
        collectionView.frame = CXConstant.HOME_COLLECTION_FRAME
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.registerClass(CollectionViewItemCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(collectionView)
        
    }
    
}

extension TableViewCell{
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        get {
            return collectionView.contentOffset.x
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}