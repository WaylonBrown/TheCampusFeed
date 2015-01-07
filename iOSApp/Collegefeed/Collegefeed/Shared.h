//
//  Shared.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/27/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"

#define MESSAGE_HEIGHT_CUSHION 17

@class College;

@interface Shared : NSObject

+ (UIFont*)getFontLight:(float)size;
+ (UIFont*)getFontBold:(float)size;
+ (UIFont*)getFontItalic:(float)size;
+ (UIColor*)getCustomUIColor:(int)hexValue;

@end
