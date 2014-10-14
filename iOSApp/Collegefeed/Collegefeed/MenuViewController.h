//
//  MenuViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define MENU_CELL_HEIGHT 60
#define TOP_POSTS_INDEX 0
#define NEW_POSTS_INDEX 1
#define HELP_INDEX 7
#define FEEDBACK_INDEX 8

@interface MenuViewController : UIViewController<UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *viewControllers;
@property NSInteger selectedIndex;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)showTutorial;
- (void)showRequiresUpdate;

@end
