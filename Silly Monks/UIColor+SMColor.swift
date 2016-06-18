//
//  UIColor+SMColor.swift
//  Silly Monks
//
//  Created by Sarath on 23/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

extension UIColor {
   class func navBarColor() -> UIColor{
        let color = UIColor.init(red: 239.0/255.0, green: 75.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        return color
    }
    
    class func smBackgroundColor () -> UIColor {
        let bgColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        return bgColor
    }
    
    class func smOrangeColor () -> UIColor {
        let color = UIColor(red: 252.0/255.0, green: 193.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        return color//252 193 40
    }
}
