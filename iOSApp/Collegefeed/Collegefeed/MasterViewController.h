//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildCellDelegate.h"
#import "CreatePostCommentViewController.h"
#import "SelectCollegeViewController.h"
#import "DataController.h"

@protocol CollegeSelectionProtocol;

@interface MasterViewController : UIViewController <ChildCellDelegate, CreationViewProtocol, CollegeSelectionProtocol>

@property (strong, nonatomic) DataController *dataController;

// outlet properties connected to the view
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView             *feedToolbar;
@property (strong, nonatomic) UIRefreshControl          *refreshControl;

@property (weak, nonatomic) IBOutlet UILabel            *currentFeedLabel;
@property (weak, nonatomic) IBOutlet UILabel            *showingLabel;
@property (weak, nonatomic) IBOutlet UIButton           *feedButton;

@property (strong, nonatomic) NSMutableArray *list;

// Initialization
- (id)initWithDataController:(DataController *)controller;

- (void)placeLoadingIndicator;
- (void)placeCreatePost;
- (void)foundLocation;
- (void)didNotFindLocation;

// Actions
- (IBAction)changeFeed;
- (void)create;
- (void)refresh;

@end

typedef NS_ENUM(NSInteger, ViewSortingStyle)
{
    ALL,
    TOP,
    RECENT,
    USER,
    TAG,
};