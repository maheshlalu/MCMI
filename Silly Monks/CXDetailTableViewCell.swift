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
    var headerBtn: UIButton!
    var detailCollectionView: UICollectionView!
    var productCategories:CX_Product_Category!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style : UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.smBackgroundColor()
        self.backgroundView?.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.customizeBgView()
        self.customizeDetailCollectionView()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func customizeBgView(){
        let cellWidth = UIScreen.main.bounds.size.width
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
        
        let cellFrame = CGRect(x: 10, y: 0, width: cellWidth-20, height: viewHeight-25)
        
        
        self.bgView = UIView.init(frame: cellFrame)//CXConstant.DetailTableView_Width
        self.bgView.layer.borderColor = UIColor.gray.cgColor
        self.bgView.layer.borderWidth = 1.0
        self.bgView.backgroundColor = UIColor.white//UIColor.whiteColor()
        self.addSubview(self.bgView)
        
        self.headerLbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.bgView.frame.size.width, height: 30))
        self.headerLbl.font = UIFont(name:"Roboto-Bold", size:16)
        self.headerLbl.textAlignment = NSTextAlignment.center
        self.headerLbl.textColor = CXConstant.titleLabelColor
        self.bgView.addSubview(self.headerLbl)
        
        self.headerBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: self.bgView.frame.size.width, height: 30))
        self.headerBtn.backgroundColor = UIColor.clear
        self.bgView.addSubview(self.headerBtn)
    }
    
    
    func customizeDetailCollectionView(){
        let cellWidth = UIScreen.main.bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:2, bottom:0, right: 2)
        layout.minimumInteritemSpacing = -8
        layout.minimumLineSpacing = 2.2
        layout.itemSize = CXConstant.DetailCollectionCellSize
        self.detailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.detailCollectionView.showsHorizontalScrollIndicator = false
        self.detailCollectionView.frame = CGRect(x: 2, y: 30, width: cellWidth-4, height: CXConstant.DetailCollectionViewFrame.size.height-35)
        
        // CXConstant.DetailCollectionViewFrame
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.detailCollectionView.register(CXDetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        self.detailCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellID")
        self.detailCollectionView.backgroundColor = UIColor.clear
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
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        self.detailCollectionView.delegate = dataSourceDelegate
        self.detailCollectionView.dataSource = dataSourceDelegate
        self.detailCollectionView.tag = row
        self.headerBtn.tag = detailCollectionView.tag
        self.detailCollectionView.reloadData()
    }
    
}
