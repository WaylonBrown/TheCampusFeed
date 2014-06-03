//
//  DataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@class Votable;

@interface DataController : NSObject

@property (nonatomic, strong) NSMutableArray *list;

// Initializations
- (id)init;

// Data Access
- (NSUInteger)countOfList;
- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addObjectToList:(NSObject *)obj;

// Network Access
- (id)GETfromServer:(NSURL*) url;
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array;
- (void)POSTtoServer:(Votable *)obj intoList:(NSMutableArray *)array;

@end
