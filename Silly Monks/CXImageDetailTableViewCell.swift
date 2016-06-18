//
//  CXImageDetailTableViewCell.swift
//  Silly Monks
//
//  Created by Sarath on 19/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXImageDetailTableViewCell: UITableViewCell {

    var bgView : UIView!
    var detailImageView = UIImageView()
    var descLabel: CXLabel = CXLabel()
    var activity: DTIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.customizeMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeMainView() {
        self.bgView = UIView.init(frame: CGRectMake(0, 12.5, CXConstant.DETAIL_IMAGE_TABLE_WIDTH, CXConstant.DETAIL_IMAGE_CELL_HEIGHT-25))//CXConstant.DETAIL_IMAGE_CELL_HEIGHT-25
        self.bgView.backgroundColor = UIColor.clearColor()
        self.bgView.layer.cornerRadius = 6.0
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.bgView.layer.borderWidth = 1
        
        self.detailImageView.frame = CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height)
        self.detailImageView.backgroundColor = UIColor.whiteColor()
        self.detailImageView.image = UIImage(named:"smlogo.png")
        self.detailImageView.userInteractionEnabled = true
        
        self.descLabel.frame = CGRectMake(-1, self.detailImageView.frame.size.height-44, self.detailImageView.frame.size.width+2, 45)
        self.descLabel.textColor = UIColor.whiteColor()
        self.descLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        self.descLabel.backgroundColor = UIColor.orangeColor()
        
       // self.detailImageView.addSubview(self.descLabel)
        
        self.bgView.addSubview(self.detailImageView)
        
        self.activity = DTIActivityIndicatorView(frame: CGRect(x:(self.bgView.frame.size.width - 60)/2, y:(self.bgView.frame.size.height - 60)/2, width:60.0, height:60.0))
        self.bgView.addSubview(self.activity)
        
        self.addSubview(self.bgView)
        
    }
}

class CXLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}
