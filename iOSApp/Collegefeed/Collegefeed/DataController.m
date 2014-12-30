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
#import "CF_DialogViewController.h"
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
        [self setShowingAllColleges:YES];
        [self setShowingSingleCollege:NO];
        self.toaster = [ToastController new];
        
        [self initArrays];
        
        [self populateCollegeList];
        
        [self restoreSavedFeed];
        
        // Populate arrays from both network and core (local) data
        [self retrieveUserVotes];
        
        // Get the user's location
        [self findUserLocation];
        
        // For restricting phone numbers and email addresses
        [self createWatchdog];
    }
    return self;
}

- (void)initArrays
{
    // Initialize arrays
    self.collegeList            = [[NSMutableArray alloc] init];
    self.nearbyColleges         = [[NSMutableArray alloc] init];
    self.trendingColleges       = [[NSMutableArray alloc] init];
    
    self.commentList            = [[NSMutableArray alloc] init];
    self.userComments           = [[NSMutableArray alloc] init];
    
    // Posts
    self.topPostsAllColleges        = [[NSMutableArray alloc] init];
    self.recentPostsAllColleges     = [[NSMutableArray alloc] init];
    self.postsWithTagAllColleges    = [[NSMutableArray alloc] init];
    self.topPostsSingleCollege          = [[NSMutableArray alloc] init];
    self.recentPostsSingleCollege       = [[NSMutableArray alloc] init];
    self.postsWithTagSingleCollege      = [[NSMutableArray alloc] init];
    self.userPosts                  = [[NSMutableArray alloc] init];
    
    
    
    self.trendingTagsAllColleges                = [[NSMutableArray alloc] init];
    self.trendingTagsSingleCollege       = [[NSMutableArray alloc] init];
    
    self.userPostVotes          = [[NSMutableArray alloc] init];
    self.userCommentVotes       = [[NSMutableArray alloc] init];
}

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
        
        self.needsUpdate = (appVersion < serverVersion);
        if (appVersion < serverVersion)
        {
            self.needsUpdate = YES;
            CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:UPDATE];

            // TODO: direct to app store for update
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
        }
    }
}
- (void)incrementLaunchNumber
{
    // Retrieve Launch Count
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
    NSNumber *currCount = [status valueForKey:KEY_LAUNCH_COUNT];
    
    NSNumber *newCount = [NSNumber numberWithInt:([currCount intValue] + 1)];
    
    [status setValue:newCount forKey:KEY_LAUNCH_COUNT];
    
    if (![context save:&error])
    {
        NSLog(@"Failed to save user's vote: %@",
              [error localizedDescription]);
    }

}
- (NSInteger)getLaunchNumber
{
    // Retrieve Launch Count
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
    NSNumber *count = [status valueForKey:KEY_LAUNCH_COUNT];
    
    return [count integerValue];
}
- (void)saveCurrentFeed
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
    NSNumber *collegeIdForFeed = self.showingSingleCollege ? [NSNumber numberWithLong:self.collegeInFocus.collegeID] : nil;
    
    [status setValue:collegeIdForFeed forKey:KEY_CURRENT_COLLEGE_FEED];
    
    if (![context save:&error])
    {
        NSLog(@"Failed to save current feed: %@",
              [error localizedDescription]);
    }
}
- (void)restoreSavedFeed
{
    // Retrieve last saved/visited feed
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
    NSNumber *collegeID = [status valueForKey:KEY_CURRENT_COLLEGE_FEED];
    long collegeIdForFeed = [collegeID longValue];

    self.collegeInFocus = [self getCollegeById:collegeIdForFeed];
    
    self.showingAllColleges = self.collegeInFocus == nil;
    self.showingSingleCollege = !self.showingAllColleges;
}
- (NSMutableArray *)getCurrentTagList
{
    if (self.showingSingleCollege)
    {
        return self.trendingTagsSingleCollege;
    }
    
    return self.trendingTagsAllColleges;
}

#pragma mark - Network Access

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
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetching" object:self userInfo:userInfo];
                                      });
                   });
}

#pragma mark - Achievements

- (void)fetchAchievements
{
    if (self.achievementList == nil)
    {
        self.achievementList = [[NSMutableArray alloc] init];
    }
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ACHIEVEMENT_ENTITY
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSArray *achievements = [_managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];
    for (NSManagedObject *a in achievements)
    {
        Achievement *achievement = [[Achievement alloc]
                                    initWithCurrAmount:[[a valueForKey:KEY_AMOUNT_CURRENTLY] longValue]
                                    reqAmt:[[a valueForKey:KEY_AMOUNT_REQUIRED] longValue]
                                    rewardHours:[[a valueForKey:KEY_HOURS_REWARD] longValue]
                                    achieved:[[a valueForKey:KEY_HAS_ACHIEVED] boolValue]
                                    achievementType:[a valueForKey:KEY_TYPE]];
        
        [self.achievementList addObject:achievement];
    }
}
- (void)addAchievement:(Achievement *)achievement
{
    if (self.achievementList == nil)
    {
        [self fetchAchievements];
    }
    [self.achievementList addObject:achievement];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ACHIEVEMENT_ENTITY
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"%@ == %@", KEY_AMOUNT_REQUIRED, achievement.amountRequired];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"%@ == %@", KEY_HOURS_REWARD, achievement.hoursForReward];
    NSPredicate *p3 = [NSPredicate predicateWithFormat:@"%@ == %@", KEY_TYPE, achievement.type];
    [fetchRequest setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2, p3]]];
    

    NSArray *achievements = [_managedObjectContext executeFetchRequest:fetchRequest
                                                                 error:&error];

    if (achievements.count == 0)
    {
        // Add this one to core data
        NSManagedObject *mgdAchievement = [NSEntityDescription insertNewObjectForEntityForName:ACHIEVEMENT_ENTITY
                                                                        inManagedObjectContext:context];
        
        [mgdAchievement setValue:[NSNumber numberWithLong:achievement.amountCurrently] forKey:KEY_AMOUNT_CURRENTLY];
        [mgdAchievement setValue:[NSNumber numberWithLong:achievement.amountRequired] forKey:KEY_AMOUNT_REQUIRED];
        [mgdAchievement setValue:[NSNumber numberWithLong:achievement.hoursForReward] forKey:KEY_HOURS_REWARD];
        [mgdAchievement setValue:[NSNumber numberWithBool:achievement.hasAchieved] forKey:KEY_HAS_ACHIEVED];
        [mgdAchievement setValue:achievement.type forKey:KEY_TYPE];
    }
    else
    {
        for (Achievement *a in achievements)
        {
            [a setValue:[NSNumber numberWithLong:achievement.amountCurrently] forKey:KEY_AMOUNT_CURRENTLY];
            [a setValue:[NSNumber numberWithBool:achievement.hasAchieved] forKey:KEY_HAS_ACHIEVED];
        }
    }
    
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save achievement: %@",
              [error localizedDescription]);
    }
}
- (void)initializeAchievements
{
    [self fetchAchievements];
    if (self.achievementList.count != 0)
    {   // Achievements already in core data
        return;
    }
    
    // For number of posts
    NSArray *postNumbers = @[[NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:3],
                             [NSNumber numberWithInt:10],
                             [NSNumber numberWithInt:50],
                             [NSNumber numberWithInt:200],
                             [NSNumber numberWithInt:1000]];
    
    for (NSNumber *num in postNumbers)
    {
        long hours = [num longValue] * 10;
        Achievement *a = [[Achievement alloc] initWithCurrAmount:0
                                                          reqAmt:[num longValue]
                                                     rewardHours:hours
                                                        achieved:NO
                                                 achievementType:VALUE_POST_ACHIEVEMENT];
        
        [self addAchievement:a];
    }
    
    // For total points of posts
    NSArray *postPoints = @[[NSNumber numberWithInt:5],
                            [NSNumber numberWithInt:10],
                            [NSNumber numberWithInt:20],
                            [NSNumber numberWithInt:40],
                            [NSNumber numberWithInt:80],
                            [NSNumber numberWithInt:150],
                            [NSNumber numberWithInt:300],
                            [NSNumber numberWithInt:800]];
    
    for (NSNumber *num in postPoints)
    {
        long hours = [num longValue] * 10;
        Achievement *a = [[Achievement alloc] initWithCurrAmount:0
                                                          reqAmt:[num longValue]
                                                     rewardHours:hours
                                                        achieved:NO
                                                 achievementType:VALUE_SCORE_ACHIEVEMENT];
        
        [self addAchievement:a];
    }
    
    // Special
    Achievement *s1 = [[Achievement alloc] initWithCurrAmount:0
                                                      reqAmt:1
                                                 rewardHours:10
                                                    achieved:NO
                                             achievementType:VALUE_VIEW_ACHIEVEMENT];
    [self addAchievement:s1];
    
    Achievement *s2 = [[Achievement alloc] initWithCurrAmount:0
                                                      reqAmt:1
                                                 rewardHours:2000
                                                    achieved:NO
                                             achievementType:VALUE_SHORT_POST_ACHIEVEMENT];
    [self addAchievement:s2];
    
    Achievement *s3 = [[Achievement alloc] initWithCurrAmount:0
                                                      reqAmt:2000
                                                 rewardHours:2000
                                                    achieved:NO
                                             achievementType:VALUE_MANY_HOURS_ACHIEVEMENT];
    [self addAchievement:s3];
}

#pragma mark - Colleges

- (void)populateCollegeList
{
    if ([self needsNewCollegeList])
    {
        NSLog(@"Needs new college list, calling network fetch method");
        [self getNetworkCollegeList];
    }
    else
    {
        NSLog(@"College list is up to date, calling core data fetch method");
        [self getCoreDataCollegeList];
    }
}
- (BOOL)needsNewCollegeList
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:STATUS_ENTITY
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedStatus = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedStatus.count > 1)
    {
        NSLog(@"Too many status entities");
    }
    NSManagedObject *status = [fetchedStatus firstObject];
    
    if (status == nil)
    {
        return YES;
    }
    
    long newVersion = [self getNetworkCollegeListVersion];
    long currVersion = [[status valueForKeyPath:KEY_COLLEGE_LIST_VERSION] longValue];
    
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
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"allColleges", @"feedName", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetching" object:self userInfo:userInfo];
    }
}
- (void)getNetworkCollegeList
{
    [self fetchObjectsOfType:COLLEGE
                   IntoArray:self.collegeList
          WithFeedIdentifier:@"allColleges"
           WithFetchFunction:^{

               return [Networker GETAllColleges];
           }];
    
    [self writeCollegestoCoreData];
    
    long version = [self getNetworkCollegeListVersion];
    [self updateCollegeListVersion:version];
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
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COLLEGE_ENTITY
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
- (NSString *)getCollegeNameById:(long)Id
{
    College *college = [self getCollegeById:Id];
    return college == nil ? @"" : college.name;
}
- (College *)getCollegeById:(long)Id
{
    if (Id == 0) return nil;
    
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
- (void)getCoreDataCollegeList
{   // Populate the college list with a recent
    // list of colleges instead of accessing the network
    
    NSError *error;
    // Retrieve Colleges
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:COLLEGE_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedColleges = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedColleges.count < 50)
    {
        [self getNetworkCollegeList];
        return;
    }
    for (NSManagedObject *college in fetchedColleges)
    {
        long collegeId = [[college valueForKey:KEY_COLLEGE_ID] longValue];
        float lon = [[college valueForKey:KEY_LON] floatValue];
        float lat = [[college valueForKey:KEY_LAT] floatValue];
        NSString *name = [college valueForKey:KEY_NAME];
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
    College *college = [self getCollegeById:collegeId];
    return [self.nearbyColleges containsObject:college];
}
- (void)updateCollegeListVersion:(long)listVersion
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
    [status setValue:[NSNumber numberWithLong:listVersion] forKeyPath:KEY_COLLEGE_LIST_VERSION];
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save college list version: %@",
              [error localizedDescription]);
    }
    else
    {
        NSLog(@"Saved college list version %ld", listVersion);
    }
    
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

            NSDate *commentTime = [networkComment getCreated_at];
            [self updateLastCommentTime:commentTime];
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
            if (networkPost.college_id == 0)
            {
                [networkPost setCollege_id:[NSNumber numberWithLong:collegeId]];
            }
            College *college = [self getCollegeById:collegeId];
            [networkPost setCollege:college];
            NSDate *postTime = [networkPost getCreated_at];
            [self updateLastPostTime:postTime];
            
            [self.recentPostsAllColleges insertObject:networkPost atIndex:0];
            [self.recentPostsSingleCollege insertObject:networkPost atIndex:0];
            [self.userPosts insertObject:networkPost atIndex:0];
            [self savePost:networkPost];
            
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
                                        WithCollegeId:self.collegeInFocus.collegeID];
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
                                           WithCollegeId:self.collegeInFocus.collegeID];
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
                                   WithCollegeId:self.collegeInFocus.collegeID];
           }];
}

- (void)retrieveUserPosts
{
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

#pragma mark - Tag Fetching

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
                                            WithCollegeId:self.collegeInFocus.collegeID];
           }];
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

#pragma mark - Local Data Access

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
- (void)retrieveUserData
{
    [self retrieveUserVotes];
//    [self retrieveUserPosts];
//    [self retrieveUserComments];
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

#pragma mark - Helper Methods

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
                            College *college = [self getCollegeById:[[post getCollege_id] longValue]];
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
                            [arr addObject:[[College alloc] initFromJSON:jsonObject]];
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
- (BOOL)isAbleToPost:(NSNumber *)minutesRemaining
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
    NSDate *lastPost = [status valueForKey:KEY_POST_TIME];
    if (lastPost != nil)
    {
        NSTimeInterval diff = [lastPost timeIntervalSinceNow];
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
    NSDate *lastComment = [status valueForKey:KEY_COMMENT_TIME];
    if (lastComment != nil)
    {
        NSTimeInterval diff = [lastComment timeIntervalSinceNow];
        float minSeconds = MINIMUM_COMMENTING_INTERVAL_MINUTES * 60;
        if (abs(diff) < minSeconds)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)updateLastPostTime:(NSDate *)postTime
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
    [status setValue:postTime forKeyPath:KEY_POST_TIME];
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user's post time: %@",
              [error localizedDescription]);
    }
}
- (void)updateLastCommentTime:(NSDate *)commentTime
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
    [status setValue:commentTime forKeyPath:KEY_COMMENT_TIME];
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Failed to save user's comment time: %@",
              [error localizedDescription]);
    }
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
