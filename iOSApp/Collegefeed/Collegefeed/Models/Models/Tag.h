//
//  Tag.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFModelProtocol.h"

@interface Tag : NSObject<CFModelProtocol>

@property (nonatomic) long tagID;
@property (nonatomic) long postID;
@property (nonatomic) long score;
@property (nonatomic, strong) NSString *name;

- (id)initWithTagID:(NSInteger)tID
          withScore:(BOOL)tScore
           withName:(NSString*)name;
- (id)initDummy;
- (id)initFromJSON:(NSDictionary *)jsonObject;
+ (BOOL)withMessageIsValid:(NSString*)tagMessage;
@end
