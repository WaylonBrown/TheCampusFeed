//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildCellDelegate.h"
#import "AppData.h"

@interface MasterViewController : UIViewController <ChildCellDelegate>

@property (strong, nonatomic) AppData *appData;

// outlet properties connected to the view
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;

//@property (strong, nonatomic) UIBarButtonItem           *createButton;
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicator;

// Initialization
- (id)initWithAppData:(AppData *)data;

- (void)placeLoadingIndicator;
- (void)placeCreatePost;

// Actions
- (IBAction)changeFeed;
- (void)create;
- (void)refresh;

@end
