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

#import "DataController.h"

@interface DataControllerTests : XCTestCase

@property (strong, nonatomic) DataController *controller;

@end

@implementation DataControllerTests

- (void)setUp
{   // NOT called by default
    [super setUp];
    self.controller = [DataController new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchNewCollegeList
{
    [self setUp];
    [self.controller getNetworkCollegeList];
    [self.controller.collegeList removeAllObjects];
    [self.controller getHardCodedCollegeList];
}

@end
