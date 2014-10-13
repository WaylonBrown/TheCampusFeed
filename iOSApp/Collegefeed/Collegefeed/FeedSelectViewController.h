//
//  FeedSelectViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_HEADER_HEIGHT 25
#define TABLE_CELL_HEIGHT 44

@class College;
@class DataController;

@protocol FeedSelectionProtocol <NSObject>

- (void)submitSelectionForFeedWithCollegeOrNil:(College *)college;
- (void)showDialogForAllColleges;

@end

@protocol CollegeForPostingSelectionProtocol <NSObject>

- (void)submitSelectionForPostWithCollege:(College *)college;

@end

typedef NS_ENUM(NSInteger, FeedSelectorType)
{
    // When selecting a feed to view
    ALL_NEARBY_OTHER,
    
    // When looking through all possible colleges
    ALL_COLLEGES_WITH_SEARCH,
    
    // When deciding which college to post to
    ONLY_NEARBY_COLLEGES,
};

@interface FeedSelectViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) id<FeedSelectionProtocol> feedDelegate;
@property (strong, nonatomic) id<CollegeForPostingSelectionProtocol> postingDelegate;
@property (strong, nonatomic) DataController *dataController;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dialogVerticalAlignment;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) FeedSelectorType type;

- (id)initWithType:(FeedSelectorType)type WithDataController:(DataController *)controller WithFeedDelegate:(id<FeedSelectionProtocol>) delegate;

- (id)initWithType:(FeedSelectorType)type WithDataController:(DataController *)controller WithPostingDelegate:(id<CollegeForPostingSelectionProtocol>) delegate;


- (IBAction)dismiss;
- (void)fixHeights;
- (void)updateLocation;

@end
