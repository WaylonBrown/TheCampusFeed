//
//  CommentDataController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataController.h"

@class Post;

@interface CommentDataController : DataController

@property (nonatomic, weak) Post* post;

- (id) initWithPost:(Post*)post;
- (NSString *)getPostMessage;


@end
