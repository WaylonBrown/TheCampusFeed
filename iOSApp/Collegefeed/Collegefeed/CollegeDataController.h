//
//  CollegeDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class College;

@interface CollegeDataController : NSObject

@property (nonatomic, strong) NSMutableArray *masterCollegeList;
@property (nonatomic) NSURL *collegeURL;
@property (nonatomic) NSMutableData *responseData;

- (NSUInteger)countOfList;
- (College *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addCollege:(College *)college;

@end
