//
//  CFNavigationController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/7/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "CFNavigationController.h"

#import "CommentViewController.h"
#import "CreatePostCommentViewController.h"
#import "DataController.h"
#import "IIViewDeckController.h"
#import "MenuViewController.h"
#import "NewPostsViewController.h"
#import "TagPostsViewController.h"
#import "TagViewController.h"
#import "TopPostsViewController.h"
#import "ToastController.h"
#import "TrendingCollegesViewController.h"
#import "TutorialViewController.h"
#import "UserPostsViewController.h"
#import "UserCommentsViewController.h"

#import "TheCampusFeed-Swift.h"

@interface CFNavigationController ()

// Data
@property (strong, nonatomic) DataController *dataController;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *myLocation;

@property (strong, nonatomic) ToastController *toastController;

// View Controllers
@property (strong, nonatomic) IIViewDeckController *deckController;
@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) TopPostsViewController *topPostsController;
@property (strong, nonatomic) NewPostsViewController *recentPostsController;
@property (strong, nonatomic) TagViewController *trendingTagController;
@property (strong, nonatomic) TagPostsViewController *taggedPostsController;
@property (strong, nonatomic) CollegePickerViewController *collegeController;
@property (strong, nonatomic) UserPostsViewController* userPostsController;
@property (strong, nonatomic) UserCommentsViewController *userCommentsController;
@property (strong, nonatomic) TrendingCollegesViewController*trendingCollegesController;
@property (strong, nonatomic) TutorialViewController *tutorialController;
@property (strong, nonatomic) CF_DialogViewController *helpController;
@property (strong, nonatomic) TimeCrunchViewController *timeCrunchController;
@property (strong, nonatomic) AchievementViewController *achievementController;

@end

@implementation CFNavigationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dataController = [[DataController alloc] init];
        [self startMyLocationManager];
        [self buildViewsWithDataController:self.dataController];
        [self setUpMenuBar];
        [self showDialogForLaunchCount:self.dataController.launchCount];

        [self pushViewController:[self getMyDeckController] animated:NO];
    }
    
    return self;
}
- (void)buildViewsWithDataController:(DataController *)data
{
    if (data == nil)
    {
        NSLog(@"CFNavigationController received a nil DataController object in buildViewControllers");
        return;
    }
    
    self.topPostsController = [[TopPostsViewController alloc] initWithDataController:data];
    
    self.recentPostsController = [[NewPostsViewController alloc] initWithDataController:data];
    
    self.trendingTagController = [[TagViewController alloc] initWithDataController:data];
    
    self.trendingCollegesController = [[TrendingCollegesViewController alloc]
                                       initWithDataController:data];
    
    self.userPostsController = [[UserPostsViewController alloc] initWithDataController:data];
    
    
    
    self.userCommentsController = [[UserCommentsViewController alloc] initWithDataController:data];
    
    self.tutorialController = [[TutorialViewController alloc] init];
    
    self.helpController = [[CF_DialogViewController alloc] initWithDialogType:HELP];
    
    self.timeCrunchController = [[TimeCrunchViewController alloc] initWithDataController:data];
    
    self.achievementController = [[AchievementViewController alloc] initWithDataController:data];
    
    self.taggedPostsController = [[TagPostsViewController alloc] initWithDataController:data];
}

#pragma mark - View configuration

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedToast:) name:@"ToastMessage" object:nil];
}
- (BOOL)shouldAutorotate
{
    id currentViewController = self.topViewController;
    
    if ([currentViewController isKindOfClass:[IIViewDeckController class]])
    {
        currentViewController = ((IIViewDeckController *)currentViewController).centerController;
    }
    
    if ([currentViewController isKindOfClass:[TimeCrunchViewController class]]
        || [currentViewController isKindOfClass:[CreatePostCommentViewController class]])
        
        return NO;
    
    return YES;
}
- (void)setUpMenuBar
{
    [self.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[Shared getCustomUIColor:CF_BLUE]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"TheCampusFeedLogo"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(openLeftMenu)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -16;
    [[self getMyDeckController] navigationItem].leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, menuButton, nil];
    
}

#pragma mark - Actions

- (void)showDialogForLaunchCount:(long)count
{
    if (count == 1)
    {
        [[self getMyMenuViewController] showTutorial];
    }
    else if (count == 5)
    {
        CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:TWITTER];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
    }
    else if (count == 10)
    {
        CF_DialogViewController *dialog = [[CF_DialogViewController alloc] initWithDialogType:WEBSITE];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dialog animated:YES completion:nil];
    }
}
- (void)openLeftMenu
{
    if ([[self getMyDeckController] isSideOpen:IIViewDeckLeftSide])
    {
        [[self getMyDeckController] closeLeftView];
    }
    else
    {
        [[self getMyDeckController] openLeftView];
    }
}
- (void)didSelectTag:(NSString *)tagMessage
{
    if (self.taggedPostsController == nil)
    {
        self.taggedPostsController = [[TagPostsViewController alloc] initWithDataController:self.dataController];
    }
    
    if ([self.taggedPostsController assignTagMessage:tagMessage])
    {
        [[self navigationItem] setBackBarButtonItem:[self getBlankBackButton]];
        [self pushViewController:self.taggedPostsController animated:YES];
    }
}

#pragma mark - Toasts

- (void)receivedToast:(NSNotification *)notification
{
    NSLog(@"%@ received Toast in a notification observer", [self class]);
    
    NSString *selectorString = [[notification userInfo] valueForKey:@"selector"];
    SEL selector = NSSelectorFromString(selectorString);
    IMP imp = [[self getMyToastController] methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func([self getMyToastController], selector);
}

#pragma mark - Lazy loaded objects

- (UIBarButtonItem *)getBlankBackButton
{
    return [[UIBarButtonItem alloc]
            initWithTitle:@""
            style:UIBarButtonItemStylePlain
            target:nil
            action:nil];
}
- (UIBarButtonItem *)getLoadingBarButtonItem
{
    if (self.locationActivityIndicator == nil)
    {
        self.locationActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:self.locationActivityIndicator];
    [self.locationActivityIndicator startAnimating];
    
    return button;
}
- (MenuViewController *)getMyMenuViewController
{
    if (self.menuViewController == nil)
    {
        self.menuViewController = [[MenuViewController alloc] initWithViewControllers:[self getMyViewControllers]];
        self.menuViewController.view.layer.borderWidth = 0;
        self.menuViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        self.menuViewController.view.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        
        // TODO: play with this thing to fix shadows
        self.menuViewController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    }
    
    return self.menuViewController;
}
- (NSArray *)getMyViewControllers
{
    return [NSArray arrayWithObjects:
            self.topPostsController,
            self.recentPostsController,
            self.trendingTagController,
            self.trendingCollegesController,
            self.userPostsController,
            self.userCommentsController,
            self.achievementController,
            self.timeCrunchController,
            self.helpController, nil];
}
- (IIViewDeckController *)getMyDeckController
{
    if (self.deckController == nil)
    {
        self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.topPostsController leftViewController:[self getMyMenuViewController]];
        
        self.deckController.openSlideAnimationDuration = 0.25f;
        self.deckController.closeSlideAnimationDuration = 0.25f;
        self.deckController.leftSize = 100.0f;
        self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    }
    
    return self.deckController;
}

#pragma mark - Location 

- (ToastController *)getMyToastController
{
    if (self.toastController == nil)
    {
        self.toastController = [[ToastController alloc] init];
    }
    
    return self.toastController;
}
- (CLLocationManager *)startMyLocationManager
{
    NSLog(@"CFNavController.startMyLocationManager() called");
    self.dataController.locationStatus = LOCATION_SEARCHING;
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
        
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    [self.locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationSearchingDidStart" object:nil];
    
    return self.locationManager;
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location manager updated location");
    self.dataController.locationStatus = LOCATION_FOUND;
    
    if (!self.myLocation)
    {
        self.myLocation = newLocation;
    }
    
    if (newLocation.coordinate.latitude != self.myLocation.coordinate.latitude &&
        newLocation.coordinate.longitude != self.myLocation.coordinate.longitude)
    {
        self.myLocation = newLocation;
        NSLog(@"New location found: %f, %f",
              self.myLocation.coordinate.latitude,
              self.myLocation.coordinate.longitude);
        [self.locationManager stopUpdatingLocation];
        [self.dataController setFoundUserLocationWithLat:self.myLocation.coordinate.latitude
                                              withLon:self.myLocation.coordinate.longitude];
    }
    
    [self.locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationSearchingDidEnd" object:nil];

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed Location Finding: %@", [error localizedDescription]);
    self.dataController.locationStatus = LOCATION_NOT_FOUND;
    [self.locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationSearchingDidEnd" object:nil];

    [self.dataController queueToastWithSelector:@selector(toastLocationSearchFailed)];
}


@end
