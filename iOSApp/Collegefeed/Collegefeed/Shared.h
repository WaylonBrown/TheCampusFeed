//
//  Shared.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/27/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class College;

@interface Shared : NSObject

// Constant lengths
#define MAX_POST_LENGTH      140
#define MIN_POST_LENGTH      10

// Custom colors
#define CF_LIGHTBLUE   0x33B5E5 // 51, 181, 229
#define CF_BLUE        0x0099CC
#define CF_LIGHTGRAY   0xE6E6E6
#define CF_GRAY        0x7C7C7C
#define CF_DARKGRAY    0x444444
#define CF_WHITE       0xFFFFFF

// Cell height prediction values
#define LARGE_CELL_LABEL_WIDTH        252.0f
#define LARGE_CELL_TOP_TO_LABEL       6.0f
#define LARGE_CELL_LABEL_TO_BOTTOM    61.0f
#define LARGE_CELL_MIN_LABEL_HEIGHT   53.0f

#define SMALL_CELL_LABEL_WIDTH        290.0f
#define SMALL_CELL_TOP_TO_LABEL       0
#define SMALL_CELL_LABEL_TO_BOTTOM    10.0f
#define SMALL_CELL_MIN_LABEL_HEIGHT   6.0f


// Custom fonts
#define CF_FONT_LIGHT(s)    [UIFont fontWithName:@"Roboto-Light" size:s]
#define CF_FONT_ITALIC(s)   [UIFont fontWithName:@"Roboto-LightItalic" size:s]

//#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"Omnes_Semibold" size:s]
#define CF_FONT_MEDIUM(s)   [UIFont fontWithName:@"mplus-2c-bold" size:s]

#define CF_FONT_BOLD(s)     [UIFont fontWithName:@"mplus-2c-bold" size:s]

// Website
#define WEBSITE_LINK    @"http://cfeed.herokuapp.com"

// Title view for navigation bar
#define logoImageWithButton @"thecampusfeedlogosmallwithmenubutton"
#define logoImage @"thecampusfeedlogosmall.png"
#define logoTitleView [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoImage]]

+ (void)addCollegeNearby:(College *)college;
+ (UIColor*)getCustomUIColor:(int)hexValue;
+ (float)getSmallCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font;
+ (float)getLargeCellHeightEstimateWithText:(NSString *)text WithFont:(UIFont *)font;

+ (float)getSmallCellMessageHeight:(NSString *)text WithFont:(UIFont *)font;
+ (float)getLargeCellMessageHeight:(NSString *)text WithFont:(UIFont *)font;


@end
