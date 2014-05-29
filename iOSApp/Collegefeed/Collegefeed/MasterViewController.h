//
//  MasterViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/15/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableCell.h"

@class College;
@class PostDataController;
@class TagDataController;
@class CollegeDataController;
@class CommentDataController;
@class VoteDataController;
@protocol MasterViewDelegate;

@interface MasterViewController : UIViewController <ChildCellDelegate>

@property (nonatomic, weak) id<MasterViewDelegate> delegate;

@property (strong, nonatomic) PostDataController    *postDataController;
@property (strong, nonatomic) CommentDataController *commentDataController;
@property (strong, nonatomic) CollegeDataController *collegeDataController;
@property (strong, nonatomic) TagDataController     *tagDataController;
@property (strong, nonatomic) VoteDataController    *voteDataController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *collegeSegmentControl;
@property (weak, nonatomic) IBOutlet UIImageView        *logoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *createButton;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;

//@property (strong, nonatomic) College *currentCollege;
//@property (nonatomic) BOOL allColleges;
//@property (nonatomic) BOOL specificCollege;

- (id)initWithDataControllers:(NSArray *)dataControllers;

- (NSArray *)getDataControllers;
//- (void)switchToAllColleges;
//- (void)switchToSpecificCollege;

- (IBAction)create:(id)sender;
- (IBAction)changeFeed:(id)sender;
- (void)refresh;

@end

@protocol MasterViewDelegate <NSObject>

- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (College*)getCurrentCollege;
- (BOOL)getIsAllColleges;
- (BOOL)getIsSpecificCollege;

@end