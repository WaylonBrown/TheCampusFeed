//
//  FeedSelectViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedSelectionProtocol.h"

@class College;
@class DataController;

@interface FeedSelectViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) id<FeedSelectionProtocol> feedDelegate;
@property (strong, nonatomic) DataController *dataController;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) IBOutlet UIView *nearYouHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *nearYouLabel;

@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogVerticalAlignment;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithDataController:(DataController *)controller;

- (id)initWithDataController:(DataController *)controller WithFeedDelegate:(id<FeedSelectionProtocol>) delegate;

- (IBAction)dismiss;
- (void)fixHeights;
- (void)updateLocation;

@end
