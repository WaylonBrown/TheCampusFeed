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

@synthesize postID;
@synthesize collegeID;
@synthesize score;
@synthesize vote;

@synthesize message;
@synthesize collegeName;

// initializer to create a new post
- (id)initWithPostID:(NSInteger)postID withMessage:(NSString *)postMessage
{
    self = [super init];
    if (self)
    {
        collegeID = 0;
        score = 0;
        vote = 0;
        
        self.message = message;
        collegeName = @"<No College>";
        
        _date = [NSDate date];
        
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
        postID = arc4random() % 999;
        collegeID = arc4random() % 999;
        score = arc4random() % 99;
        vote = 0;
        
        switch (postID % 6)
        {
            case 0: message = @"Post: If you're hungry for a hunk of fat and juicy meat"; break;
            case 1: message = @"Post: Eat my buddy Pumba here because he is a treat"; break;
            case 2: message = @"Post: Come on down and dine"; break;
            case 3: message = @"Post: On this tasty swine"; break;
            case 4: message = @"Post: All you have to do is get in line"; break;
            default: message = @"Post: LUAU!"; break;
        }
        collegeName = @"University of America, Bitch";
        
        _date = [NSDate date];
        
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
