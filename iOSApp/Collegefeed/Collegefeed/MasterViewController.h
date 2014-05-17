//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controller to display a list of either:
// Posts, Colleges, or Tags (Comment has unique one)

@class PostDataController;
@class TagDataController;
@class CollegeDataController;

@interface MasterViewController : UIViewController

@property (strong, nonatomic) PostDataController *postDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController *tagDataController;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)createPost:(id)sender;

@end