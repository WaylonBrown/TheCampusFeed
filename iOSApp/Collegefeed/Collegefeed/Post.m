//
//  Post.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "Post.h"
#import "Comment.h"
#import "Constants.h"


@implementation Post

// initializer to create a new post
- (id)initWithPostID:(NSInteger)newPostID withMessage:(NSString *)newPostMessage
{
    self = [super init];
    if (self)
    {
        [self setPostID:newPostID];
        [self setCollegeID:0];
        [self setScore:0];
        [self setVote:0];
        [self setMessage:newPostMessage];
        [self setCollegeName:@"<No College>"];
        [self setDate:[NSDate date]];
        
        [self validatePost];
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
        [self setPostID:arc4random() % 999];
        [self setCollegeID:arc4random() % 999];
        [self setScore:arc4random() % 999];
        [self setVote:0];
        [self setCollegeName:@"University of America, Bitch"];
        [self setDate:[NSDate date]];
        
        switch (self.postID % 6)
        {
            case 0: [self setMessage:@"Post: If you're hungry for a hunk of fat and juicy meat"]; break;
            case 1: [self setMessage:@"Post: Eat my buddy Pumba here because he is a treat"]; break;
            case 2: [self setMessage:@"Post: Come on down and dine"]; break;
            case 3: [self setMessage:@"Post: On this tasty swine"]; break;
            case 4: [self setMessage:@"Post: All you have to do is get in line"]; break;
            default: [self setMessage:@"Post: LUAU!"]; break;
        }
        
        
        self.commentList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++)
        {   // initialize commentList
            Comment *comment = [[Comment alloc] initDummy];
            [self.commentList addObject:comment];
        }
        [self validatePost];
        return self;
    }
    return nil;
}
// check for proper length
- (void)validatePost
{
    if (self.message.length < MIN_POST_LENGTH)
    {
        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too short", self.message];
    }
    if (self.message.length > MAX_POST_LENGTH)
    {
        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too long", self.message];
    }
}
@end
