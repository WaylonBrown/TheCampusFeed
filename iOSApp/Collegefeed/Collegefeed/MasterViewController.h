//
//  MasterViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildCellDelegate.h"
#import "CreatePostCommentViewController.h"
#import "FeedSelectViewController.h"
#import "DataController.h"

@class ToastController;
@protocol FeedSelectionProtocol;

@interface MasterViewController : UIViewController <ChildCellDelegate, CreationViewProtocol, FeedSelectionProtocol, CollegeForPostingSelectionProtocol>

// Member variables
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) ToastController *toastController;
@property (strong, nonatomic) DataController *dataController;

// UI outlet properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *feedToolbar;
@property (strong, nonatomic) IBOutlet UIView *scoreToolbar;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *contentLoadingIndicator;
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

// Initialization
- (id)initWithDataController:(DataController *)controller;
- (void)placeLoadingIndicatorInToolbar;
- (void)placeCreatePost;

// Actions
- (void)finishedFetchRequest;
- (IBAction)changeFeed;
- (void)create;
- (void)refresh;

@end

typedef NS_ENUM(NSInteger, ViewType)
{
    ALL_VIEW,
    TOP_VIEW,
    RECENT_VIEW,
    USER_VIEW,
    USER_POSTS,
    USER_COMMENTS,
    TAG_VIEW,
};