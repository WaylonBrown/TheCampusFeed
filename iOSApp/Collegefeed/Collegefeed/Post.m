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
-(id)initWithPostID:(NSInteger)postID withMessage:(NSString *)message
{
    self = [super init];
    if (self)
    {
        _postID = postID;
        _collegeID = 0;
        _score = 0;
        _vote = 0;
        
        _message = message;
        _collegeName = @"<No College>";
        
        _date = [NSDate date];
        
        // need to initialize commentList?
        
        return self;
    }
    return nil;
}

// dummy initializer for dev/testing
-(id)initDummy
{
    self = [super init];
    if (self)
    {
        _postID = arc4random() % 999;
        _collegeID = arc4random() % 999;
        _score = arc4random() % 99;
        _vote = 0;
        
        _message = @"If you're hungry for a hunk of fat and juicy meat; eat my buddy Pumba here because he is a treat";
        _collegeName = @"University of America, Bitch";
        
        _date = [NSDate date];
        
        // need to initialize commentList?
        
        return self;
    }
    return nil;
}

@end
