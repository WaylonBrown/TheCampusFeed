//
//  ModelTests.m
// TheCampusFeed
//
//  Created by Patrick Sheehan on 5/17/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "Post.h"
//#import "Vote.h"

@interface ModelTests : XCTestCase

@end

@implementation ModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//
//- (void)testPostCastVote
//{
//    Post *post = [[Post alloc] initWithPostID:1
//                                    withScore:0
//                                  withMessage:@"Testing Post voting"];
//    
//    // vote value when initialized
//    XCTAssertNil(post.vote, @"Post should not have a vote when initialized");
//
//    // cast upvote on post not yet voted on
//    [post castVote:YES];
//    XCTAssertEqual(YES, post.vote.upvote, @"Post's vote should update when upvoted");
//    XCTAssertEqual(1, post.score, @"Post's score should increment when upvoted");
//    
//    // cast upvote on post already upvoted
//    [post castVote:YES];
//    XCTAssertNil(post.vote, @"Post's vote should be removed when duplicate received");
//    XCTAssertEqual(0, post.score, @"Post's score should decrement when existing upvote removed");
//    
//    // cast downvote on post without vote
//    [post castVote:NO];
//    XCTAssertEqual(NO, post.vote.upvote, @"Post's vote should update when downvoted");
//    XCTAssertEqual(-1, post.score, @"Post's score should decrement when downvoted");
//
//    // cast upvote to a downvoted post
//    [post castVote:YES];
//    XCTAssertEqual(YES, post.vote.upvote, @"Post's vote should update when switching from down to upvote");
//    XCTAssertEqual(1, post.score, @"Post's score should increment by two when switching from down to upvote");
//    
//    // cast downvote to an upvoted post
//    [post castVote:NO];
//    XCTAssertEqual(NO, post.vote.upvote, @"Post's vote should update when switching from up to downvote");
//    XCTAssertEqual(-1, post.score, @"Post's score should decrement by two when switching from up to downvote");
//    
//}

@end
