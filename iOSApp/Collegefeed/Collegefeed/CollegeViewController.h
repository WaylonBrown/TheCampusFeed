//
//  CollegeViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/22/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MasterViewController.h"
#import "SimpleTableCell.h"
#import "College.h"

@interface CollegeViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithDataController:(DataController *)controller;
- (void)loadView;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)fetchContent;
- (void)finishedFetchRequest:(NSNotification *)notification;


@end
