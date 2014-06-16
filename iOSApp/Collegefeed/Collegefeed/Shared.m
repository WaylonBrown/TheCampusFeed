//
//  Shared.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Shared.h"

@implementation Shared

+ (UIColor*)getCustomUIColor:(int)hexValue
{
    UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                     green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                      blue:((float)(hexValue & 0xFF))/255.0
                                     alpha:1.0];
    
    return color;
}

@end
