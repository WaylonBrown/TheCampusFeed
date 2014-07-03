//
//  DataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"
#import "Models/Models/College.h"
#import "Models/Models/Comment.h"
#import "Models/Models/Post.h"
#import "Models/Models/Tag.h"
#import "Models/Models/Vote.h"
#import "Networker/Networker/Networker.h"

@implementation DataController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setShowingAllColleges:YES];
        [self setShowingSingleCollege:NO];
        
        // Initialize arrays for the initial arrays needed
        self.topPostsAllColleges    = [[NSMutableArray alloc] init];
        self.recentPostsAllColleges = [[NSMutableArray alloc] init];
        self.collegeList            = [[NSMutableArray alloc] init];
        self.allTags                = [[NSMutableArray alloc] init];
        
        // Populate the initial arrays
        [self fetchTopPosts];
        [self fetchNewPosts];
//        [self getHardCodedCollegeList];
        [self getNetworkCollegeList];
        [self fetchAllTags];
        
        // Get the user's location
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        [self.locationManager startUpdatingLocation];
        
    }
    return self;
}

#pragma mark - Networker Access - Colleges

- (void)getNetworkCollegeList
{
    // TODO: most recently, this only gets first 25 colleges
    self.collegeList = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETAllColleges];
    [self parseData:data asClass:[College class] intoList:self.collegeList];
    [self writeCollegesToFileWithData:data];
}

#pragma mark - Networker Access - Comments

- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post
{
    @try
    {
        Comment *comment = [[Comment alloc] initWithCommentMessage:message
                                                          withPost:post];
        [Networker POSTCommentData:[comment toJSON] WithPostId:post.postID];
        [self.commentList  insertObject:comment atIndex:0];
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
    return NO;
}
- (void)fetchCommentsWithPostId:(long)postId
{
    self.commentList = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETCommentsWithPostId:postId];
    [self parseData:data asClass:[Comment class] intoList:self.commentList];
}

#pragma mark - Networker Access - Posts

- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId
{
    @try
    {
        Post *post = [[Post alloc] initWithMessage:message
                                     withCollegeId:collegeId];
        [Networker POSTPostData:[post toJSON] WithCollegeId:post.collegeID];
        [self.topPostsAllColleges insertObject:post atIndex:0];
        [self.recentPostsAllColleges insertObject:post atIndex:0];
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
    return NO;
}
- (void)fetchTopPosts
{
    self.topPostsAllColleges = [[NSMutableArray alloc] init];
    NSData* data = [Networker GETTrendingPosts];
    [self parseData:data asClass:[Post class] intoList:self.topPostsAllColleges];
}
- (void)fetchTopPostsWithCollegeId:(long)collegeId
{
    self.topPostsInCollege = [[NSMutableArray alloc] init];
    NSData* data = [Networker GETTrendingPostsWithCollegeId:collegeId];
    [self parseData:data asClass:[Post class] intoList:self.topPostsInCollege];
}
- (void)fetchNewPosts
{
    [self setRecentPostsAllColleges:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETRecentPosts];
    [self parseData:data asClass:[Post class] intoList:self.recentPostsAllColleges];
}
- (void)fetchNewPostsWithCollegeId:(long)collegeId
{
    [self setRecentPostsInCollege:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETRecentPostsWithCollegeId:collegeId];
    [self parseData:data asClass:[Post class] intoList:self.recentPostsInCollege];
}
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
{
    [self setAllPostsWithTag:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETPostsWithTagName:tagMessage];
    [self parseData:data asClass:[Post class] intoList:self.allPostsWithTag];
}
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
                      withCollegeId:(long)collegeId
{
    [self setAllPostsWithTagInCollege:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETPostsWithTagName:tagMessage withCollegeId:collegeId];
    [self parseData:data asClass:[Post class] intoList:self.allPostsWithTagInCollege];
}

#pragma mark - Networker Access - Tags

- (void)fetchAllTags
{   // fetch tags trending across all colleges
    self.allTags = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETTagsTrending];
    [self parseData:data asClass:[Tag class] intoList:self.allTags];
}
- (void)fetchAllTagsWithCollegeId:(long)collegeId
{   // fetch tags trending in a particular college
    self.allTagsInCollege = [[NSMutableArray alloc] init];
    //TODO: need a url to get all trending tags for a school, but waiting on a server endpoint
    NSData *data = [Networker GETTagsTrending];
    [self parseData:data asClass:[Tag class] intoList:self.allTagsInCollege];
}


#pragma mark - Networker Access - Votes

- (BOOL)createVote:(Vote *)vote
{
    NSData *result;
    if (vote.votableType == COMMENT)
    {
        result = [Networker POSTVoteData:[vote toJSON]
                           WithCommentId:vote.parentID];
    }
    else if (vote.votableType == POST)
    {
        result = [Networker POSTVoteData:[vote toJSON]
                              WithPostId:vote.parentID];
    }
    return YES;
}

#pragma mark - Local Data Access

- (void)writeCollegesToFileWithData:(NSData *)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent: @"NewCollegeList.txt"];
    
    [data writeToFile:docFile atomically: NO];
}
- (NSString *)getCollegeNameById:(long)Id
{
    for (College *college in self.collegeList)
    {
        if (college.collegeID == Id)
        {
            return college.name;
        }
    }
    
    NSData *collegeData = [Networker GETCollegeWithId:Id];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:collegeData
                                                               options:0
                                                                 error:nil];

    College *college = [[College alloc] initFromJSON:jsonObject];
    [self.collegeList addObject:college];
    
    return (college == nil) ? @"" : college.name;
}
- (void)getHardCodedCollegeList
{   // Populate the college list with a recent
    // list of colleges instead of accessing the network
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent: @"NewCollegeList.txt"];
    NSData *data = [NSData dataWithContentsOfFile:docFile];
    
    if (data == nil)
    {
        NSLog(@"Could not get hard-coded list in CollegeList.txt");
        return;
    }
    self.collegeList = [[NSMutableArray alloc] init];
    [self parseData:data asClass:[College class] intoList:self.collegeList];
}
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon
{
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    
    for (College *college in self.collegeList)
    {
        double milesAway = [self numberMilesAwayFromLat:userLat fromLon:userLon AtLat:college.lat atLon:college.lon];
        
        if (milesAway <= MILES_FOR_PERMISSION)
        {
            [colleges addObject:college];
        }
    }
    return colleges;
}
- (void)switchedToSpecificCollegeOrNil:(College *)college
{
    [self setCollegeInFocus:college];
    
    if (college == nil)
    {
        [self setShowingAllColleges:YES];
        [self setShowingSingleCollege:NO];
    }
    else
    {
        [self setShowingAllColleges:NO];
        [self setShowingSingleCollege:YES];
    }
}
- (BOOL)isNearCollege
{
    return self.nearbyColleges.count > 0;
}
- (void)retrieveUserData
{
    // Retrieve Posts
    [self setUserPosts:[[NSMutableArray alloc] init]];
    NSString *postsFilePath = [[NSBundle mainBundle] pathForResource:@"UserPosts" ofType:@"txt"];
    NSData *postsData = [NSData dataWithContentsOfFile:postsFilePath];
    if (postsData == nil)
    {
        NSLog(@"Could not get hard-coded list in UserPosts.txt");
    }
    [self parseData:postsData asClass:[Post class] intoList:self.userPosts];
    
    // Retrieve Comments
    [self setUserComments:[[NSMutableArray alloc] init]];
    NSString *commentsFilePath = [[NSBundle mainBundle] pathForResource:@"UserComments" ofType:@"txt"];
    NSData *commentsData = [NSData dataWithContentsOfFile:commentsFilePath];
    if (commentsData == nil)
    {
        NSLog(@"Could not get hard-coded list in UserComments.txt");
    }
    [self parseData:commentsData asClass:[Comment class] intoList:self.userComments];
    
    // Retrieve Votes
    [self setUserVotes:[[NSMutableArray alloc] init]];
    NSString *votesFilePath = [[NSBundle mainBundle] pathForResource:@"UserVotes" ofType:@"txt"];
    NSData *votesData = [NSData dataWithContentsOfFile:votesFilePath];
    if (votesData == nil)
    {
        NSLog(@"Could not get hard-coded list in UserVotes.txt");
    }
    [self parseData:votesData asClass:[Vote class] intoList:self.userVotes];
}

#pragma mark - Helper Methods

-(BOOL)parseData:(NSData *)data asClass:(Class)class intoList:(NSMutableArray *)array
{
    if (array == nil)
    {
        array = [[NSMutableArray alloc] init];
    }
    NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
    if (jsonArray != nil)
    {
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonObject = (NSDictionary *) [jsonArray objectAtIndex:i];
            [array addObject:[[class alloc] initFromJSON:jsonObject]];
        }
        return YES;
    }
    return NO;
}
- (void)findNearbyColleges
{   // Populate the nearbyColleges array appropriately using current location
    self.nearbyColleges = [NSMutableArray new];
    [self setNearbyColleges:[self findNearbyCollegesWithLat:self.lat
                                                    withLon:self.lon]];
    
}
- (float)numberMilesAwayFromLat:(float)collegeLat fromLon:(float)collegeLon AtLat:(float)userLat atLon:(float)userLon
{   // Implemented using Haversine formula
    double lat1 = userLat;
    double lon1 = userLon;
    double lat2 = collegeLat;
    double lon2 = collegeLon;
    double latDistance = [self toRad:(lat2-lat1)];
    double lonDistance = [self toRad:(lon2-lon1)];
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
    cos([self toRad:lat1]) * cos([self toRad:lat2]) *
    sin(lonDistance / 2) * sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    return (EARTH_RADIUS_MILES * c);
}

- (float)toRad:(float)value
{   // Helper method for milesAway
    return value * PI_VALUE / 180;
}

#pragma mark - CLLocationManager Delegate Functions

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!self.foundLocation)
    {
        [self setLat:newLocation.coordinate.latitude];
        [self setLon:newLocation.coordinate.longitude];
        [self.locationManager stopUpdatingLocation];
        
        [self findNearbyColleges];
        [self.appDelegate foundLocation];
        [self setFoundLocation:YES];
    }
    else
    {
        [self.locationManager stopUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.appDelegate didNotFindLocation];
    [self setFoundLocation:NO];
}


@end
