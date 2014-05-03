//
//  Comment.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Comment.h"
#import "Post.h"

@implementation Comment

- (id)initWithCommentID:(NSInteger)commentID withMessage:(NSString *)message withPostID:(NSInteger)postID
{
    self = [super init];
    if (self)
    {
        _commentID = commentID;
        _postID = postID;
        _collegeID = 0;
        _score = 0;
        _vote = 0;
        
        _message = message;
        
        _date = [NSDate date];
        
        return self;
    }
    return nil;
    
}
// assign values from the post that was commented on
- (id)initWithPost:(Post *)post
{
    self = [self initDummy];
    if (self)
    {
        _postID = post.postID;
        _collegeID = post.postID;
        _postMessage = post.message;
        
        return self;
    }
    return nil;
}
- (id)initDummy
{
    self = [super init];
    if (self)
    {
        _commentID = arc4random() % 999;
        _postID = arc4random() % 999;
        _collegeID = arc4random() % 999;
        _score = arc4random() % 99;
        _vote = 0;
        
        switch (_commentID % 5)
        {
            case 0: _message = @"If you're hungry for a hunk of fat and juicy meat"; break;
            case 1: _message = @"Eat my buddy Pumba here because he is a treat"; break;
            case 2: _message = @"Come on down and dine"; break;
            case 3: _message = @"On this tasty swine"; break;
            case 4: _message = @"All you have to do is get in line"; break;
            default: _message = @"LUAU!"; break;
        }
        
        _date = [NSDate date];
        
        return self;
    }
    return nil;
}

@end
