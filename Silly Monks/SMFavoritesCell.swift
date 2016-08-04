//
//  SMFavoritesCell.swift
//  Silly Monks
//
//  Created by CX_One on 7/29/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class SMFavoritesCell: UITableViewCell {

    @IBOutlet weak var favoritesImageview: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
