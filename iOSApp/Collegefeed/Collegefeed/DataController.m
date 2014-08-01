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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
        self.userPostVotes          = [[NSMutableArray alloc] init];
        self.userCommentVotes       = [[NSMutableArray alloc] init];

        
        [self setTopPostsPage:0];
        [self setRecentPostsPage:0];
        [self setTagPostsPage:0];
        [self setTrendingCollegesPage:0];
        
//        [self getNetworkCollegeList];
        [self getHardCodedCollegeList];
        
        // Populate the initial arrays
        [self retrieveUserData];

        [self fetchTopPosts];
        [self fetchNewPosts];
        [self getTrendingCollegeList];
        [self fetchAllTags];
        
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
    [self writeCollegestoCoreData];
//    [self writeCollegesToFileWithData:data];
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
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:PERMISSION_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedPermissions = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedPermissions.count > 1)
    {
        NSLog(@"Too many permissions");
        return NO;
    }
    NSManagedObject *permission = [fetchedPermissions firstObject];
    NSDate *lastComment = [permission valueForKey:KEY_COMMENT_TIME];
    if (lastComment != nil)
    {
        NSTimeInterval diff = [lastComment timeIntervalSinceNow];
        float minSeconds = MINIMUM_COMMENTING_INTERVAL_MINUTES * 60;
        if (abs(diff) < minSeconds)
        {
            // TODO: toast message
            return NO;
        }
    }
    

    @try
    {
        Comment *comment = [[Comment alloc] initWithCommentMessage:message
                                                          withPost:post];
        NSData *result = [Networker POSTCommentData:[comment toJSON] WithPostId:post.postID];
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                   options:0
                                                                     error:nil];
        Comment *networkComment = [[Comment alloc] initFromJSON:jsonObject];
        
        NSDate *commentTime = [networkComment getCreatedAt];
        if (permission == nil)
        {
            permission = [NSEntityDescription insertNewObjectForEntityForName:PERMISSION_ENTITY
                                                       inManagedObjectContext:context];
        }
        [permission setValue:commentTime forKeyPath:KEY_COMMENT_TIME];
        if (![_managedObjectContext save:&error])
        {
            NSLog(@"Failed to save user's comment time: %@",
                  [error localizedDescription]);
        }

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
                withUserToken:(NSString *)userToken
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:PERMISSION_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedPermissions = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedPermissions.count > 1)
    {
        NSLog(@"Too many permissions");
        return NO;
    }
    NSManagedObject *permission = [fetchedPermissions firstObject];
    NSDate *lastPost = [permission valueForKey:KEY_POST_TIME];
    if (lastPost != nil)
    {
        NSTimeInterval diff = [lastPost timeIntervalSinceNow];
        float minSeconds = MINIMUM_POSTING_INTERVAL_MINUTES * 60;
        if (abs(diff) < minSeconds)
        {
            // TODO: toast message
            return NO;
        }
    }
    
    @try
    {
        Post *post = [[Post alloc] initWithMessage:message
                                     withCollegeId:collegeId
                                     withUserToken:userToken];
        NSData *result = [Networker POSTPostData:[post toJSON] WithCollegeId:post.collegeID];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                   options:0
                                                                     error:nil];
        Post *networkPost = [[Post alloc] initFromJSON:jsonObject];
        if (networkPost.collegeID == 0)
        {
            [networkPost setCollegeID:collegeId];
        }
        NSDate *postTime = [networkPost getCreatedAt];
        if (permission == nil)
        {
            permission = [NSEntityDescription insertNewObjectForEntityForName:PERMISSION_ENTITY
                                                                  inManagedObjectContext:context];
        }
        [permission setValue:postTime forKeyPath:KEY_POST_TIME];
        if (![_managedObjectContext save:&error])
        {
            NSLog(@"Failed to save user's post time: %@",
                  [error localizedDescription]);
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
- (void)fetchTopPostsInCollege
{
    self.topPostsInCollege = [[NSMutableArray alloc] init];
    long collegeId = self.collegeInFocus.collegeID;
    NSData* data = [Networker GETTrendingPostsWithCollegeId:collegeId];
    [self parseData:data asClass:[Post class] intoList:self.topPostsInCollege];
}
- (void)fetchNewPosts
{
    NSData* data = [Networker GETRecentPostsAtPageNum:self.recentPostsPage++];
    [self parseData:data asClass:[Post class] intoList:self.recentPostsAllColleges];
}
- (void)fetchNewPostsInCollege
{
    [self setRecentPostsInCollege:[[NSMutableArray alloc] init]];
    long collegeId = self.collegeInFocus.collegeID;
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
- (void)fetchAllPostsInCollegeWithTagMessage:(NSString *)tagMessage
{
    [self setAllPostsWithTagInCollege:[[NSMutableArray alloc] init]];
    long collegeId = self.collegeInFocus.collegeID;
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
            vote = [vote initFromJSON:jsonObject];
            
            // When a vote is cast, add it to the appropriate user's vote list
            if (vote.votableType == POST)
            {
                [self.userPostVotes addObject:vote];
            }
            else if (vote.votableType == COMMENT)
            {
                [self.userCommentVotes addObject:vote];
            }
        }
        [self saveUserVotes];
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception thrown in DataController.createVote: %@", [exception description]);
        return NO;
    }
}
- (BOOL)cancelVote:(Vote *)vote
{
    long voteId = vote.voteID;
    BOOL success = [Networker DELETEVoteId:voteId];
    if (success)
    {
        if (vote.votableType == POST)
        {
            [self.userPostVotes removeObject:vote];
        }
        else if (vote.votableType == COMMENT)
        {
            [self.userCommentVotes removeObject:vote];
        }
    }
    
    [self saveUserVotes];
    return success;
}

#pragma mark - Local Data Access

- (void)writeCollegestoCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COLLEGE_ENTITY
                                              inManagedObjectContext:context];
    
    
    [fetchRequest setEntity:entity];
    
//    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
//    for (NSManagedObject *oldCollege in myObjectsToDelete)
//    {
//        [context deleteObject:oldCollege];
//    }
    
    for (College *collegeModel in self.collegeList)
    {
        NSManagedObject *college = [NSEntityDescription insertNewObjectForEntityForName:COLLEGE_ENTITY
                                                              inManagedObjectContext:context];
        [college setValue:[NSNumber numberWithLong:collegeModel.collegeID] forKeyPath:KEY_COLLEGE_ID];
        [college setValue:[NSNumber numberWithFloat:collegeModel.lat] forKeyPath:KEY_LAT];
        [college setValue:[NSNumber numberWithFloat:collegeModel.lon] forKeyPath:KEY_LON];
        [college setValue:collegeModel.name forKeyPath:KEY_NAME];
        [college setValue:collegeModel.shortName forKeyPath:KEY_SHORT_NAME];
    }
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user's post votes: %@",
              [error localizedDescription]);
    }
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
    
    NSError *error;
    // Retrieve Votes
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:COLLEGE_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedVotes = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *vote in fetchedVotes)
    {
        long collegeId = [[vote valueForKey:KEY_COLLEGE_ID] longValue];
        float lon = [[vote valueForKey:KEY_LON] floatValue];
        float lat = [[vote valueForKey:KEY_LAT] floatValue];
        NSString *name = [vote valueForKey:KEY_NAME];
//        NSString *shortName = [vote valueForKey:KEY_SHORT_NAME];
        
        College *collegeModel = [[College alloc] initWithCollegeID:collegeId withName:name withLat:lat withLon:lon];
        [self.collegeList addObject:collegeModel];
    }
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
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        for (Post *postModel in self.userPosts)
        {
            NSManagedObject *post = [NSEntityDescription insertNewObjectForEntityForName:POST_ENTITY
                                                                  inManagedObjectContext:context];
            [post setValue:[NSNumber numberWithLong:postModel.postID] forKeyPath:KEY_POST_ID];
        }
        if (![_managedObjectContext save:&error])
        {
            NSLog(@"Failed to save user's posts: %@",
                  [error localizedDescription]);
        }
    }
}
- (void)retrieveUserPosts
{
    // Retrieve Posts
    NSMutableArray *postIds = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:POST_ENTITY inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedPosts = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *post in fetchedPosts)
    {
        NSNumber *postId = [post valueForKey:KEY_POST_ID];
        [postIds addObject:postId];
    }
    [self fetchUserPostsWithIdArray:postIds];
}
- (void)saveUserComments
{
    if (self.userComments.count > 0)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSError *error;
        for (Comment *commentModel in self.userComments)
        {
            NSManagedObject *comment = [NSEntityDescription insertNewObjectForEntityForName:COMMENT_ENTITY
                                                                  inManagedObjectContext:context];
            [comment setValue:[NSNumber numberWithLong:commentModel.commentID] forKeyPath:KEY_COMMENT_ID];
        }
        if (![_managedObjectContext save:&error])
        {
            NSLog(@"Failed to save user's comments: %@",
                  [error localizedDescription]);
        }
    }
}
- (void)retrieveUserComments
{
    // Retrieve Comments
    NSMutableArray *commentIds = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:COMMENT_ENTITY inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedComments = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *comment in fetchedComments)
    {
        NSNumber *commentId = [comment valueForKey:KEY_COMMENT_ID];
        [commentIds addObject:commentId];
    }
    [self fetchUserCommentsWithIdArray:commentIds];
}
- (void)saveUserPostVotes
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    for (Vote *voteModel in self.userPostVotes)
    {
        NSManagedObject *vote = [NSEntityDescription insertNewObjectForEntityForName:VOTE_ENTITY
                                                              inManagedObjectContext:context];
        [vote setValue:[NSNumber numberWithLong:voteModel.parentID] forKeyPath:KEY_PARENT_ID];
        [vote setValue:[NSNumber numberWithLong:voteModel.voteID] forKeyPath:KEY_VOTE_ID];
        [vote setValue:VALUE_POST forKeyPath:KEY_TYPE];
        [vote setValue:[NSNumber numberWithBool:voteModel.upvote] forKeyPath:KEY_UPVOTE];
    }
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user's post votes: %@",
              [error localizedDescription]);
    }
}
- (void)saveUserCommentVotes
{
    NSManagedObjectContext *context = [self managedObjectContext];

    NSError *error;
    for (Vote *voteModel in self.userCommentVotes)
    {
        NSManagedObject *vote = [NSEntityDescription insertNewObjectForEntityForName:VOTE_ENTITY
                                                              inManagedObjectContext:context];
        [vote setValue:[NSNumber numberWithLong:voteModel.parentID] forKeyPath:KEY_PARENT_ID];
        [vote setValue:[NSNumber numberWithLong:voteModel.voteID] forKeyPath:KEY_VOTE_ID];
        [vote setValue:VALUE_COMMENT forKeyPath:KEY_TYPE];
        [vote setValue:[NSNumber numberWithBool:voteModel.upvote] forKeyPath:KEY_UPVOTE];
    }
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user's comment votes: %@",
              [error localizedDescription]);
    }
}
- (void)saveUserVotes
{
    [self saveUserPostVotes];
    [self saveUserCommentVotes];
}
- (void)retrieveUserVotes
{
    // Retrieve Votes
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:VOTE_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedVotes = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *vote in fetchedVotes)
    {
        long voteId = [[vote valueForKey:KEY_VOTE_ID] longValue];
        long parentId = [[vote valueForKey:KEY_PARENT_ID] longValue];
        bool upvote = [[vote valueForKey:KEY_UPVOTE] boolValue];
        NSString *type = [vote valueForKey:KEY_TYPE];
        
        ModelType modelType;
        if ([type isEqual:@"Post"]) modelType = POST;
        else if ([type isEqual:@"Comment"]) modelType = COMMENT;
        else continue;
        
        Vote *voteModel = [[Vote alloc] initWithVoteId:voteId
                                          WithParentId:parentId
                                       WithUpvoteValue:upvote
                                         AsVotableType:modelType];
        
        if ([voteModel getType] == POST)
        {
            [self.userPostVotes addObject:voteModel];
        }
        else if ([voteModel getType] == COMMENT)
        {
            [self.userCommentVotes addObject:voteModel];
        }
    }
}
- (void)saveAllUserData
{
    [self saveUserPosts];
    [self saveUserComments];
    [self saveUserVotes];
}
- (void)retrieveUserData
{
    [self retrieveUserVotes];
    [self retrieveUserPosts];
    [self retrieveUserComments];
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
            NSObject *object;
            
            if ([Post class] == class)
            {
                Post *post = [[Post alloc] initFromJSON:jsonObject];
                long postID = [post getID];
                long collegeID = [post getCollegeID];
                College *college = [self getCollegeById:collegeID];
                [post setCollegeName:college.name];
                object = post;
                for (Vote *vote in self.userPostVotes)
                {
                    if (vote.parentID == postID)
                    {
                        [post setVote:vote];
                        break;
                    }
                }
            }
            else if ([Comment class] == class)
            {
                Comment *comment = [[Comment alloc] initFromJSON:jsonObject];
                long commentID = [comment getID];
                object = comment;
                for (Vote *vote in self.userCommentVotes)
                {
                    if (vote.parentID == commentID)
                    {
                        [comment setVote:vote];
                        break;
                    }
                }
            }
            else
            {   // college or tag
                object = [[class alloc] initFromJSON:jsonObject];
            }
            
            
            if (object != nil && ![array containsObject:object])
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (void) deleteAllObjects
{
    NSArray *stores = [_persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores)
    {
        [_persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
