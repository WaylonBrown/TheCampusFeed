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
           withScore:(NSInteger)newScore
         withMessage:(NSString *)newMessage
{   // initialize a new post

    self = [super init];
    if (self)
    {
        [self setPostID:newPostID];
        [self setCollegeID:-1];
        [self setScore:newScore];
        [self setMessage:newMessage];
        [self setCollegeName:@"<No College>"];
        [self setDate:[NSDate date]];
        [self setVote:nil];
         
        [self validate];
        return self;
    }
    return nil;
}
- (id)initWithMessage:(NSString *)newMessage
{   // initializer to create a new post
    
    self = [self initDummy];
    if (self)
    {
        [self setMessage:newMessage];
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
            case 0: [self setMessage:@"Post: If you're hungry for a hunk of #fat and #juicy meat"]; break;
            case 1: [self setMessage:@"Post: Eat my buddy #Pumba here because he is a treat"]; break;
            case 2: [self setMessage:@"Post: Come on down and dine"]; break;
            case 3: [self setMessage:@"Post: On this #tastyswine"]; break;
            case 4: [self setMessage:@"Post: All you have to do is get in line"]; break;
            default: [self setMessage:@"Post: #LUAU!"]; break;
        }
        
        
        self.commentList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++)
        {   // populate commentList
            Comment *comment = [[Comment alloc] initDummy];
            [self.commentList addObject:comment];
        }
        [self validate];
        return self;
    }
    return nil;
}
- (void)validate
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
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.message, @"text",
                                 nil];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0 error:&error];
    
    return data;
}

@end
