//
//  DataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataController : NSObject

@property (nonatomic, strong) NSMutableArray *list;

- (void)initializeDefaultList;

- (NSUInteger)countOfList;
- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addObjectToList:(NSObject *)obj;
- (void)fetchAll;
- (id)getJsonObjectWithUrl:(NSURL*) url;

@end
