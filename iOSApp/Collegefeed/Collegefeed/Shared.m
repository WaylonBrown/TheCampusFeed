//
//  Shared.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "College.h"
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
+ (float)getSmallCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(SMALL_CELL_LABEL_WIDTH, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, SMALL_CELL_MIN_LABEL_HEIGHT);
    float fullHeight = height + SMALL_CELL_TOP_TO_LABEL + SMALL_CELL_LABEL_TO_BOTTOM;
    
    return fullHeight;
}

+ (float)getLargeCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(LARGE_CELL_LABEL_WIDTH, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, LARGE_CELL_MIN_LABEL_HEIGHT);
    float fullHeight = height + LARGE_CELL_TOP_TO_LABEL + LARGE_CELL_LABEL_TO_BOTTOM;
    
    return fullHeight;
}

@end
