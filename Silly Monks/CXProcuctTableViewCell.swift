//
//  CXProcuctTableViewCell.swift
//  Silly Monks
//
//  Created by Sarath on 04/06/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXProcuctTableViewCell: UITableViewCell {
    
    var bgView : UIView = UIView()
    var productDesc: UILabel = UILabel()
    var productImageView : UIImageView!

    
    override init(style : UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.smBackgroundColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.customizeBgView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func customizeBgView() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
//        let screenHeight = UIScreen.mainScreen().bounds.size.heigth
        
        self.bgView.frame = CGRectMake(2, 5, screenWidth-4,CXConstant.PRODUCT_CELL_HEIGHT-10);// x-8
        self.bgView.layer.cornerRadius = 5.0
        self.bgView.layer.borderWidth = 1.0
        self.bgView.layer.borderColor = UIColor.grayColor().CGColor
        self.bgView.backgroundColor = UIColor.whiteColor()
        
        self.productImageView = UIImageView.init(frame:CGRectMake(5, 5, self.bgView.frame.size.width-10, CXConstant.PRODUCT_IMAGE_HEIGHT-6))
        self.bgView.addSubview(self.productImageView)
        
        let separator = UIView.init(frame: CGRectMake(0, self.productImageView.frame.size.height+self.productImageView.frame.origin.y+5, self.bgView.frame.size.width, 1))
        separator.backgroundColor = UIColor.grayColor()
        self.bgView.addSubview(separator)
        
        self.productDesc.frame = CGRectMake(0, separator.frame.size.height+separator.frame.origin.y, self.bgView.frame.size.width, 37)
        self.productDesc.font = UIFont(name:"Roboto-Regular",size:14)
        self.productDesc.textColor = UIColor.grayColor()
        self.productDesc.textAlignment = NSTextAlignment.Center
       // self.productDesc.layer.borderWidth = 1
        self.productDesc.numberOfLines = 0
        self.productDesc.backgroundColor = UIColor.clearColor()
        
        self.bgView.addSubview(self.productDesc)
        
        self.contentView.addSubview(self.bgView)
        
        
        
        
        //Title Lbl
        
//        cellTitlelbl.frame = CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width-20, 70)
//        //cellTitlelbl.text = "Tollywood News"
//        cellTitlelbl.font = UIFont.boldSystemFontOfSize(15)
//        cellTitlelbl.textAlignment = NSTextAlignment.Center;
//        cellTitlelbl.textColor = CXConstant.titleLabelColor
//        backGrooundView.addSubview(cellTitlelbl)

    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
