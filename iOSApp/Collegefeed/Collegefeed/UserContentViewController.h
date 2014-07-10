//
//  UserContentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 7/9/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController;

@interface UserContentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

//- (id)initWithDataController:(DataController *)controller;
- (id)initWithPosts:(NSArray *)userPosts withComments:(NSArray *)userComments;

// UI properties
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;


// Data properties
//@property (strong, nonatomic) DataController *dataController;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *commentArray;

@end
