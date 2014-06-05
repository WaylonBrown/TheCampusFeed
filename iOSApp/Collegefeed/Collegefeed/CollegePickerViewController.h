//
//  CollegePickerViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/23/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;
@class Vote;
@class AppData;

@protocol ChildCellDelegate;

@interface CollegePickerViewController : UIViewController

@property (nonatomic, weak) id<ChildCellDelegate> delegate;

@property (strong, nonatomic) AppData *appData;

@property (strong, atomic) NSMutableArray *list;
@property (strong, atomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) BOOL topColleges;
@property (nonatomic) BOOL allColleges;

- (id)initAsTopCollegesWithAppData:(AppData*)data;
- (id)initAsAllCollegesWithAppData:(AppData*)data;

@end
