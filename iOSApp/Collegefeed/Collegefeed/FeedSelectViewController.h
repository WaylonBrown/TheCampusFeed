//
//  FeedSelectViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_HEADER_HEIGHT 30

@class College;
@protocol FeedSelectionProtocol <NSObject>

- (void)submitSelectionForFeedWithCollegeOrNil:(College *)college;

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

@interface FeedSelectViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<FeedSelectionProtocol> feedDelegate;
@property (strong, nonatomic) id<CollegeForPostingSelectionProtocol> postingDelegate;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSArray *fullCollegeList;
@property (weak, nonatomic) NSArray *nearbyCollegeList;

@property (nonatomic) FeedSelectorType type;

- (id)initWithType:(FeedSelectorType)type;

- (IBAction)dismiss;

@end
