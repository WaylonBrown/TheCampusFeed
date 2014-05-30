//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildCellDelegate.h"
#import "MasterViewDelegate.h"

@class College;
@class PostDataController;
@class TagDataController;
@class CollegeDataController;
@class CommentDataController;
@class VoteDataController;


@interface MasterViewController : UIViewController <ChildCellDelegate>

// delegate to allow all subclass ViewControllers to access the shared objects in AppDelegate.h (e.g. DataControllers, universal selection of college, etc.
@property (nonatomic, weak) id<MasterViewDelegate> delegate;

// data controllers
@property (strong, nonatomic) PostDataController    *postDataController;
@property (strong, nonatomic) CommentDataController *commentDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController     *tagDataController;
@property (strong, nonatomic) VoteDataController    *voteDataController;

// outlet properties connected to the view
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSegmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *createButton;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;

// Initialization
- (id)initWithDataControllers:(NSArray *)dataControllers;

// Data Access
- (NSArray *)getDataControllers;

// Actions
- (IBAction)changeFeed;
- (void)create;
- (void)refresh;

@end
