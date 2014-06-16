//
//  College.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface College : Model

@property (nonatomic) NSInteger collegeID;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortName;

- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName;
- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName
                withLat:(NSInteger)lat withLon:(NSInteger)lon;

- (id)initWithCollegeID:(NSInteger)cID withName:(NSString*)cName
          withShortName:(NSString*)cShortName;

@end
