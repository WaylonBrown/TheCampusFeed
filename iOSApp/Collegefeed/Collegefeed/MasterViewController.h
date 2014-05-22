//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCell.h"

// Controller to display a list of either:
// Posts, Colleges, or Tags (Comment has unique one)

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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;

@end
