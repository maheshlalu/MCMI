//
//  CXRelatedTableViewCell.swift
//  Silly Monks
//
//  Created by NUNC on 5/26/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXRelatedArticleTableViewCell: UITableViewCell {
    
    var bgView : UIView!
    var headerLbl: UILabel!
    var relatedArticleCollectionView: UICollectionView!
    var productCategories:CX_Product_Category!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style : UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.customizeBgView()
        self.customizeDetailCollectionView()
    }
    
    func customizeBgView(){
        let viewHeight:CGFloat = CXConstant.RELATED_ARTICLES_CELL_HEIGHT-10
      //  let viewHeight:CGFloat = CXConstant.RELATED_ARTICLES_CELL_HEIGHT
        
        let viewWidth:CGFloat = UIScreen.mainScreen().bounds.width-20

        let cellFrame = CGRectMake(5, 5, viewWidth-10, viewHeight)
        
//        if CXConstant.currentDeviceScreen() == IPHONE_5S {
//            cellFrame = CGRectMake(5, 5, viewWidth-10, viewHeight)
//        } else if CXConstant.currentDeviceScreen() == IPHONE_6 {
//            cellFrame = CGRectMake(10, 5, CXConstant.DetailTableView_Width, viewHeight)
//        } else if CXConstant.currentDeviceScreen() == IPHONE_6PLUS {
//            cellFrame = CGRectMake(5, 5, CXConstant.DetailTableView_Width, viewHeight)
//        }
        self.bgView = UIView.init(frame: cellFrame)//CXConstant.DetailTableView_Width
        self.bgView.layer.borderColor = UIColor.grayColor().CGColor
        self.bgView.layer.borderWidth = 1.0
        self.bgView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.bgView)
        
        self.headerLbl = UILabel.init(frame: CGRectMake(0, 0, self.bgView.frame.size.width, 30))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:16)
        self.headerLbl.textAlignment = NSTextAlignment.Center
        self.headerLbl.textColor = CXConstant.titleLabelColor
        self.bgView.addSubview(self.headerLbl)
    }
    func customizeDetailCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CXConstant.DetailCollectionCellSize
        self.relatedArticleCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.relatedArticleCollectionView.showsHorizontalScrollIndicator = false
        self.relatedArticleCollectionView.frame = CGRectMake(self.bgView.frame.origin.x, 30, self.bgView.frame.size.width, CXConstant.DetailCollectionViewFrame.size.height)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.relatedArticleCollectionView.registerClass(CXDetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        self.relatedArticleCollectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.relatedArticleCollectionView)
    }

}

extension CXRelatedArticleTableViewCell {
    
    var collectionViewOffset: CGFloat {
        set {
            self.relatedArticleCollectionView.contentOffset.x = newValue
        }
        get {
            return relatedArticleCollectionView.contentOffset.x
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        self.relatedArticleCollectionView.delegate = dataSourceDelegate
        self.relatedArticleCollectionView.dataSource = dataSourceDelegate
        self.relatedArticleCollectionView.tag = row
        self.relatedArticleCollectionView.reloadData()
    }
    
}
