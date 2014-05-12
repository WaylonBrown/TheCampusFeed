//
//  DataControllerTests.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

// Assemble

// Act

// Assert

#import <XCTest/XCTest.h>
#import "PostDataController.h"
#import "CommentDataController.h"
#import "Post.h"

@interface DataControllerTests : XCTestCase

@property (nonatomic) PostDataController* PDC;
@property (nonatomic) CommentDataController* CDC;

@end

@implementation DataControllerTests

- (void)setUp
{
    [super setUp];
    self.PDC = [[PostDataController alloc] init];
    self.CDC = [[CommentDataController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark PostDataController Tests
- (void)testPostDataControllerAddPost
{
    // Assemble
    [self.PDC.masterPostList removeAllObjects];

    Post *post1 = [[Post alloc] initDummy];
    Post *post2 = [[Post alloc] initDummy];
    Post *post3 = [[Post alloc] initDummy];

    // Act
    [self.PDC addPost:post1];
    [self.PDC addPost:post2];
    [self.PDC addPost:post3];
    
    // Assert
    XCTAssertEqual(3, self.PDC.countOfList, @"Wrong Post Array Size");
}

- (void)testPostDataControllerGetPosts
{
    // Assemble
    [self.PDC.masterPostList removeAllObjects];
    
    // Act
   [self.PDC fetchAllPosts];

    // Assert
    XCTAssertNotEqual(0, self.PDC.countOfList, @"No posts gathered during GET request");
    
    // XCTAssertNoThrow ?
}

#pragma mark CommentDataController Tests
- (void)testCommentDataControllerCommentsHaveSamePost
{
    // Assemble
    [self.CDC initializeDefaultList];
    NSString* postMessage;
    
    // Act
    postMessage = self.CDC.getPostMessage;
    
    // Assert
    XCTAssertNotEqual(postMessage, @"[Post's message not found]", @"No comments in array");
    XCTAssertNotEqual(postMessage, @"[Comments' post messages inconsistent]", @"Messages didn't match");
}


@end
