//
//  TagViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Tag;

@interface TagViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) Tag* selectedTag;
@property (nonatomic, strong) NSMutableArray *filteredList;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *searchResultsController;

@end
