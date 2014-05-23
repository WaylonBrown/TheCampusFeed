//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableCell.h"

@class PostDataController;
@class TagDataController;
@class CollegeDataController;
@class CommentViewController;
@class VoteDataController;

@interface MasterViewController : UIViewController <ChildCellDelegate>

@property (strong, nonatomic) PostDataController *postDataController;
@property (strong, nonatomic) CommentViewController *commentViewController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController *tagDataController;
@property (strong, nonatomic) VoteDataController *voteDataController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSegmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)create:(id)sender;
- (IBAction)changeFeed:(id)sender;

@end
