//
//  DataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
 
@class Votable;

@interface DataController : NSObject

@property (nonatomic, strong) NSMutableArray    *list;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDegrees         lat;
@property (nonatomic) CLLocationDegrees         lon;

// Initializations
- (id)initWithNetwork;

// Data Access
- (NSUInteger)countOfList;
- (NSObject *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addObjectToList:(NSObject *)obj;

// Network Access
- (id)getJsonObjectWithUrl:(NSURL*) url;
- (void)fetchWithUrl:(NSURL *)url intoList:(NSMutableArray *)array;
- (void)addToServer:(Votable *)obj intoList:(NSMutableArray *)array;

@end
