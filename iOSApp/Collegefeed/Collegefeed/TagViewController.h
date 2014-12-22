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

@interface TagViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) Tag* selectedTag;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@end
