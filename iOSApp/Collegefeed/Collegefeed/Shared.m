//
//  Shared.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/15/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
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
+ (UIFont*)getFontLight:(float)size
{
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}
+ (UIFont*)getFontBold:(float)size
{
    return [UIFont fontWithName:@"mplus-2c-bold" size:size];
}
+ (UIFont*)getFontItalic:(float)size
{
    return [UIFont fontWithName:@"Roboto-LightItalic" size:size];
}

#pragma mark - Height of Cell

+ (float)getSmallCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font
{
    CGFloat height = [self getSmallCellMessageHeight:text WithFont:font];
    float fullHeight = height + SMALL_CELL_TOP_TO_LABEL + SMALL_CELL_LABEL_TO_BOTTOM;
    
    return fullHeight + 1;
}

+ (float)getSmallCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font withWidth:(float)width
{
    CGFloat height = [self getSmallCellMessageHeight:text WithFont:font];
    float fullHeight = height + SMALL_CELL_TOP_TO_LABEL + SMALL_CELL_LABEL_TO_BOTTOM;
    
    return fullHeight + 1;
}

#pragma mark - Height of Cell's message

+ (float)getSmallCellMessageHeight:(NSString *)text WithFont:(UIFont *)font
{    
    float height = SMALL_CELL_MIN_LABEL_HEIGHT;
    if (text != nil && ![text isEqualToString:@""])
    {
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:text];
        UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SMALL_CELL_LABEL_WIDTH, 2000.0f)];
        [calculationView setAttributedText:aString];
        
        
        CGRect textRect = [calculationView.text
                           boundingRectWithSize:calculationView.frame.size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                           context:ctx];
        
        height = textRect.size.height + MESSAGE_HEIGHT_CUSHION;
    }
    
    return MAX(height, SMALL_CELL_MIN_LABEL_HEIGHT);
}
+ (float)getSmallCellMessageHeight:(NSString *)text WithFont:(UIFont *)font withWidth:(float)width
{
    float height = SMALL_CELL_MIN_LABEL_HEIGHT;
    if (text != nil && ![text isEqualToString:@""])
    {
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:text];
        UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 2000.0f)];
        [calculationView setAttributedText:aString];
        
        
        CGRect textRect = [calculationView.text
                           boundingRectWithSize:calculationView.frame.size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                           context:ctx];
        
        height = textRect.size.height + MESSAGE_HEIGHT_CUSHION;
    }
    
    return MAX(height, SMALL_CELL_MIN_LABEL_HEIGHT);
}

@end
