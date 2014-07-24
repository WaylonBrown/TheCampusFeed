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
        self.trendingColleges       = [[NSMutableArray alloc] init];
        self.userPosts              = [[NSMutableArray alloc] init];
        self.userComments           = [[NSMutableArray alloc] init];
        self.userVotes              = [[NSMutableArray alloc] init];
        self.userPostUpvotes        = [[NSMutableArray alloc] init];
        self.userPostDownvotes      = [[NSMutableArray alloc] init];
        self.userCommentUpvotes     = [[NSMutableArray alloc] init];
        self.userCommentDownvotes   = [[NSMutableArray alloc] init];
        
        [self setTopPostsPage:0];
        [self setRecentPostsPage:0];
        [self setTagPostsPage:0];
        [self setTrendingCollegesPage:0];
        
        // Populate the initial arrays
        [self fetchTopPosts];
        [self fetchNewPosts];
        // [self getHardCodedCollegeList];
        [self getTrendingCollegeList];
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
    self.collegeList = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETAllColleges];
    [self parseData:data asClass:[College class] intoList:self.collegeList];
    [self writeCollegesToFileWithData:data];
}
- (void)getTrendingCollegeList
{
    self.trendingColleges = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETTrendingCollegesAtPageNum:self.trendingCollegesPage++];
    [self parseData:data asClass:[College class] intoList:self.trendingColleges];
}

#pragma mark - Networker Access - Comments

- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post
{
    @try
    {
        Comment *comment = [[Comment alloc] initWithCommentMessage:message
                                                          withPost:post];
        NSData *result = [Networker POSTCommentData:[comment toJSON] WithPostId:post.postID];
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                   options:0
                                                                     error:nil];
        Comment *networkComment = [[Comment alloc] initFromJSON:jsonObject];
        
        [self.commentList insertObject:networkComment atIndex:0];
        [self.userComments insertObject:networkComment atIndex:0];
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
        NSData *result = [Networker POSTPostData:[post toJSON] WithCollegeId:post.collegeID];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                   options:0
                                                                     error:nil];
        Post *networkPost = [[Post alloc] initFromJSON:jsonObject];
        if (networkPost.collegeID == 0)
        {
            [networkPost setCollegeID:collegeId];
        }
        
        [self.topPostsAllColleges insertObject:networkPost atIndex:0];
        [self.recentPostsAllColleges insertObject:networkPost atIndex:0];
        [self.userPosts insertObject:networkPost atIndex:0];
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
- (Post *)fetchPostWithId:(long)postId
{
    NSArray *singleton = @[[NSString stringWithFormat:@"%ld", postId]];
    NSData *data = [Networker GETPostsWithIdArray:singleton];
    NSMutableArray *singlePostArray = [NSMutableArray new];
    [self parseData:data asClass:[Post class] intoList:singlePostArray];
    return singlePostArray.count ? [singlePostArray firstObject] : nil;
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
                               WithCommentId:vote.parentID
                                  WithPostId:vote.grandparentID];
        }
        else if (vote.votableType == POST)
        {
            result = [Networker POSTVoteData:[vote toJSON]
                                  WithPostId:vote.parentID];
        }
        if (result != nil)
        {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                       options:0
                                                                         error:nil];
            Vote *networkVote = [[Vote alloc] initFromJSON:jsonObject];
            
            if (networkVote.votableType == POST)
            {
                if (networkVote.upvote == true)
                {
                    [self.userPostUpvotes addObject:networkVote];
                }
                else
                {
                    [self.userPostDownvotes addObject:networkVote];
                }
            }
            else if (networkVote.votableType == COMMENT)
            {
                if (networkVote.upvote == true)
                {
                    [self.userCommentUpvotes addObject:networkVote];
                }
                else
                {
                    [self.userCommentDownvotes addObject:networkVote];
                }
            }
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
    if (collegeData == nil)
    {
        return nil;
    }
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:collegeData
                                                               options:0
                                                                 error:nil];
    
    College *college = [[College alloc] initFromJSON:jsonObject];
    [self.collegeList addObject:college];
    
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
    if (self.userPosts.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *postFile = [docDir stringByAppendingPathComponent: USER_POST_IDS_FILE];
        
        NSString *postIdsString = @"";
        for (Post *post in self.userPosts)
        {
            long postId = post.postID;
            postIdsString = [NSString stringWithFormat:@"%ld\n%@", postId, postIdsString];
        }
        
        NSData *postData = [postIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [postData writeToFile:postFile atomically:NO];
    }
}
- (void)saveUserComments
{
    if (self.userComments.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *commentFile = [docDir stringByAppendingPathComponent: USER_COMMENT_IDS_FILE];
        
        // Save Comment Ids
        NSString *commentIdsString = @"";
        for (Comment *comment in self.userComments)
        {
            long commentId = comment.commentID;
            commentIdsString = [NSString stringWithFormat:@"%ld\n%@", commentId, commentIdsString];
        }
        NSData *commentData = [commentIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [commentData writeToFile:commentFile atomically:NO];
    }
}
- (void)saveUserUpVotes
{
    if (self.userPostUpvotes.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *postFile = [docDir stringByAppendingPathComponent: USER_UPVOTE_POST_IDS_FILE];
        
        // Save Post Upvote Ids
        NSString *postIdsString = @"";
        for (Vote *vote in self.userPostUpvotes)
        {
            long postId = vote.parentID;
            postIdsString = [NSString stringWithFormat:@"%ld\n%@", postId, postIdsString];
        }
        NSData *postData = [postIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [postData writeToFile:postFile atomically:NO];
    }
    if (self.userCommentUpvotes.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *commentFile = [docDir stringByAppendingPathComponent: USER_UPVOTE_COMMENT_IDS_FILE];
        
        // Save Comment Upvote Ids
        NSString *commentIdsString = @"";
        for (Vote *vote in self.userCommentUpvotes)
        {
            long commentId = vote.parentID;
            commentIdsString = [NSString stringWithFormat:@"%ld\n%@", commentId, commentIdsString];
        }
        NSData *commentData = [commentIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [commentData writeToFile:commentFile atomically:NO];
    }
}
- (void)saveUserDownVotes
{
    if (self.userPostDownvotes.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *postFile = [docDir stringByAppendingPathComponent: USER_DOWNVOTE_POST_IDS_FILE];
        
        // Save Post Upvote Ids
        NSString *postIdsString = @"";
        for (Vote *vote in self.userPostDownvotes)
        {
            long postId = vote.parentID;
            postIdsString = [NSString stringWithFormat:@"%ld\n%@", postId, postIdsString];
        }
        NSData *postData = [postIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [postData writeToFile:postFile atomically:NO];
    }
    if (self.userCommentDownvotes.count > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex: 0];
        NSString *commentFile = [docDir stringByAppendingPathComponent: USER_DOWNVOTE_COMMENT_IDS_FILE];
        
        // Save Comment Upvote Ids
        NSString *commentIdsString = @"";
        for (Vote *vote in self.userCommentDownvotes)
        {
            long commentId = vote.parentID;
            commentIdsString = [NSString stringWithFormat:@"%ld\n%@", commentId, commentIdsString];
        }
        NSData *commentData = [commentIdsString dataUsingEncoding:NSUTF8StringEncoding];
        [commentData writeToFile:commentFile atomically:NO];
    }
}
- (void)saveUserVotes
{
    [self saveUserUpVotes];
    [self saveUserDownVotes];
}
- (void)saveAllUserData
{
    [self saveUserPosts];
    [self saveUserComments];
    [self saveUserVotes];
}
- (void)retrieveUserData
{
    NSArray *paths      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir    = [paths objectAtIndex: 0];
    
    NSString *postFile              = [docDir stringByAppendingPathComponent:USER_POST_IDS_FILE];
    NSString *commentFile           = [docDir stringByAppendingPathComponent:USER_COMMENT_IDS_FILE];
    NSString *postUpvoteFile        = [docDir stringByAppendingPathComponent:USER_UPVOTE_POST_IDS_FILE];
    NSString *postDownvoteFile      = [docDir stringByAppendingPathComponent:USER_DOWNVOTE_POST_IDS_FILE];
    NSString *commentUpvoteFile     = [docDir stringByAppendingPathComponent:USER_UPVOTE_COMMENT_IDS_FILE];
    NSString *commentDownvoteFile   = [docDir stringByAppendingPathComponent:USER_DOWNVOTE_COMMENT_IDS_FILE];
    
    // Retrieve Posts
    NSString *postsString = [NSString stringWithContentsOfFile:postFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *postIds = [postsString componentsSeparatedByString:@"\n"];
    [self fetchUserPostsWithIdArray:postIds];
    
    // Retrieve Comments
    NSString *commentsString = [NSString stringWithContentsOfFile:commentFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *commentIds = [commentsString componentsSeparatedByString:@"\n"];
    [self fetchUserCommentsWithIdArray:commentIds];
    
    // Retrieve Votes
    NSString *postUpvotesString      = [NSString stringWithContentsOfFile:postUpvoteFile encoding:NSUTF8StringEncoding error:nil];
    NSString *postDownvotesString    = [NSString stringWithContentsOfFile:postDownvoteFile encoding:NSUTF8StringEncoding error:nil];
    NSString *commentUpvotesString   = [NSString stringWithContentsOfFile:commentUpvoteFile encoding:NSUTF8StringEncoding error:nil];
    NSString *commentDownvotesString = [NSString stringWithContentsOfFile:commentDownvoteFile encoding:NSUTF8StringEncoding error:nil];
    
    [self setUserPostUpvotes:       (NSMutableArray *)[postUpvotesString componentsSeparatedByString:@"\n"]];
    [self setUserPostDownvotes:     (NSMutableArray *)[postDownvotesString componentsSeparatedByString:@"\n"]];
    [self setUserCommentUpvotes:    (NSMutableArray *)[commentUpvotesString componentsSeparatedByString:@"\n"]];
    [self setUserCommentDownvotes:  (NSMutableArray *)[commentDownvotesString componentsSeparatedByString:@"\n"]];
}
- (long)getUserPostScore
{
    long totalScore = 0;
    for (Post* post in self.userPosts)
    {
        totalScore += post.score;
    }
    return totalScore;
}
- (long)getUserCommentScore
{
    long totalScore = 0;
    for (Comment* comment in self.userComments)
    {
        totalScore += comment.score;
    }
    return totalScore;
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
