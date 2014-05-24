//
//  CollegePickerViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/23/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollegePickerViewController : UIViewController

@property (strong, atomic) NSMutableArray *list;
@property (strong, atomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


- (void)setCollegesList:(NSMutableArray *)collegeList;

- (IBAction)cancel:(id)sender;

@end
