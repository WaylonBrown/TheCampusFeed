//
//  Post.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Post.h"

@implementation Post

// initializer to create a new post
-(id)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        _content = content;
        _score = 0;
        _commentCount = 0;
        _date = [NSDate date];
        return self;
    }
    return nil;
}

@end
