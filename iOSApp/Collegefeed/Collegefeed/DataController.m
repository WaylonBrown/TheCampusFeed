//
//  DataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"
#import "College.h"
#import "Comment.h"
#import "Post.h"
#import "Tag.h"
#import "Vote.h"
#import "Networker.h"

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
        self.userPosts              = [[NSMutableArray alloc] init];
        self.userComments           = [[NSMutableArray alloc] init];
        self.userVotes              = [[NSMutableArray alloc] init];
        
        [self setTopPostsPage:0];
        [self setRecentPostsPage:0];
        
        // Populate the initial arrays
        [self fetchTopPosts];
        [self fetchNewPosts];
//        [self getHardCodedCollegeList];
        [self getNetworkCollegeList];
        [self fetchAllTags];
        [self retrieveUserData];
        
        // Get the user's location
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDelegate:self];
        if ([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
            [self.locationManager startUpdatingLocation];
        }
        
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
        [self.commentList insertObject:comment atIndex:0];
        [self.userComments insertObject:comment atIndex:0];
        [self saveUserComments];
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
- (void)fetchUserCommentsWithIdArray:(NSArray *)commentIds
{
    [self setUserComments:[NSMutableArray new]];
    NSData *data = [Networker GETCommentsWithIdArray:commentIds];
    [self parseData:data asClass:[Comment class] intoList:self.userComments];
}

#pragma mark - Networker Access - Flags

- (BOOL)flagPost:(long)postId
{
    @try
    {
        [Networker POSTFlagPost:postId];
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
    return NO;
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
        [self.userPosts insertObject:post atIndex:0];
        [self saveUserPosts];
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
    NSData* data = [Networker GETTrendingPostsAtPageNum:self.topPostsPage++];
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
    NSData* data = [Networker GETRecentPostsAtPageNum:self.recentPostsPage++];
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
    [self setTagPostsPage:0];
    [self setAllPostsWithTag:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETAllPostsWithTag:tagMessage atPageNum:self.tagPostsPage];
    [self parseData:data asClass:[Post class] intoList:self.allPostsWithTag];
}
- (void)fetchAllPostsWithTagMessage:(NSString*)tagMessage
                      withCollegeId:(long)collegeId
{
    [self setAllPostsWithTagInCollege:[[NSMutableArray alloc] init]];
    NSData* data = [Networker GETPostsWithTagName:tagMessage withCollegeId:collegeId];
    [self parseData:data asClass:[Post class] intoList:self.allPostsWithTagInCollege];
}
- (BOOL)fetchMorePostsWithTagMessage:(NSString*)tagMessage
{
    self.tagPostsPage++;
    NSData* data = [Networker GETAllPostsWithTag:tagMessage atPageNum:self.tagPostsPage];
    return [self parseData:data asClass:[Post class] intoList:self.allPostsWithTag];
}
- (void)fetchUserPostsWithIdArray:(NSArray *)postIds
{
    [self setUserPosts:[NSMutableArray new]];
    NSData *data = [Networker GETPostsWithIdArray:postIds];
    [self parseData:data asClass:[Post class] intoList:self.userPosts];
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
    NSData *data = [Networker GETTagsWithCollegeId:collegeId];
    [self parseData:data asClass:[Tag class] intoList:self.allTagsInCollege];
}

#pragma mark - Networker Access - Votes

- (BOOL)createVote:(Vote *)vote
{
    @try
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
        [self saveUserVotes];
        return YES;
    }
    @catch (NSException *exception)
    {
        return NO;
    }
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
    College *college = [self getCollegeById:Id];
    return college == nil ? @"" : college.name;
}
- (College *)getCollegeById:(long)Id
{
    for (College *college in self.collegeList)
    {
        if (college.collegeID == Id)
        {
            return college;
        }
    }
    
    NSData *collegeData = [Networker GETCollegeWithId:Id];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:collegeData
                                                               options:0
                                                                 error:nil];
    
    College *college = [[College alloc] initFromJSON:jsonObject];
    if (college != nil)
    {
        [self.collegeList addObject:college];
    }
    
    return college;
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
- (BOOL)isNearCollegeWithId:(long)collegeId
{
    College *college = [self getCollegeById:collegeId];
    return [self.nearbyColleges containsObject:college];
}
- (void)saveUserPosts
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *postFile = [docDir stringByAppendingPathComponent: @"UserPostIds.txt"];
    
    // TODO: consider saving the whole JSON posts for quicker retrieval later
    // Save Post Ids
    NSString *postIdsString = @"";
    for (Post *post in self.userPosts)
    {
        long postId = post.postID;
        postIdsString = [NSString stringWithFormat:@"%ld\n%@",postId, postIdsString];
    }
    NSData *postData = [postIdsString dataUsingEncoding:NSUTF8StringEncoding];
    [postData writeToFile:postFile atomically:NO];
}
- (void)saveUserComments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *commentFile = [docDir stringByAppendingPathComponent: @"UserCommentIds.txt"];
    
    // Save Comment Ids
    NSString *commentIdsString = @"";
    for (Comment *comment in self.userComments)
    {
        long commentId = comment.commentID;
        commentIdsString = [NSString stringWithFormat:@"%@\n%ld", commentIdsString, commentId];
    }
    NSData *commentData = [commentIdsString dataUsingEncoding:NSUTF8StringEncoding];
    [commentData writeToFile:commentFile atomically:NO];

}
- (void)saveUserVotes
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *voteFile = [docDir stringByAppendingPathComponent: @"UserVoteIds.txt"];
    
    // Save full Votes
    NSString *votesString = @"";
    int numVotes = self.userVotes.count;
    for (int i = 0; i < numVotes; i++)
    {
        Vote *vote = [self.userVotes objectAtIndex:i];
        NSString *singleVoteString = [NSString stringWithUTF8String:[[vote toJSON] bytes]];
        if (i == 0)
        {
            votesString = [NSString stringWithFormat:@"[%@,", singleVoteString];
        }
        else if (i == numVotes - 1)
        {
            votesString = [NSString stringWithFormat:@"%@%@]", votesString, singleVoteString];
        }
        else
        {
            votesString = [NSString stringWithFormat:@"%@%@,", votesString, singleVoteString];
        }
    }
    NSData *voteData = [votesString dataUsingEncoding:NSUTF8StringEncoding];
    [voteData writeToFile:voteFile atomically:NO];

}
- (void)saveAllUserData
{
    [self saveUserPosts];
    [self saveUserComments];
    [self saveUserVotes];
}
- (void)retrieveUserData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *postFile = [docDir stringByAppendingPathComponent: @"UserPostIds.txt"];
    NSString *commentFile = [docDir stringByAppendingPathComponent: @"UserCommentIds.txt"];
    NSString *voteFile = [docDir stringByAppendingPathComponent: @"UserVoteIds.txt"];
    
    // Retrieve Posts
    NSString *postsString = [NSString stringWithContentsOfFile:postFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *postIds = [postsString componentsSeparatedByString: @"\n"];
    [self fetchUserPostsWithIdArray:postIds];
    
    // Retrieve Comments
    NSString *commentsString = [NSString stringWithContentsOfFile:commentFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *commentIds = [commentsString componentsSeparatedByString: @"\n"];
    [self fetchUserCommentsWithIdArray:commentIds];
    
    // Retrieve Votes
    NSData *voteData = [NSData dataWithContentsOfFile:voteFile];
    [self parseData:voteData asClass:[Vote class] intoList:self.userVotes];
}

#pragma mark - Helper Methods

-(BOOL)parseData:(NSData *)data asClass:(Class)class intoList:(NSMutableArray *)array
{
    if (data == nil)
    {
        return NO;
    }
    if (array == nil)
    {
        array = [[NSMutableArray alloc] init];
    }
    NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
    if (jsonArray != nil)
    {
        if (jsonArray.count == 0)
        {
            return NO;
        }
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonObject = (NSDictionary *) [jsonArray objectAtIndex:i];
            NSObject *object = [[class alloc] initFromJSON:jsonObject];
            if (![array containsObject:object])
            {
                [array addObject:object];
            }
            
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
