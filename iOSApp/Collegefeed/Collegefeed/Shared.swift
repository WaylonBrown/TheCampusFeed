//
//  Shared.swift
//  Collegefeed
//
//  Created by Patrick Sheehan on 8/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

import UIKit
import Foundation

class Shared:NSObject
{
    // Constant lengths
    class var MAX_POST_LENGTH:Int { return 140 }
    class var MIN_POST_LENGTH:Int { return 10 }

    // Custom colors
    class var CF_LIGHTBLUE:Int  { return 0x33B5E5 }
    class var CF_BLUE:Int       { return 0x0099CC }
    class var CF_LIGHTGRAY:Int  { return 0xE6E6E6 }
    class var CF_GRAY:Int       { return 0x7C7C7C }
    class var CF_DARKGRAY:Int   { return 0x444444 }
    class var CF_WHITE:Int      { return 0xFFFFFF }

    // Cell height prediction values
    class var LARGE_CELL_LABEL_WIDTH:CGFloat        { return 252 }
    class var LARGE_CELL_TOP_TO_LABEL:CGFloat       { return 7 }
    class var LARGE_CELL_LABEL_TO_BOTTOM:CGFloat    { return 59 }
    class var LARGE_CELL_MIN_LABEL_HEIGHT:CGFloat   { return 53 }

    class var SMALL_CELL_LABEL_WIDTH:CGFloat        { return 282 }
    class var SMALL_CELL_TOP_TO_LABEL:CGFloat       { return 10 }
    class var SMALL_CELL_LABEL_TO_BOTTOM:CGFloat    { return 10 }
    class var SMALL_CELL_MIN_LABEL_HEIGHT:CGFloat   { return 36 }

    // Website
    class var WEBSITE_LINK:NSString { return "http://cfeed.herokuapp.com" }
    class var logoImage:NSString    { return "thecampusfeedlogosmall.png" }

    // Custom fonts
    class func CF_FONT_LIGHT(s:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: s)
    }
    
    class func CF_FONT_ITALIC(s:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-LightItalic", size: s)
    }

    class func CF_FONT_MEDIUM(s:CGFloat) -> UIFont {
        return UIFont(name: "mplus-2c-bold", size: s)
    }

    class func CF_FONT_BOLD(s:CGFloat) -> UIFont {
        return UIFont(name: "mplus-2c-bold", size: s)
    }
    
    // Title view for navigation bar
    class func logoTitleView() -> UIImageView {
        var image = UIImage(named: logoImage)
        return UIImageView(image: image)
    }
    
    class func getCustomUIColor(hexValue:Int) -> UIColor {
        var color = UIColor(red:CGFloat((hexValue & 0xFF0000) >> 16)/255.0,
                            green:CGFloat((hexValue & 0xFF00) >> 8)/255.0,
                            blue:CGFloat(hexValue & 0xFF)/255.0,
                            alpha:CGFloat(1.0))
        return color;
    }
    
    class func getSmallCellHeightEstimateWithText(text:NSString, font:UIFont) -> CGFloat {
        var size = text.sizeWithAttributes([NSFontAttributeName: font])
        // TODO: check these
        var height = max(size.height, SMALL_CELL_MIN_LABEL_HEIGHT);
        var fullHeight = height + SMALL_CELL_TOP_TO_LABEL + SMALL_CELL_LABEL_TO_BOTTOM;
        
        return fullHeight;
    }
    
    class func getLargeCellHeightEstimateWithText(text:NSString, font:UIFont) -> CGFloat {
        var size = text.sizeWithAttributes([NSFontAttributeName: font])
        // TODO: check these
        var height = max(size.height, LARGE_CELL_MIN_LABEL_HEIGHT);
        var fullHeight = height + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM;
        
        return fullHeight;
    }
}