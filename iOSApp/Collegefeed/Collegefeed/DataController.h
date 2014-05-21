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

- (id)initWithNetwork:(BOOL)useNetwork;


- (void)initializeDefaultList;

- (NSUInteger)countOfList;
- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addObjectToList:(NSObject *)obj;


- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array;
- (id)getJsonObjectWithUrl:(NSURL*) url;

- (void)addToServer:(Votable *)obj intoList:(NSMutableArray *)array;


@end
