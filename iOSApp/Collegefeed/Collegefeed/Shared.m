//
//  Shared.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/15/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
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
+ (void)queueToastWithSelector:(SEL)selector
{
    NSLog(@"Posting notification with @selector(%@)", NSStringFromSelector(selector));
    NSDictionary *info = [NSDictionary dictionaryWithObject:NSStringFromSelector(selector)
                                                     forKey:@"selector"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToastMessage"
                                                        object:self
                                                      userInfo:info];
}

@end
