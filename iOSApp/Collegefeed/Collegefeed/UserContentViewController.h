//
//  UserContentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/9/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserContentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// UI properties
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;


// Data properties
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *commentArray;

@end
