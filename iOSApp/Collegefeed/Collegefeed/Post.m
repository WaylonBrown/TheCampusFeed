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
- (id)initWithPostID:(NSInteger)postID withMessage:(NSString *)message
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
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        _postID = arc4random() % 999;
        _collegeID = arc4random() % 999;
        _score = arc4random() % 99;
        _vote = 0;
        
        switch (_postID % 5)
        {
            case 0: _message = @"If you're hungry for a hunk of fat and juicy meat"; break;
            case 1: _message = @"Eat my buddy Pumba here because he is a treat"; break;
            case 2: _message = @"Come on down and dine"; break;
            case 3: _message = @"On this tasty swine"; break;
            case 4: _message = @"All you have to do is get in line"; break;
            default: _message = @"LUAU!"; break;
        }
        _collegeName = @"University of America, Bitch";
        
        _date = [NSDate date];
        
        // need to initialize commentList?
        
        return self;
    }
    return nil;
}

@end
