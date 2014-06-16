//
//  DataController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "DataController.h"
#import "Models/Models/Model.h"
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

    }
    return self;
}

#pragma mark - Networker Access - Colleges

- (void)getNetworkCollegeList
{
    self.collegeList = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETAllColleges];
    [self parseData:data asClass:[College class] intoList:self.collegeList];
}

#pragma mark - Networker Access - Comments

- (BOOL)createComment:(Comment *)comment
{
    NSData *result = [Networker POSTCommentData:[comment toJSON]
                                     WithPostId:comment.postID];
    
    return [self parseData:result asClass:[Comment class] intoList:self.commentList];
}
- (void)fetchCommentsWithPostId:(long)postId
{
    self.commentList = [[NSMutableArray alloc] init];
    NSData *data = [Networker GETCommentsWithPostId:postId];
    [self parseData:data asClass:[Comment class] intoList:self.commentList];
}

#pragma mark - Networker Access - Posts

- (BOOL)createPost:(Post *)post
{
    NSData *result = [Networker POSTPostData:[post toJSON]
                               WithCollegeId:post.collegeID];
    
    [self parseData:result asClass:[Post class] intoList:self.topPostsAllColleges];
    return [self parseData:result asClass:[Post class] intoList:self.recentPostsAllColleges];
}
- (void)fetchTopPosts
{
    self.topPostsAllColleges = [[NSMutableArray alloc] init];
    NSData* data = [Networker GETAllPosts];
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
    NSData* data = [Networker GETAllPosts];
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
- (void)fetchUserPostsWithUserId:(long)userId
{
    [self setUserPostsAllColleges:[[NSMutableArray alloc] init]];
    
}
- (void)fetchUserPostsWithUserId:(long)userId
                   WithCollegeId:(long)collegeId
{
    [self setUserPostsInCollege:[[NSMutableArray alloc] init]];
    
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
    if ([vote.votableType isEqual: @"Comment"])
    {
        result = [Networker POSTVoteData:[vote toJSON] WithCommentId:vote.parentID];
    }
    else
    {
        result = [Networker POSTVoteData:[vote toJSON] WithPostId:vote.parentID];
    }
    return [self parseData:result asClass:[Vote class] intoList:self.commentList];
}

#pragma mark - Local Data Access

- (void)getHardCodedCollegeList
{   // Populate the college list with a recent
    // list of colleges instead of accessing the network
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CollegeList" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data == nil)
    {
        NSLog(@"Could not get hard-coded list in CollegeList.txt");
        return;
    }
    [self parseData:data asClass:[College class] intoList:self.collegeList];
}
- (NSArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon
{
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    
    double degreesForPermissions = MILES_FOR_PERMISSION / 50.0;	//roughly 50 miles per degree
    
    for (College *college in self.collegeList)
    {
        //TODO: change to formula that takes into account the roundness of the earth
        double degreesAway = sqrt(pow((userLat - college.lat), 2) + pow((userLon - college.lon), 2));
        
        if (degreesAway <= degreesForPermissions)
        {
            [colleges addObject:college];
        }
        
    }
    return colleges;
}

#pragma mark - Helper Methods

-(BOOL)parseData:(NSData *)data asClass:(Class)class intoList:(NSMutableArray *)array
{
    NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
    if (jsonArray != nil)
    {
        for (int i = 0; i < jsonArray.count; i++)
        {
            // Individual JSON object
            NSDictionary *jsonObject = (NSDictionary *) [jsonArray objectAtIndex:i];
            if ([College class] == class)
            {
                [array addObject:[College initFromJSON:jsonObject]];
            }
            if ([Comment class] == class)
            {
                [array addObject:[Comment initFromJSON:jsonObject]];
            }
            if ([Post class] == class)
            {
                [array addObject:[Post initFromJSON:jsonObject]];
            }
            if ([Tag class] == class)
            {
                [array addObject:[Tag initFromJSON:jsonObject]];
            }
            if ([Vote class] == class)
            {
                [array addObject:[Vote initFromJSON:jsonObject]];
            }
            
        }
        return YES;
    }
    return NO;
}
@end
