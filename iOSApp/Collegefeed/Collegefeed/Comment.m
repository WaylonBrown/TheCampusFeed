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
        _collegeID = post.collegeID;
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
        
        switch (_commentID % 4)
        {
            case 0: _message = @"Comment: Are you achin?"; break;
            case 1: _message = @"Comment: Yup yup yup"; break;
            case 2: _message = @"Comment: For some bacon?"; break;
            default: _message = @"Comment: LUAU!"; break;
        }
        
        _date = [NSDate date];
        
        return self;
    }
    return nil;
}

@end
