//
//  Tag.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (nonatomic) NSInteger tagID;
@property (nonatomic) NSInteger postID;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSString *name;

- (id)initWithTagID:(NSInteger)tID
          withScore:(BOOL)tScore
           withName:(NSString*)name;
- (id)initDummy;
- (id)initFromJSON:(NSDictionary *)jsonObject;
- (NSData*)toJSON;
- (void)validate;

@end
