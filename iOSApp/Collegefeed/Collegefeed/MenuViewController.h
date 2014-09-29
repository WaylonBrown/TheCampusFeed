//
//  MenuViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define MENU_CELL_HEIGHT 60
#define FEEDBACK_INDEX 8
#define HELP_INDEX 7

@interface MenuViewController : UIViewController<UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *navControllers;

- (id)initWithNavControllers:(NSArray *)navControllers;


@property (strong, nonatomic) NSArray *viewControllers;
@property NSInteger selectedIndex;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)showTutorial;

@end
