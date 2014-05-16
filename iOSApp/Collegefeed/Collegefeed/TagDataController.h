//
//  TagDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tag;

@interface TagDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterTagList;
@property (nonatomic) NSURL *tagURL;
@property (nonatomic) NSMutableData *responseData;

- (NSUInteger)countOfList;
- (Tag *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addTag:(Tag *)tag;

@end
