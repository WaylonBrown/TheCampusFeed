//
//  Constants.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#ifndef Collegefeed_Constants_h
#define Collegefeed_Constants_h

// Constant lengths
#define MAX_POST_LENGTH     140
#define MAX_COMMENT_LENGTH  140
#define MAX_TAG_LENGTH      50

#define MIN_POST_LENGTH     10
#define MIN_COMMENT_LENGTH  10
#define MIN_TAG_LENGTH      2

// RGB's for custom UIColors

#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 \
           alpha:1.0]

#define cf_lightblue   0x33B5E5
#define cf_blue        0x0099CC
#define cf_lightgray   0xE6E6E6
#define cf_gray        0x7C7C7C
#define cf_darkgray    0x444444
#define cf_white       0xFFFFFF

// Title view for navigation bar

#define logoImage @"collegefeedlogosmall.png"
#define logoTitleView [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoImage]]

// URLs for server requests

#define requestUrl                  @"http://cfeed.herokuapp.com/api/"
#define apiVersion                  @"v1/"
#define postsUrl                    [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@", requestUrl, \
                                    apiVersion, @"posts"]]

#define commentsUrl                 [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@", \
                                    requestUrl, apiVersion, @"comments"]]

#define commentsUrlGet(postid)      [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@?postid=%d", \
                                    requestUrl, apiVersion, @"comments", postid]]

#define collegesUrlAll              [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@", \
                                    requestUrl, apiVersion, @"colleges"]]

#define collegesUrlNearby(lat, lon) [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@?lat=%f&lon=%f", \
                                    requestUrl, apiVersion, @"colleges", lat, lon]]

#define tagsUrl                     [NSURL URLWithString:[NSString \
                                    stringWithFormat: @"%@%@%@", requestUrl, \
                                    apiVersion, @"tags/trending"]]

#endif
