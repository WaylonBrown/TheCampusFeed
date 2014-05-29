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
#import "Comment.h"
#import "Shared.h"

@interface DataControllerTests : XCTestCase

@property (nonatomic) PostDataController* PDC;
@property (nonatomic) CommentDataController* CDC;

@end

@implementation DataControllerTests

- (void)setUp
{   // NOT called by default
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark PostDataController Tests

- (void)testPostDataControllerGetAllPostsFromServer
{
    // Assemble
    self.PDC = [[PostDataController alloc] initWithNetwork:YES];
    
    // Act
    [self.PDC fetchWithUrl:postsUrl
                  intoList:self.PDC.topPostsAllColleges];
    
    // Assert
    XCTAssertNotEqual(0, self.PDC.topPostsAllColleges.count, @"No posts gathered during GET request");
}

- (void)testPostDataControllerAddPostToServer
{
    // Assemble
    Post *post = [[Post alloc] initWithMessage:@"Test post from testPostDataControllerAddPostToServer"];
    self.PDC = [[PostDataController alloc] initWithNetwork:YES];
    
    // Act
    [self.PDC addToServer:post
                 intoList:self.PDC.topPostsAllColleges];
    
    // Assert
    
}


#pragma mark CommentDataController Tests

- (void)testCommentDataControllerGetAllCommentFromServer
{
    //TODO: comments from server, must access specific post_id
    
//    // Assemble
//    self.CDC = [[CommentDataController alloc] initWithNetwork:YES withPost:<somePost>];
    
//    // Act
//    [self.PDC fetchWithUrl:commmentsUrl(<somePostID>)
//                  intoList:self.CDC.<someList>];
//    
//    // Assert
//    XCTAssertNotEqual(0, self.PDC.topPostsAllColleges.count, @"No posts gathered during GET request");
}

- (void)testCommentDataControllerAddCommentToServer
{
    // Assemble
    Post *post = [[Post alloc] initWithMessage:@"Test post from testCommentDataControllerAddCommentToServer"];
    self.PDC = [[PostDataController alloc] initWithNetwork:YES];
    self.CDC = [[CommentDataController alloc] initWithNetwork:YES];

    // Act
    [self.PDC addToServer:post
                 intoList:self.PDC.topPostsAllColleges];
    
    Comment *comment = [[Comment alloc] initWithCommentMessage:@"Test Comment from testCommentDataControllerAddCommentToServer"
                                                      withPost:post];
    [self.CDC addToServer:comment intoList:self.CDC.list];
    
    // Assert
    
}


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
