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

@protocol ChildCellDelegate;

@interface CollegePickerViewController : UIViewController

@property (nonatomic, weak) id<ChildCellDelegate> delegate;

@property (strong, atomic) NSMutableArray *list;
@property (strong, atomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) BOOL topColleges;
@property (nonatomic) BOOL allColleges;

- (id)initAsTopColleges;
- (id)initAsAllColleges;

- (void)setCollegesList:(NSMutableArray *)collegeList;

- (IBAction)cancel:(id)sender;

@end
