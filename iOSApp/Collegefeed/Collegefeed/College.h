//
//  College.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/6/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface College : NSObject

@property (nonatomic) NSInteger collegeID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *shortName;

@end
