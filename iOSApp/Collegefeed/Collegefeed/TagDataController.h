//
//  TagDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataController.h"

@interface TagDataController : DataController

@property (nonatomic) NSURL *tagURL;
@property (nonatomic) NSMutableData *responseData;

@end
