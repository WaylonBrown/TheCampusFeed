//
//  College.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFModelProtocol.h"

@interface College : NSObject<CFModelProtocol>

@property (nonatomic) long collegeID;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortName;

- (id)initWithCollegeID:(long)cID withName:(NSString*)cName;
- (id)initWithCollegeID:(long)cID withName:(NSString*)cName
                withLat:(float)lat withLon:(float)lon;

- (id)initWithCollegeID:(long)cID withName:(NSString*)cName
          withShortName:(NSString*)cShortName;

@end
