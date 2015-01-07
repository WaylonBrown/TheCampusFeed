//
//  DataController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "DataController.h"
#import "College.h"
#import "Comment.h"
#import "CFModelProtocol.h"
#import "Post.h"
#import "Tag.h"
#import "Vote.h"
#import "Networker.h"
#import "SwitchHomeCollegeDialogView.h"
#import "ToastController.h"
#import "Watchdog.h"

#import "TheCampusFeed-Swift.h"

@interface DataController()

@end

@implementation DataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        [self checkAppVersionNumber];
        [self initArrays];
        
        [self restoreAllCoreData];
        
        self.toaster = [ToastController new];
        
        // For restricting phone numbers and email addresses
        [self createWatchdog];
        
        NSLog(@"Updating launch count from %ld to %ld", self.launchCount++, self.launchCount);
        
        // Get the user's location
        [self findUserLocation];
        
        [self saveStatusToCoreData];
    }
    return self;
}
- (void)initArrays
{
    self.achievementList = [[NSMutableArray alloc] init];
 
    self.collegeList = [[NSMutableArray alloc] init];
    self.nearbyColleges = [[NSMutableArray alloc] init];
    self.trendingColleges = [[NSMutableArray alloc] init];
    
    self.commentList = [[NSMutableArray alloc] init];
    self.userComments = [[NSMutableArray alloc] init];
    
    self.topPostsAllColleges = [[NSMutableArray alloc] init];
    self.recentPostsAllColleges = [[NSMutableArray alloc] init];
    self.postsWithTagAllColleges = [[NSMutableArray alloc] init];
    self.topPostsSingleCollege = [[NSMutableArray alloc] init];
    self.recentPostsSingleCollege = [[NSMutableArray alloc] init];
    self.postsWithTagSingleCollege = [[NSMutableArray alloc] init];
    self.userPosts = [[NSMutableArray alloc] init];
    
    self.trendingTagsAllColleges = [[NSMutableArray alloc] init];
    self.trendingTagsSingleCollege = [[NSMutableArray alloc] init];
    
    self.userPostVotes = [[NSMutableArray alloc] init];
    self.userCommentVotes = [[NSMutableArray alloc] init];
}

#pragma mark - Achievements

- (void)didViewAchievements
{
    bool hasFoundExistingMatch = NO;
    bool shouldAssignTimeCrunchHours = NO;
    
    if (self.achievementList == nil || self.achievementList.count == 0)
    {
        [self restoreAchievementsFromCoreData];
    }
    
    for (Achievement *a in self.achievementList)
    {
        if (!hasFoundExistingMatch && [a.type isEqualToString:VALUE_VIEW_ACHIEVEMENT])
        {
            hasFoundExistingMatch = true;
            if (!a.hasAchieved)
            {
                NSLog(@"Setting existing view achievement to be completed");
                a.hasAchieved = YES;
                shouldAssignTimeCrunchHours = YES;
            }
            else
            {
                NSLog(@"View achievement found and has already been completed");
            }
            
            break;
        }
    }
    
    if (!hasFoundExistingMatch)
    {
        NSLog(@"Did not find existing view achievement. Adding a new one");

        Achievement *achievement = [[Achievement alloc] initWithId:VIEW_ACHIEVEMENT_ID
                                                        currAmount:1
                                                            reqAmt:1
                                                       rewardHours:HOURS_FOR_VIEW_ACHIEVEMENT
                                                   achievementType:VALUE_VIEW_ACHIEVEMENT
                                                        didAchieve:YES];
        [self.achievementList addObject:achievement];
        
        shouldAssignTimeCrunchHours = YES;
    }
    
    [self saveAchievementsToCoreData];
    NSLog(@"Finished saving View achievement");
    
    if (shouldAssignTimeCrunchHours)
    {
        [self addTimeCrunchHours:HOURS_FOR_VIEW_ACHIEVEMENT];
    }
    
}
- (void)tryAchievementScoreCountWithScore:(long)score
{
    NSLog(@"Checking if total score count of %ld earns any new achievements", score);
    for (Achievement *achievement in self.achievementList)
    {
        if (achievement.hasAchieved == NO
            && [achievement.type isEqualToString:VALUE_SCORE_ACHIEVEMENT]
            && achievement.amountRequired <= score)
        {
            NSLog(@"Found and awarding an unachieved score count Achievement");
            achievement.hasAchieved = YES;
            
            [self addTimeCrunchHours:achievement.hoursForReward];
        }
    }
    
    [self saveAchievementsToCoreData];
}
- (void)tryAchievementPostCountWithOldCount:(long)oldCount toNewCount:(long)newCount
{
    NSLog(@"Checking if new achievement gained for new Post count of %ld", newCount);
    if (newCount - oldCount == 1) // Should have only incremented by one
    {
        for (Achievement *achievement in self.achievementList)
        {
            if (achievement.hasAchieved == NO
                && [achievement.type isEqualToString:VALUE_POST_ACHIEVEMENT]
                && achievement.amountRequired <= newCount)
            {
                NSLog(@"Found and awarding an unachieved post count Achievement");
                achievement.hasAchieved = YES;
                
                [self addTimeCrunchHours:achievement.hoursForReward];
            }
        }
        
        [self saveAchievementsToCoreData];
    }
}
- (void)tryAchievementShortAndSweet
{
    NSLog(@"Checking if user has any posts with <= 3 words AND >= 100 points)");
    
    for (Post *post in self.userPosts)
    {
        NSArray *words = [post.text componentsSeparatedByString:@" "];
        if (words.count <= WORDS_FOR_SHORT_AND_SWEET_ACHIEVEMENT
            && [post.score longValue] >= POINTS_FOR_SHORT_AND_SWEET_ACHIEVEMENT)
        {
            NSLog(@"Found Post = \"%@\". Score = %@ and only %ld words!", post.text, post.score, words.count);
            
            for (Achievement *achievement in self.achievementList)
            {
                if ([achievement.type isEqualToString:TYPE_SHORT_AND_SWEET_ACHIEVEMENT]
                    && achievement.hasAchieved == NO)
                {
                    NSLog(@"Found and awarding the short and sweet achievement");
                    achievement.hasAchieved = YES;
                    
                    [self addTimeCrunchHours:achievement.hoursForReward];
                    [self saveAchievementsToCoreData];

                }
            }
        }
    }    
}
- (void)tryAchievementManyCrunchHours:(long)numHours
{
    NSLog(@"Checking if user has passed threshold for achievement of having many crunch time hours");
    for (Achievement *achievement in self.achievementList)
    {
        if ([achievement.type isEqualToString:TYPE_MANY_HOURS_ACHIEVEMENT]
            && achievement.hasAchieved == NO
            && achievement.amountRequired <= numHours)
        {
            achievement.hasAchieved = YES;
            NSLog(@"Earned 'Many Hours' achievement! Writing to core data");
            [self saveAchievementsToCoreData];
            
            NSLog(@"Adding time crunch hours for Earned 'Many Hours' achievement");
            [self addTimeCrunchHours:HOURS_FOR_EARN_MANY_HOURS_ACHIEVEMENT];
        }
    }
}
- (void)sortAchievementList
{
    long size = self.achievementList.count;
    for (long i = 1; i < size; i++)
    {
        Achievement *key = [self.achievementList objectAtIndex:i];
        
        long j = i;
        
        while (j > 0 && ((Achievement *)[self.achievementList objectAtIndex:(j - 1)]).achievementId > key.achievementId)
        {
            [self.achievementList replaceObjectAtIndex:j withObject:[self.achievementList objectAtIndex:(j - 1)]];
            
            j--;
        }
        
        [self.achievementList replaceObjectAtIndex:j withObject:key];
    }
    
    NSLog(@"Finished sorting achievements");
}
- (void)restoreAchievementsFromCoreData
{
    NSLog(@"Restoring Achievements from core data");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:ACHIEVEMENT_ENTITY
                                   inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSArray *arrayMgdAchievements = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (arrayMgdAchievements.count == 0)
    {
        NSLog(@"No Achievements found in core data. Creating the default empty list");
        [self initializeDefaultAchievements];
        return;
    }
    else
    {
        int numCompleted = 0;
        for (NSManagedObject *a in arrayMgdAchievements)
        {
            Achievement *achievement = [[Achievement alloc]
                                        initWithId:[[a valueForKey:ACHIEVEMENT_ID] longValue]
                                        currAmount:[[a valueForKey:KEY_AMOUNT_CURRENTLY] longValue]
                                        reqAmt:[[a valueForKey:KEY_AMOUNT_REQUIRED] longValue]
                                        rewardHours:[[a valueForKey:KEY_HOURS_REWARD] longValue]
                                        achievementType:[a valueForKey:KEY_TYPE]
                                        didAchieve:[[a valueForKey:KEY_HAS_ACHIEVED] boolValue]];
            
            if (achievement.hasAchieved) numCompleted++;
            
            [self.achievementList addObject:achievement];
        }
        
        [self sortAchievementList];
        
        NSLog(@"Finished restoring achievements from core data. Achievement List now has a total size of %ld. User has completed %d", self.achievementList.count, numCompleted);
    }
}
- (void)saveAchievementsToCoreData
{
    NSLog(@"Saving achievements to core data");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:ACHIEVEMENT_ENTITY
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *arrayMgdAchievements = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (self.achievementList == nil || self.achievementList.count == 0)
    {
        NSLog(@"No achievements found to save to core data. Not saving or deleting anything");
        return;
    }
    else
    {
        // Delete old copy of achievements
        for (NSManagedObject *oldMgdAchievement in arrayMgdAchievements)
        {
            [context deleteObject:oldMgdAchievement];
        }
        
        NSLog(@"Creating core data models for all %ld achievements", (unsigned long)self.achievementList.count);
        for (Achievement *newAchievement in self.achievementList)
        {
            NSManagedObject *newMgdAchievement = [NSEntityDescription
                                                  insertNewObjectForEntityForName:ACHIEVEMENT_ENTITY
                                                  inManagedObjectContext:context];
            
            [newMgdAchievement setValue:[NSNumber numberWithLong:newAchievement.achievementId]
                                 forKey:ACHIEVEMENT_ID];
            [newMgdAchievement setValue:[NSNumber numberWithLong:newAchievement.amountCurrently]
                                 forKey:KEY_AMOUNT_CURRENTLY];
            [newMgdAchievement setValue:[NSNumber numberWithLong:newAchievement.amountRequired]
                                 forKey:KEY_AMOUNT_REQUIRED];
            [newMgdAchievement setValue:[NSNumber numberWithBool:newAchievement.hasAchieved]
                                 forKey:KEY_HAS_ACHIEVED];
            [newMgdAchievement setValue:[NSNumber numberWithLong:newAchievement.hoursForReward]
                                 forKey:KEY_HOURS_REWARD];
            [newMgdAchievement setValue:newAchievement.type
                                 forKey:KEY_TYPE];
        }
    }
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save achievements to core data %@",
              [error localizedDescription]);
    }
}
- (void)initializeDefaultAchievements
{
    // For number of posts
    NSArray *arrayPostCounts = @[[NSNumber numberWithInt:1],
                                 [NSNumber numberWithInt:3],
                                 [NSNumber numberWithInt:10],
                                 [NSNumber numberWithInt:50],
                                 [NSNumber numberWithInt:200],
                                 [NSNumber numberWithInt:1000]];
    
    int incrementalId = 0;
    
    for (NSNumber *reqPostCount in arrayPostCounts)
    {
        long hrsReward = [reqPostCount longValue] * POST_COUNT_TO_HOURS_MULTIPLIER;
        Achievement *a = [[Achievement alloc] initWithId:(POST_COUNT_ACHIEVEMENT_ID + incrementalId++)
                                              currAmount:0
                                                  reqAmt:[reqPostCount longValue]
                                             rewardHours:hrsReward
                                         achievementType:VALUE_POST_ACHIEVEMENT
                                              didAchieve:NO];
        [self.achievementList addObject:a];
    }
    
    // For total points of posts
    NSArray *arrayPostPoints = @[[NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:10],
                                [NSNumber numberWithInt:20],
                                [NSNumber numberWithInt:40],
                                [NSNumber numberWithInt:80],
                                [NSNumber numberWithInt:150],
                                [NSNumber numberWithInt:300],
                                [NSNumber numberWithInt:800]];
    
    incrementalId = 0;
    
    for (NSNumber *reqPostPoints in arrayPostPoints)
    {
        long hrsReward = [reqPostPoints longValue] * POST_POINTS_TO_HOURS_MULTIPLIER;
        Achievement *a = [[Achievement alloc] initWithId:(POST_POINTS_ACHIEVEMENT_ID + incrementalId++)
                                              currAmount:0
                                                  reqAmt:[reqPostPoints longValue]
                                             rewardHours:hrsReward
                                         achievementType:VALUE_SCORE_ACHIEVEMENT
                                              didAchieve:NO];
        
        [self.achievementList addObject:a];
    }
    
    // Special
    Achievement *s1 = [[Achievement alloc] initWithId:VIEW_ACHIEVEMENT_ID
                                           currAmount:0
                                               reqAmt:1
                                          rewardHours:HOURS_FOR_VIEW_ACHIEVEMENT
                                      achievementType:VALUE_VIEW_ACHIEVEMENT
                                           didAchieve:NO];
    
    Achievement *s2 = [[Achievement alloc] initWithId:SHORT_AND_SWEET_ACHIEVEMENT_ID
                                           currAmount:0
                                               reqAmt:1
                                          rewardHours:HOURS_FOR_SHORT_AND_SWEET_ACHIEVEMENT
                                      achievementType:TYPE_SHORT_AND_SWEET_ACHIEVEMENT
                                           didAchieve:NO];

    Achievement *s3 = [[Achievement alloc] initWithId:MANY_HOURS_ACHIEVEMENT_ID
                                           currAmount:0
                                               reqAmt:REQUIRED_NUMBER_OF_CRUNCH_HOURS_FOR_MANY_HOURS_ACHIEVEMENT
                                          rewardHours:HOURS_FOR_EARN_MANY_HOURS_ACHIEVEMENT
                                      achievementType:TYPE_MANY_HOURS_ACHIEVEMENT
                                           didAchieve:NO];
    
    [self.achievementList addObject:s1];
    [self.achievementList addObject:s2];
    [self.achievementList addObject:s3];
    
    [self saveAchievementsToCoreData];
}

#pragma mark - Colleges

- (College *)getCollegeInFocus
{
    NSLog(@"Called DataController.getCollegeInFocus. Original one assigned was: %@", self.collegeInFocus);
    
    if (self.currentCollegeFeedId > 0)
    {
        if (self.collegeList != nil)
        {
            for (College *c in self.collegeList)
            {
                if (self.currentCollegeFeedId == c.collegeID
                    && self.currentCollegeFeedId != 0)
                {
                    NSLog(@"DataController.getCollegeInFocus found the correct college according to currentCollegeFeedId: %@", c);
                    
                    return c;
                }
            }
        }
    }
    
    return nil;
}
- (void)retrieveColleges
{
    NSLog(@"Restoring Colleges from core data");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:COLLEGE_ENTITY
                                   inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSArray *arrayMgdColleges = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (arrayMgdColleges.count < MIN_NUM_COLLEGES_IN_CORE_DATA_BEFORE_FETCH_FROM_NETWORK)
    {
        NSLog(@"Not enough Colleges found in core data. Getting network college list");
        [self getNetworkCollegeList];
        NSLog(@"Finished fetching network colleges, list count is now %ld.", self.collegeList.count);
    }
    else
    {
        NSLog(@"Retrieving colleges from Core Data");
        for (NSManagedObject *mdgCollege in arrayMgdColleges)
        {
            long collegeId = [[mdgCollege valueForKey:KEY_COLLEGE_ID] longValue];
            float lon = [[mdgCollege valueForKey:KEY_LON] floatValue];
            float lat = [[mdgCollege valueForKey:KEY_LAT] floatValue];
            NSString *name = [mdgCollege valueForKey:KEY_NAME];
            
            College *college = [[College alloc] initWithCollegeID:collegeId withName:name withLat:lat withLon:lon];
            [self.collegeList addObject:college];
            
            if (self.collegeInFocus == nil
                && self.currentCollegeFeedId == collegeId
                && self.currentCollegeFeedId != 0)
            {
                NSLog(@"Assigning collegeInFocus from RetrieveColleges because it was not set, and the correct college was found when reading from core data");
                self.collegeInFocus = college;
            }
        }
        
        NSLog(@"Finished restoring colleges from core data. College List now has a total size of %ld.", self.collegeList.count);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchedColleges" object:self userInfo:nil];
//    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys: @"allColleges", @"feedName", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetching" object:self userInfo:info];
}
- (long)getIdForHomeCollege
{
    NSLog(@"Retrieving ID for Home college. ID = %ld", self.homeCollegeId);
    
    return self.homeCollegeId;
}
- (BOOL)needsNewCollegeList
{
    long newVersion = [self getNetworkCollegeListVersion];
    long currVersion = self.collegeListVersion;
    
    return (currVersion == newVersion) ? NO : YES;
}
- (void)fetchTopColleges
{
    self.pageForTopColleges++;
    
    [self fetchObjectsOfType:COLLEGE
                   IntoArray:self.trendingColleges
          WithFeedIdentifier:@"topColleges"
           WithFetchFunction:^{
               
               return [Networker GETTrendingCollegesAtPageNum:self.pageForTopColleges];
           }];
}
- (void)fetchAllColleges
{
    if ([self needsNewCollegeList] || self.collegeList.count == 0)
    {
        [self getNetworkCollegeList];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchedColleges" object:nil];
    }
}
- (void)getNetworkCollegeList
{
    NSLog(@"Fetching network college list");
    [self fetchObjectsOfType:COLLEGE
                   IntoArray:self.collegeList
          WithFeedIdentifier:@"allColleges"
           WithFetchFunction:^{

               return [Networker GETAllColleges];
           }];
    
    self.collegeListVersion = [self getNetworkCollegeListVersion];
}
- (long)getNetworkCollegeListVersion
{
    NSData *data = [Networker GETCollegeListVersion];
    if (data)
    {
        NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
            
        NSNumber *versionNumber = [jsonArray valueForKey:@"version"];
        return [versionNumber longValue];
    }
    else return -1;
}
- (void)writeCollegestoCoreData
{
    NSLog(@"Writing colleges to core data. Total of %ld in list", self.collegeList.count);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:COLLEGE_ENTITY
                                   inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Erase all old colleges from core data
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *oldCollege in myObjectsToDelete)
    {
        [context deleteObject:oldCollege];
    }
    
    // Write new list of colleges to core data
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
        NSLog(@"Failed to save colleges to core data: %@",
              [error localizedDescription]);
    }
}
- (College *)getCollegeById:(long)collegeId
{
    if (collegeId > 0 && self.collegeList != nil)
    {
        for (College *college in self.collegeList)
        {
            if (college.collegeID == collegeId)
            {
                return college;
            }
        }
    }
    
    NSLog(@"Called getCollegeById with ID = %ld. An error occurred while trying to find it", collegeId);
    return nil;
}
- (NSMutableArray *)findNearbyCollegesWithLat:(float)userLat withLon:(float)userLon
{
    NSMutableArray *colleges = [[NSMutableArray alloc] init];
    
    for (College *college in self.collegeList)
    {
        double milesAway = [self numberMilesAwayFromLat:userLat fromLon:userLon AtLat:college.lat atLon:college.lon];
        
        if (milesAway <= MILES_FOR_PERMISSION && ![colleges containsObject:college])
        {
            [colleges addObject:college];
        }
    }
    return colleges;
}
- (void)switchedToSpecificCollegeOrNil:(College *)college
{
    if (college == nil)
    {
        self.currentCollegeFeedId = 0;
        self.collegeInFocus = nil;
        [self setShowingAllColleges:YES];
        [self setShowingSingleCollege:NO];
    }
    else
    {
        self.currentCollegeFeedId = college.collegeID;
        self.collegeInFocus = college;
        
        [self setShowingAllColleges:NO];
        [self setShowingSingleCollege:YES];
        
        [self.topPostsSingleCollege removeAllObjects];
        [self.recentPostsSingleCollege removeAllObjects];
        [self.postsWithTagSingleCollege removeAllObjects];
        [self.trendingTagsSingleCollege removeAllObjects];
        
        self.pageForTopPostsSingleCollege = 0;
        self.pageForNewPostsSingleCollege = 0;
        self.pageForTaggedPostsSingleCollege = 0;
        self.pageForTrendingTagsSingleCollege = 0;
    }
}
- (BOOL)isNearCollege
{
    return self.nearbyColleges.count > 0;
}
- (BOOL)isNearCollegeWithId:(long)collegeId
{
    for (College *college in self.nearbyColleges)
    {
        if (college.collegeID == collegeId && collegeId != 0)
        {
            return YES;
        }
    }
    
    return NO;
}
- (void)finishedFetchingCollegeList
{
    [self findNearbyColleges];
    [self writeCollegestoCoreData];
}
- (void)findNearbyColleges
{   // Populate the nearbyColleges array appropriately using current location

    self.nearbyColleges = [[NSMutableArray alloc] initWithArray:
                           [self findNearbyCollegesWithLat:self.lat
                                                   withLon:self.lon]];
    
}
- (NSString *)getCurrentFeedName
{
    if (self.showingSingleCollege)
    {
        if (self.collegeInFocus != nil)
        {
            return self.collegeInFocus.name;
        }

        College *college = [self getCollegeInFocus];
        if (college != nil)
        {
            return college.name;
        }
    }
    
    return @"All Colleges";
}

#pragma mark - Comments

- (BOOL)createCommentWithMessage:(NSString *)message
                        withPost:(Post*)post
{
    @try
    {

        if (![self isAbleToComment])
        {
            [self.toaster toastCommentingTooSoon];
            return NO;
        }
        Comment *comment = [[Comment alloc] initWithMessage:message withCollegeId:post.college_id withUserToken:@"EMPTY_TOKEN" withImageId:nil];
        
        NSData *result = [Networker POSTCommentData:[comment toJSON] WithPostId:[post.id longValue]];
        
        if (result)
        {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                       options:0
                                                                         error:nil];
            Comment *networkComment = [[Comment alloc] initFromJSON:jsonObject];

            self.lastCommentTime = [networkComment getCreated_at];

            [self.commentList insertObject:networkComment atIndex:self.commentList.count];
            [self.userComments insertObject:networkComment atIndex:self.userComments.count];
            [self saveComment:networkComment];
            return YES;
        }
        else
        {
            [self.toaster toastPostFailed];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
    return NO;
}
- (void)fetchCommentsForPost:(Post *)post
{
    
    [self fetchObjectsOfType:COMMENT
                   IntoArray:self.commentList
          WithFeedIdentifier:@"commentsForPost"
           WithFetchFunction:^{
               
               return [Networker GETCommentsWithPostId:[post.id longValue]];
           }];
}
- (void)saveComment:(Comment *)comment
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSManagedObject *mgdComment = [NSEntityDescription insertNewObjectForEntityForName:COMMENT_ENTITY
                                                                inManagedObjectContext:context];
    [mgdComment setValue:[NSNumber numberWithLong:[comment.id longValue]] forKeyPath:KEY_COMMENT_ID];
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user comment: %@",
              [error localizedDescription]);
    }
}

#pragma mark - Core Data

- (void)restoreAllCoreData
{
    NSLog(@"Restoring all information from Core Data");
    
    [self restoreStatusFromCoreData];
    [self retrieveColleges];
    [self retrieveUserPosts];
    [self retrieveUserComments];
    [self retrieveUserVotes];
    [self restoreAchievementsFromCoreData];
    [self restoreTimeCrunchFromCoreData];
}
- (void)saveAllCoreData
{
    // Posts should be every time user posts (comments, votes, etc.)
}
- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
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
- (NSManagedObjectModel *)managedObjectModel
{
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    
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
- (NSURL *)applicationDocumentsDirectory
{
    // Returns the URL to the application's Documents directory.
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Flags

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

#pragma mark - Images

- (NSNumber *)postImageToServer:(UIImage *)image fromFilePath:(NSString *)filePath
{
    return [Networker POSTImage:image fromFilePath:nil];
}
- (NSString *)getImageUrlFromId:(NSNumber *)imageID
{
    NSData *data = [Networker GETImageData:[imageID longValue]];
    NSDictionary *jsonObject = (NSDictionary *)(NSArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                                          options:0
                                                                                            error:nil];
    return [jsonObject valueForKey:@"uri"];
}

#pragma mark - Posts

- (BOOL)createPostWithMessage:(NSString *)message
                withCollegeId:(long)collegeId
                    withImage:(UIImage *)image
{
    @try
    {
        NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSNumber *imageID = [self postImageToServer:image fromFilePath:nil];
        Post *post = [[Post alloc] initWithMessage:message
                                     withCollegeId:[NSNumber numberWithLong:collegeId]
                                     withUserToken:udid
                                       withImageId:imageID];
        
        if (![self shouldPostToServer:post])
        {
            return NO;
        }
        
        NSData *result = [Networker POSTPostData:[post toJSON] WithCollegeId:[post.college_id longValue]];
        
        if (result)
        {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:result
                                                                       options:0
                                                                         error:nil];
            Post *networkPost = [[Post alloc] initFromJSON:jsonObject];

            networkPost.college = [self getCollegeById:collegeId];

            NSLog(@"Successfully submitted Post to network. Text = %@. College = %@.", networkPost.text, networkPost.college.name);
            
            self.lastPostTime = [networkPost getCreated_at];
            
            [self.recentPostsAllColleges insertObject:networkPost atIndex:0];
            [self.recentPostsSingleCollege insertObject:networkPost atIndex:0];
            
            
            long oldCount = self.userPosts.count;
            
            [self.userPosts insertObject:networkPost atIndex:0];
            
            long newCount = self.userPosts.count;
            
            [self savePost:networkPost];
            
            [self tryAchievementPostCountWithOldCount:oldCount toNewCount:newCount];
            
            Vote *actualVote = networkPost.vote;
            if (actualVote != nil && actualVote.voteID > 0)
            {
                [self.userPostVotes addObject:actualVote];
                [self saveVote:actualVote];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatedPost" object:self];
            return YES;
        }
        else
        {
            [self.toaster toastPostFailed];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception.reason);
    }
    return NO;
}
- (void)savePost:(Post *)post
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSManagedObject *mgdPost = [NSEntityDescription insertNewObjectForEntityForName:POST_ENTITY
                                                             inManagedObjectContext:context];
    [mgdPost setValue:[NSNumber numberWithLong:[post.id longValue]] forKeyPath:KEY_POST_ID];
        
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user post: %@",
              [error localizedDescription]);
    }
    
    [self updateTimeCrunchWithNewPost:post];
}
- (BOOL)shouldPostToServer:(Post *)post
{
    // Check for posting too frequently
    NSNumber *minutesUntilCanPost = [NSNumber new];
    if (![self isAbleToPost:minutesUntilCanPost])
    {
        [self.toaster toastPostingTooSoon:minutesUntilCanPost];
        return NO;
    }
    
    NSMutableDictionary* resultDict = [NSMutableDictionary new];
    
    BOOL validMessage = [self.watchDog shouldSubmitMessage:post.text WithResults:resultDict];
    
    if (!validMessage)
    {
        NSString *errorToastMessage = @"Sorry, your message was rejected. Please try again. Reason:";
        
        NSMutableArray *errorReasons = [NSMutableArray new];
        if (![[resultDict valueForKey:@"isValidLength"] boolValue])
        {
            [errorReasons addObject:@"Invalid length"];
            errorToastMessage = [NSString stringWithFormat:@"%@%@", errorToastMessage, @" Invalid length,"];
        }
        if ([[resultDict valueForKey:@"shouldBlockForNumber"] boolValue])
        {
            [errorReasons addObject:@"Phone numbers not allowed"];
            errorToastMessage = [NSString stringWithFormat:@"%@%@", errorToastMessage, @" Phone numbers not allowed,"];
        }
        if ([[resultDict valueForKey:@"shouldBlockForEmail"] boolValue])
        {
            [errorReasons addObject:@"Email addresses not allowed"];
            errorToastMessage = [NSString stringWithFormat:@"%@%@", errorToastMessage, @" Email addresses not allowed,"];
        }
        
        errorToastMessage = [errorToastMessage substringToIndex:[errorToastMessage length] - 1];
        
        [self.toaster toastCustomMessage:errorToastMessage];
        
        return NO;
    }
    
    return YES;
}
- (void)fetchTopPostsForAllColleges
{
    self.pageForTopPostsAllColleges++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.topPostsAllColleges
          WithFeedIdentifier:@"topPosts"
           WithFetchFunction:^{
               
               return [Networker GetTopPostsAtPageNum:self.pageForTopPostsAllColleges];
           }];
}
- (void)fetchTopPostsForSingleCollege
{
    self.pageForTopPostsSingleCollege++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.topPostsSingleCollege
          WithFeedIdentifier:@"topPosts"
           WithFetchFunction:^{
               
               return [Networker GetTopPostsAtPageNum:self.pageForTopPostsSingleCollege
                                        WithCollegeId:self.currentCollegeFeedId];
           }];
}
- (void)fetchNewPostsForAllColleges
{
    self.pageForNewPostsAllColleges++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.recentPostsAllColleges
          WithFeedIdentifier:@"newPosts"
           WithFetchFunction:^{
               
               return [Networker GetNewPostsAtPageNum:self.pageForNewPostsAllColleges];
           }];
}
- (void)fetchNewPostsForSingleCollege
{
    self.pageForNewPostsSingleCollege++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.recentPostsSingleCollege
          WithFeedIdentifier:@"newPosts"
           WithFetchFunction:^{
               
               return [Networker GetNewPostsAtPageNum:self.pageForNewPostsSingleCollege
                                           WithCollegeId:self.currentCollegeFeedId];
           }];
}
- (void)fetchPostsWithTagForAllColleges:(NSString*)tagMessage
{
    self.pageForTaggedPostsAllColleges++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.postsWithTagAllColleges
          WithFeedIdentifier:@"tagPosts"
           WithFetchFunction:^{
               
               return [Networker GetPostsWithTag:tagMessage
                                       AtPageNum:self.pageForTaggedPostsAllColleges];
           }];
}
- (void)fetchPostsWithTagForSingleCollege:(NSString *)tagMessage
{
    self.pageForTaggedPostsSingleCollege++;
    
    [self fetchObjectsOfType:POST
                   IntoArray:self.postsWithTagSingleCollege
          WithFeedIdentifier:@"tagPosts"
           WithFetchFunction:^{
               
               return [Networker GetPostsWithTag:tagMessage
                                       AtPageNum:self.pageForTaggedPostsSingleCollege
                                   WithCollegeId:self.currentCollegeFeedId];
           }];
}
- (void)retrieveUserPosts
{
    self.userPosts = [[NSMutableArray alloc] init];
    [self fetchObjectsOfType:POST
                   IntoArray:self.userPosts
          WithFeedIdentifier:@"userPosts"
           WithFetchFunction:^{
               
               NSMutableArray *postIds = [[NSMutableArray alloc] init];
               
               NSError *error;
               NSManagedObjectContext *context = [self managedObjectContext];
               NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
               NSEntityDescription *entity = [NSEntityDescription entityForName:POST_ENTITY
                                                         inManagedObjectContext:context];
               
               [fetchRequest setEntity:entity];
               
               NSArray *fetchedPosts = [_managedObjectContext executeFetchRequest:fetchRequest
                                                                            error:&error];
               for (NSManagedObject *post in fetchedPosts)
               {
                   [postIds addObject:(NSNumber *)[post valueForKey:KEY_POST_ID]];
               }
               
               return [Networker GETPostsWithIdArray:[[postIds reverseObjectEnumerator] allObjects]];
           }];
}
- (void)didFinishFetchingUserPosts
{
    [self tryAchievementScoreCountWithScore:[self getUserPostScore]];
    [self tryAchievementShortAndSweet];
}
- (Post *)fetchPostWithId:(long)postId
{
    NSArray *singleton = @[[NSString stringWithFormat:@"%ld", postId]];
    NSData *data = [Networker GETPostsWithIdArray:singleton];
    NSArray *singlePostArray = [self parseData:data asModelType:POST];
    return singlePostArray.count ? [singlePostArray firstObject] : nil;
}
- (Post *)fetchParentPostOfComment:(Comment *)comment
{
    if (comment)
    {
        long postId = [comment.post_id longValue];
        NSData *postData = [Networker GETPostWithId:postId];
        return [[Post getListFromJsonData:postData error:nil] firstObject];
    }
    
    return nil;
}

#pragma mark - Status

- (void)restoreStatusFromCoreData
{
    NSLog(@"Restoring status from core data");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:STATUS_ENTITY inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedStatus = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedStatus.count > 1)
    {
        NSLog(@"Too many status entities");
    }
    NSManagedObject *status = [fetchedStatus firstObject];
    
    // Current feed
    self.currentCollegeFeedId = [[status valueForKey:KEY_CURRENT_COLLEGE_FEED] longValue];
    self.showingSingleCollege = self.currentCollegeFeedId > 0;
    self.showingAllColleges = !self.showingSingleCollege;
    
    // Achievements
    self.hasViewedAchievements = [[status valueForKey:KEY_HAS_VIEWED_ACHIEVEMENTS] boolValue];
//    self.numPosts = [[status valueForKey:KEY_NUM_POSTS] longValue];
//    self.numPoints = [[status valueForKey:KEY_NUM_POINTS] longValue];
    
    // Restrictions
    self.lastCommentTime = [status valueForKey:KEY_COMMENT_TIME];
    self.lastPostTime = [status valueForKey:KEY_POST_TIME];
    self.isBanned = [[status valueForKey:KEY_IS_BANNED] boolValue];
    
    // Other
    self.collegeListVersion = [[status valueForKey:KEY_COLLEGE_LIST_VERSION] longValue];
    self.launchCount = [[status valueForKey:KEY_LAUNCH_COUNT] longValue];
    self.homeCollegeId = [[status valueForKey:KEY_HOME_COLLEGE] longValue];
    
}
- (void)saveStatusToCoreData
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:STATUS_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedStatus = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedStatus.count > 1)
    {
        NSLog(@"Too many status entities");
    }
    NSManagedObject *status = [fetchedStatus firstObject];
    if (status == nil)
    {
        status = [NSEntityDescription insertNewObjectForEntityForName:STATUS_ENTITY
                                               inManagedObjectContext:context];
    }
    
    // Current feed
    NSNumber *feedNumber = (self.currentCollegeFeedId <= 0) ? nil : [NSNumber numberWithLong:self.currentCollegeFeedId];
    [status setValue:feedNumber forKey:KEY_CURRENT_COLLEGE_FEED];
    
    // Achievements
    [status setValue:[NSNumber numberWithBool:self.hasViewedAchievements] forKey:KEY_HAS_VIEWED_ACHIEVEMENTS];
//    [status setValue:[NSNumber numberWithLong:self.numPosts] forKey:KEY_NUM_POSTS];
//    [status setValue:[NSNumber numberWithLong:self.numPoints] forKey:KEY_NUM_POINTS];
    
    // Restrictions
    [status setValue:self.lastPostTime forKey:KEY_POST_TIME];
    [status setValue:self.lastCommentTime forKey:KEY_COMMENT_TIME];
    [status setValue:[NSNumber numberWithBool:self.isBanned] forKey:KEY_IS_BANNED];
    
    // Other
    [status setValue:[NSNumber numberWithLong:self.collegeListVersion] forKey:KEY_COLLEGE_LIST_VERSION];
    [status setValue:[NSNumber numberWithLong:self.launchCount] forKey:KEY_LAUNCH_COUNT];
    [status setValue:[NSNumber numberWithLong:self.homeCollegeId] forKey:KEY_HOME_COLLEGE];
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save status to core data: %@",
              [error localizedDescription]);
    }
}

#pragma mark - Tags

- (void)fetchTrendingTagsForAllColleges
{
    self.pageForTrendingTagsAllColleges++;
    
    [self fetchObjectsOfType:TAG
                   IntoArray:self.trendingTagsAllColleges
          WithFeedIdentifier:@"trendingTags"
           WithFetchFunction:^{
               
               return [Networker GetTrendingTagsAtPageNum:self.pageForTrendingTagsAllColleges];
        }];
}
- (void)fetchTrendingTagsForSingleCollege
{
    self.pageForTrendingTagsSingleCollege++;
    
    [self fetchObjectsOfType:TAG
                   IntoArray:self.trendingTagsAllColleges
          WithFeedIdentifier:@"trendingTags"
           WithFetchFunction:^{
               
               return [Networker GetTrendingTagsAtPageNum:self.pageForTrendingTagsSingleCollege
                                            WithCollegeId:self.currentCollegeFeedId];
           }];
}

#pragma mark - Time Crunch

- (void)addTimeCrunchHours:(long)hours
{
    NSLog(@"Adding %ld Time Crunch Hours", hours);
    
    if (self.timeCrunch == nil)
    {
        NSLog(@"timeCrunch was nil, calling restoreTimeCrunchFromCoreData");
        [self restoreTimeCrunchFromCoreData];
    }
    if (self.timeCrunch == nil)
    {
        NSLog(@"timeCrunch still nil, initializing a new one without a college assigned");
        self.timeCrunch = [[TimeCrunchModel alloc] initWithCollegeId:0 hours:0 activationTime:nil];
    }
    
    NSLog(@"TimeCrunchModel.hours *before* = %ld", self.timeCrunch.hoursEarned);
    [self.timeCrunch addHours:hours];
    NSLog(@"TimeCrunchModel.hours *after*  = %ld", self.timeCrunch.hoursEarned);
    
    NSLog(@"Checking if newly added time crunch hours earn the 'many hours' achievement");
    
    [self tryAchievementManyCrunchHours:hours];
    
    [self saveTimeCrunchToCoreData];
}
- (long)getTimeCrunchHours
{
    if (self.timeCrunch == nil)
    {
        return 0;
    }

    return [self.timeCrunch getHoursRemaining];
}
- (void)attemptActivateTimeCrunch
{
    NSLog(@"Attempt to activate Time Crunch in DataController");
    
    if (self.timeCrunch == nil || self.timeCrunch.collegeId == 0)
    {
        NSLog(@"Activating Time Crunch failed");
        [self.toaster toastErrorFindingTimeCrunchCollege];
    }
    else if (self.timeCrunch.timeWasActivatedAt == nil)
    {
        if (self.timeCrunch.hoursEarned == 0)
        {
            NSLog(@"Time crunch staying unactivated because no hours earned yet");
        }
        else
        {
            NSDate *now = [NSDate date];
            NSLog(@"Time Crunch activated NOW: %@", now);
            [self.timeCrunch activateAtTime:now];
        }
    }
    
    [self saveTimeCrunchToCoreData];
}
- (void)updateTimeCrunchWithNewPost:(Post *)post
{
    NSLog(@"Updating Time Crunch with new Post");
    
    College *postCollege = post.college;
    
    if (postCollege == nil)
    {
        NSLog(@"ERROR in updateTimeCrunchWithNewPost. New post does not have a college assigned to it");
        return;
    }
    
    void (^blockUpdateTimeCrunch)(void) = ^{
        // This block will be executed if user agrees to change home colleges
        
        NSLog(@"ChangeHomeCollegeBlock invoked");
        if (self.timeCrunch == nil)
        {
            // Make new TimeCrunchModel
            NSLog(@"DataController.timeCrunch is nil. Making new TimeCrunchModel");
            self.timeCrunch = [[TimeCrunchModel alloc] init];
        }
        
        self.homeCollegeForTimeCrunch = postCollege;
        self.homeCollegeId = postCollege.collegeID;
        
        [self.timeCrunch changeCollegeId:self.homeCollegeId];
        [self.timeCrunch addHours:TIME_CRUNCH_HOURS_FOR_POST];
        
        NSLog(@"DataController changed home college to %@", self.homeCollegeForTimeCrunch.name);
        
        [self saveTimeCrunchToCoreData];
        [self saveStatusToCoreData];
        
    };
    
    if (self.timeCrunch != nil && self.timeCrunch.collegeId != 0 && self.timeCrunch.collegeId != postCollege.collegeID)
    {
        // TimeCrunchModel exists. Trying to post to a different home college
        NSLog(@"Time Crunch home college is different than the one for this post. Displaying prompt dialog to user");
        SwitchHomeCollegeDialogView *dialog = [[SwitchHomeCollegeDialogView alloc] initWithAcceptanceBlock:blockUpdateTimeCrunch];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
    }
    else
    {
        blockUpdateTimeCrunch();
    }
}
- (void)restoreTimeCrunchFromCoreData
{
    NSLog(@"Restoring Time Crunch from core data");
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:TIME_CRUNCH_ENTITY
                                   inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSLog(@"Currently allowing %d Time Crunch object(s) to exist", NUMBER_TIME_CRUNCHES_ALLOWED);
    NSArray *arrayTimeCrunches = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Found %lu Time Crunch object(s) in core data", (unsigned long)arrayTimeCrunches.count);
    
    NSLog(@"Using the first Time Crunch core data object as the member variable");
    NSManagedObject *mgdCrunch = [arrayTimeCrunches firstObject];
    
    long collegeId = [[mgdCrunch valueForKey:KEY_COLLEGE_ID] longValue];
    long hours = [[mgdCrunch valueForKey:KEY_HOURS_EARNED] longValue];
    NSDate *date = [mgdCrunch valueForKey:KEY_TIME_ACTIVATED_AT];
    
    NSLog(@"Restored info for, and am assigning new TimeCrunchModel with collegeID = %ld, hours earned = %ld, and activation date = %@", collegeId, hours, date);
    self.timeCrunch = [[TimeCrunchModel alloc] initWithCollegeId:collegeId
                                                           hours:hours
                                                  activationTime:date];
}
- (void)saveTimeCrunchToCoreData
{
    NSLog(@"Saving self.timeCrunch to Core Data");
    
    if (self.timeCrunch == nil)
    {
        NSLog(@"self.timeCrunch is nil, not saving anything to core data");
        return;
    }
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:TIME_CRUNCH_ENTITY inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedTimeCrunches = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    bool foundMatch = NO;
    
    for (NSManagedObject *t in fetchedTimeCrunches)
    {
        if (CAN_ALLOW_MULTIPLE_TIME_CRUNCH_IN_CORE_DATA)
        {
            NSLog(@"Multiple Time Crunches allowed, updating a matching one");
            if (self.timeCrunch.collegeId == [[t valueForKey:KEY_COLLEGE_ID] longValue]
                && self.timeCrunch.collegeId != 0)
            {
                foundMatch = YES;
                
                [t setValue:[NSNumber numberWithLong:[self.timeCrunch getHoursEarned]] forKey:KEY_HOURS_EARNED];
                [t setValue:self.timeCrunch.timeWasActivatedAt forKey:KEY_TIME_ACTIVATED_AT];
            }
        }
        else
        {
            NSLog(@"Cannot save multiple colleges, delete existing ones");
            [context deleteObject:t];
        }
    }
    
    if (!foundMatch)
    {
        NSLog(@"Inserting Time Crunch into Core Data.");
        
        NSManagedObject *mgdModel = [NSEntityDescription
                                     insertNewObjectForEntityForName:TIME_CRUNCH_ENTITY
                                     inManagedObjectContext:context];

        [mgdModel setValue:self.timeCrunch.timeWasActivatedAt forKey:KEY_TIME_ACTIVATED_AT];
        [mgdModel setValue:[NSNumber numberWithLong:self.timeCrunch.collegeId] forKey:KEY_COLLEGE_ID];
        [mgdModel setValue:[NSNumber numberWithLong:[self.timeCrunch getHoursEarned]] forKey:KEY_HOURS_EARNED];
    }
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save Time Crunch to core data: %@",
              [error localizedDescription]);
    }
}

#pragma mark - User data

- (long)getNumUserPosts
{
    if (self.userPosts == nil)
    {
        [self retrieveUserPosts];
        return 0;
    }
    
    return self.userPosts.count;
}
- (void)retrieveUserComments
{
    [self fetchObjectsOfType:COMMENT
                   IntoArray:self.userComments
          WithFeedIdentifier:@"userComments"
           WithFetchFunction:^{
               
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
               
               return [Networker GETCommentsWithIdArray:[[commentIds reverseObjectEnumerator] allObjects]];
           }];
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
    NSArray *fetchedVotes = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *vote in fetchedVotes)
    {
        long voteId = [[vote valueForKey:KEY_VOTE_ID] longValue];
        long parentId = [[vote valueForKey:KEY_PARENT_ID] longValue];
        BOOL upvote = [[vote valueForKey:KEY_UPVOTE] boolValue];
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
- (long)getUserPostScore
{
    long totalScore = 0;
    for (Post* post in self.userPosts)
    {
        totalScore += [[post getScore] longValue];
    }
    
    return totalScore;
}
- (long)getUserCommentScore
{
    long totalScore = 0;
    for (Comment* comment in self.userComments)
    {
        totalScore += [[comment getScore] longValue];
    }
    return totalScore;
}

#pragma mark - Votes

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
            
            if (vote != nil && vote.voteID > 0)
            {
                [self saveVote:vote];
            }
        }
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
    if (vote != nil && vote.voteID > 0)
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
        [self deleteVote:vote];
        return success;
    }
    
    return false;
}
- (void)saveVote:(Vote *)vote
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSManagedObject *mgdVote = [NSEntityDescription insertNewObjectForEntityForName:VOTE_ENTITY
                                                             inManagedObjectContext:context];
    [mgdVote setValue:[NSNumber numberWithLong:vote.parentID] forKeyPath:KEY_PARENT_ID];
    [mgdVote setValue:[NSNumber numberWithLong:vote.voteID] forKeyPath:KEY_VOTE_ID];
    [mgdVote setValue:[NSNumber numberWithBool:vote.upvote] forKeyPath:KEY_UPVOTE];
    
    if ([vote getType] == POST) [mgdVote setValue:VALUE_POST forKeyPath:KEY_TYPE];
    else if ([vote getType] == COMMENT) [mgdVote setValue:VALUE_COMMENT forKeyPath:KEY_TYPE];
    
    if (![context save:&error])
    {
        NSLog(@"Failed to save user's vote: %@",
              [error localizedDescription]);
    }
}
- (void)deleteVote:(Vote *)vote
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:VOTE_ENTITY inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedVotes = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *mgdVote in fetchedVotes)
    {
        if ([[mgdVote valueForKey:KEY_VOTE_ID] longValue] == vote.voteID)
        {
            [context deleteObject:mgdVote];
            if (![context save:&error])
            {
                NSLog(@"Failed to delete user's vote: %@",
                      [error localizedDescription]);
            }
            return;
        }
    }
}

#pragma mark - Watchdog

- (void)createWatchdog
{
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:10], @"minLength",
                             [NSNumber numberWithInt:140], @"maxLength",
                             [NSNumber numberWithBool:YES], @"blockPhone",
                             [NSNumber numberWithBool:YES], @"blockEmail",
                             [NSNumber numberWithBool:NO], @"blockVulgar",
                             nil];
    
    self.watchDog = [[Watchdog alloc] initWithOptions:options];
    NSLog(@"Finished creating Watchdog");
}

#pragma mark - Helper Methods

- (void)fetchObjectsOfType:(ModelType)type
                 IntoArray:(NSMutableArray *)array
        WithFeedIdentifier:(NSString *)feedName
         WithFetchFunction:(NSData* (^)(void))fetchBlock
{
    if (array == nil)
    {
        array = [NSMutableArray new];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       NSData* data = fetchBlock();
                       
                       NSArray *fetchedObjects = [self parseData:data asModelType:type];
                       
                       NSNumber *newObjectsCount = [NSNumber numberWithLong:[array insertObjectsWithUniqueIds:fetchedObjects]];
                       NSLog(@"Fetched %@ new objects for %@", newObjectsCount, feedName);
                       [NSThread sleepForTimeInterval:DELAY_FOR_SLOW_NETWORK];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                    newObjectsCount, @"newObjectsCount",
                                                                    feedName, @"feedName", nil];
                                          if (type == COLLEGE)
                                          {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchedColleges" object:userInfo];
                                          }
                                          else
                                          {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetching" object:self userInfo:userInfo];
                                          }
                                      });
                   });
}
- (void)checkAppVersionNumber
{
    float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
    NSData *data = [Networker getIOSAppVersionFromServer];
    if (data)
    {
        NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
        
        float serverVersion = [[jsonArray valueForKey:@"minVersion"] floatValue];
        
        if (appVersion < serverVersion)
        {
            CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:UPDATE];
            
            // TODO: direct to app store for update
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
        }
    }
}
- (NSArray *)parseData:(NSData *)data asModelType:(ModelType)type
{
    NSMutableArray *arr = [NSMutableArray new];
    
    if (data != nil)
    {
        NSArray *jsonArray = (NSArray*)[NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:nil];
        if (jsonArray && jsonArray.count)
        {
            for (NSDictionary *jsonObject in jsonArray)
            {
                switch (type)
                {
                    case POST:
                        {
                            Post *post = [[Post alloc] initFromJSON:jsonObject];
                            //long collegeID = [post getCollegeID];
                            if ([post hasImage] && [post getImage_url] == nil && post.image_id != nil)
                            {
                                [post setImage_uri:[self getImageUrlFromId:post.image_id]];
                            }
                            College *college = [self getCollegeById:[post.college_id longValue]];
                            [post setCollege:college];
                            long postID = [[post getID] longValue];
                            for (Vote *vote in self.userPostVotes)
                            {
                                if (vote.parentID == postID)
                                {
                                    [post setVote:vote];
                                    break;
                                }
                            }
                            
                            [arr addObject:post];
                            break;
                        }
                    case COMMENT:
                        {
                            Comment *comment = [[Comment alloc] initFromJSON:jsonObject];
                            long commentID = [[comment getID] longValue];
                            for (Vote *vote in self.userCommentVotes)
                            {
                                if (vote.parentID == commentID)
                                {
                                    [comment setVote:vote];
                                    break;
                                }
                            }
                            
                            [arr addObject:comment];
                            break;
                        }
                    case TAG:
                        {
                            [arr addObject:[[Tag alloc] initFromJSON:jsonObject]];
                            break;
                        }
                    case COLLEGE:
                        {
                            College *college = [[College alloc] initFromJSON:jsonObject];
                            if (self.collegeInFocus == nil
                                && self.currentCollegeFeedId == college.collegeID
                                && self.currentCollegeFeedId != 0)
                            {
                                NSLog(@"Assigning collegeInFocus from parseData because it was not set, and the correct college was found when parsing from network data");
                                self.collegeInFocus = college;
                            }
                            
                            [arr addObject:college];
                            break;
                        }
                    case VOTE:
                        {
                            [arr addObject:[[Vote alloc] initFromJSON:jsonObject]];
                            break;
                        }
                }
            }
        }
        
    }
    
    return arr;
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
- (BOOL)isAbleToPost:(NSNumber *)minutesRemaining
{
    if (self.lastPostTime != nil)
    {
        NSTimeInterval diff = [self.lastPostTime timeIntervalSinceNow];
        minutesRemaining = [NSNumber numberWithInt:(abs(diff) / 60)];
        float minSeconds = MINIMUM_POSTING_INTERVAL_MINUTES * 60;
        if (abs(diff) < minSeconds)
        {
            return NO;
        }
    }
    minutesRemaining = [NSNumber numberWithInt:0];
    return YES;
}
- (BOOL)isAbleToComment
{
    if (self.lastCommentTime != nil)
    {
        NSTimeInterval diff = [self.lastCommentTime timeIntervalSinceNow];
        float minSeconds = MINIMUM_COMMENTING_INTERVAL_MINUTES * 60;
        if (abs(diff) < minSeconds)
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - CLLocationManager Functions

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.locStatus == LOCATION_FOUND)
        return;
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval secs = [currentTime timeIntervalSinceDate:self.locationSearchStart];
    
    
    NSLog(@"DidUpdateToLocation attempt number: %ld", (long)++self.locationUpdateAttempts);
    
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services not enabled");
        [self failedLocationFinding];
    }
    else if (self.locationUpdateAttempts >= 4)
    {
        NSLog(@"Reached limit of location update attempts");
        [self failedLocationFinding];
    }
    
    else if (secs >= 30)
    {
        NSLog(@"Location update timeout expired");
        [self failedLocationFinding];
    }
    else
    {
        NSLog(@"Successfully found location");
        [self setLat:newLocation.coordinate.latitude];
        [self setLon:newLocation.coordinate.longitude];
        [self.locationManager stopUpdatingLocation];
        
        [self findNearbyColleges];
        [self setLocStatus:LOCATION_FOUND];
        [self.toaster toastNearbyColleges:self.nearbyColleges];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdated" object:self];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self failedLocationFinding];
}
- (void)failedLocationFinding
{
    NSLog(@"Failed Location Finding");
    [self setLocStatus:LOCATION_NOT_FOUND];
    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdated" object:self];
    [self.toaster toastLocationConnectionError];
}
- (void)findUserLocation
{
    [self setLocStatus:LOCATION_SEARCHING];
    [self setLocationManager:[[CLLocationManager alloc] init]];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager setDelegate:self];
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationUpdateAttempts = 0;
        self.locationSearchStart = [NSDate date];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        self.locStatus = LOCATION_SEARCHING;
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        [self failedLocationFinding];
    }
}



@end
