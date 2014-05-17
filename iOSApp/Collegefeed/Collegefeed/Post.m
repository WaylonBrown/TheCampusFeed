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
#import "Vote.h"

@implementation Post

- (id)initWithPostID:(NSInteger)newPostID
           withScore:(NSInteger)score
     withPostMessage:(NSString *)newPostMessage
{   // initializer to create a new post

    self = [super init];
    if (self)
    {
        [self setPostID:newPostID];
        [self setCollegeID:0];
        [self setScore:score];
        [self setPostMessage:newPostMessage];
        [self setCollegeName:@"<No College>"];
        [self setDate:[NSDate date]];
        [self setVote:nil];
         
        [self validatePost];
        return self;
    }
    return nil;
}
- (id)initWithPostMessage:(NSString *)newPostMessage
{   // initializer to create a new post
    
    self = [self initDummy];
    if (self)
    {
        [self setPostMessage:newPostMessage];
        return self;
    }
    return nil;
}
- (id)initDummy
{   // dummy initializer for dev/testing

    self = [super init];
    if (self)
    {
        [self setPostID:arc4random() % 999];
        [self setCollegeID:arc4random() % 999];
        [self setScore:arc4random() % 999];
        [self setCollegeName:@"University of America, Bitch"];
        [self setDate:[NSDate date]];
        
        switch (self.postID % 6)
        {
            case 0: [self setPostMessage:@"Post: If you're hungry for a hunk of #fat and #juicy meat"]; break;
            case 1: [self setPostMessage:@"Post: Eat my buddy #Pumba here because he is a treat"]; break;
            case 2: [self setPostMessage:@"Post: Come on down and dine"]; break;
            case 3: [self setPostMessage:@"Post: On this #tastyswine"]; break;
            case 4: [self setPostMessage:@"Post: All you have to do is get in line"]; break;
            default: [self setPostMessage:@"Post: #LUAU!"]; break;
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
- (void)validatePost
{   // check for proper length

//    if (self.postMessage.length < MIN_POST_LENGTH)
//    {
//        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too short", self.postMessage];
//    }
//    if (self.postMessage.length > MAX_POST_LENGTH)
//    {
//        [NSException raise:@"Invalid Post" format:@"Post \"%@\" is too long", self.postMessage];
//    }
}
- (NSData*)toJSON
{   // Returns an NSData representation of this Post in JSON
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.postMessage, @"text",
                                 nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    
    return postData;
}
- (void)castVote:(BOOL)isUpVote
{   // TODO: send vote to server also (maybe only in data controller?)

    
    // Sets the vote for this Object and updates the score
    // Removes the vote if the same one is given
    // e.g. If (isUpVote && already upvoted) then (remove upvote/decrease score)
    //  - (similarly for repeat downvotes)
    
    if (self.vote == nil)
    {   // New vote on this object, one did not previously exist
        Vote *newVote = [[Vote alloc] initWithVotableID:self.postID
                                       withUpvoteValue:isUpVote];
        [self setVote:newVote];
    }
    else
    {   // This object already had a vote; update/delete
        
        // undo the original vote
        self.score = self.vote.upvote
                    ? self.score - 1
                    : self.score + 1;
        
        if (self.vote.upvote == isUpVote)
        {   // if a duplicate vote was cast, remove the vote
            [self setVote:nil];
            return;
        }
        
        [self.vote setUpvote:isUpVote];
    }
    
    // update score with new vote
    self.score = self.vote.upvote
                ? self.score + 1
                : self.score - 1;
}


@end
