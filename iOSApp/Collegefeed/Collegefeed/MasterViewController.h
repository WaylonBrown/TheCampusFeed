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

@interface MasterViewController : UIViewController <ChildCellDelegate>

// delegate to allow all subclass ViewControllers to access the shared objects in AppDelegate.h (e.g. DataControllers, universal selection of college, etc.
@property (nonatomic, weak) id<MasterViewDelegate> appDelegate;

// outlet properties connected to the view
@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSegmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *createButton;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;

// Initialization
- (id)initWithDelegateId:(id<MasterViewDelegate>)delegate;

// Actions
- (IBAction)changeFeed;
- (void)create;
- (void)refresh;

@end
