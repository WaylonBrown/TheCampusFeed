//
//  MasterViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildCellDelegate.h"
#import "CreateViewController.h"
#import "FeedSelectViewController.h"
#import "DataController.h"
#import "CreateViewController.h"
#import "PostingSelectionProtocol.h"
#import "FeedSelectionProtocol.h"

@class ToastController;

@interface MasterViewController : UIViewController <ChildCellDelegate, CreationViewProtocol, FeedSelectionProtocol, PostingSelectionProtocol>

#pragma mark - Variables

// Member variables
@property (strong, nonatomic) NSMutableArray *list;
//@property (strong, nonatomic) ToastController *toastController;
@property (strong, nonatomic) DataController *dataController;

// UI outlet properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *locationActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *feedToolbar;
@property (strong, nonatomic) IBOutlet UIView *scoreToolbar;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *contentLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *currentFeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *showingLabel;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIView *toolbarSeparator;
@property (strong, nonatomic) IBOutlet UILabel *chooseLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolBarSpaceFromBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewSpaceFromBottom;

// Status variables
@property (nonatomic) float previousScrollViewYOffset;
@property (nonatomic) BOOL isLoadingPosts;
@property (nonatomic) BOOL isShowingTutorial;
@property (nonatomic) BOOL hasFinishedFetchRequest;
@property (nonatomic) BOOL hasFetchedAllContent;

// Child Views
@property (nonatomic) CreateViewController *createController;

#pragma mark - Public Functions

// Initialization
- (id)initWithDataController:(DataController *)controller;
- (id)initWithDataController:(DataController *)controller withNibName:(NSString *)nib bundle:(NSBundle *)bundle;
- (void)setNotificationObservers;

// Network Actions
- (void)fetchContent;
- (void)finishedFetchRequest:(NSNotification *)notification;

// Local Actions
- (IBAction)changeFeed;
- (void)create;

// Helper Methods
- (void)setCorrectList;
- (UIBarButtonItem *)blankBackButton;
- (void)receivedToast:(NSNotification *)notification;

@end
