//
//  CXDetailTableViewCell.swift
//  Silly Monks
//
//  Created by Sarath on 09/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXDetailTableViewCell: UITableViewCell {
    
    var bgView : UIView!
    var headerLbl: UILabel!
    var detailCollectionView: UICollectionView!
    var productCategories:CX_Product_Category!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style : UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.smBackgroundColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.customizeBgView()
        self.customizeDetailCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func customizeBgView(){
        let cellWidth = UIScreen.mainScreen().bounds.size.width
        let viewHeight:CGFloat = CXConstant.RELATED_ARTICLES_CELL_HEIGHT-10
        //        var cellFrame = CGRectMake(0, 0, self.frame.size.width, viewHeight)
        //
        //        if CXConstant.currentDeviceScreen() == IPHONE_5S {
        //            cellFrame = CGRectMake(5, 5, self.frame.size.width-10, viewHeight)
        //        } else if CXConstant.currentDeviceScreen() == IPHONE_6 {
        //            cellFrame = CGRectMake(10, 5, CXConstant.DetailTableView_Width, viewHeight)
        //        } else if CXConstant.currentDeviceScreen() == IPHONE_6PLUS {
        //            cellFrame = CGRectMake(5, 5, CXConstant.DetailTableView_Width, viewHeight)
        //        }
        
        let cellFrame = CGRectMake(10, 0, cellWidth-20, viewHeight)
        
        
        self.bgView = UIView.init(frame: cellFrame)//CXConstant.DetailTableView_Width
        self.bgView.layer.borderColor = UIColor.grayColor().CGColor
        self.bgView.layer.borderWidth = 1.0
        self.bgView.backgroundColor = UIColor.whiteColor()//UIColor.whiteColor()
        self.addSubview(self.bgView)
        
        self.headerLbl = UILabel.init(frame: CGRectMake(0, 0, self.bgView.frame.size.width, 30))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:16)
        self.headerLbl.textAlignment = NSTextAlignment.Center
        self.headerLbl.textColor = CXConstant.titleLabelColor
        self.bgView.addSubview(self.headerLbl)
    }
    
    func customizeDetailCollectionView(){
        let cellWidth = UIScreen.mainScreen().bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CXConstant.DetailCollectionCellSize
        self.detailCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.detailCollectionView.showsHorizontalScrollIndicator = false
        self.detailCollectionView.frame = CGRectMake(2, 30, cellWidth-4, CXConstant.DetailCollectionViewFrame.size.height)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.detailCollectionView.registerClass(CXDetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        self.detailCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellID")
        self.detailCollectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.detailCollectionView)
    }
}


extension CXDetailTableViewCell {
    
    var collectionViewOffset: CGFloat {
        set {
            self.detailCollectionView.contentOffset.x = newValue
        }
        get {
            return detailCollectionView.contentOffset.x
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        self.detailCollectionView.delegate = dataSourceDelegate
        self.detailCollectionView.dataSource = dataSourceDelegate
        self.detailCollectionView.tag = row
        self.detailCollectionView.reloadData()
    }
    
}