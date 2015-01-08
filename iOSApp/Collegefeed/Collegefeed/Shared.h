//
//  Shared.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/27/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Shared : NSObject

+ (UIFont*)getFontLight:(float)size;
+ (UIFont*)getFontBold:(float)size;
+ (UIFont*)getFontItalic:(float)size;
+ (UIColor*)getCustomUIColor:(int)hexValue;

@end
