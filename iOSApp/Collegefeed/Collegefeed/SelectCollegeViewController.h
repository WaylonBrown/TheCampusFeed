//
//  SelectCollegeViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class College;
@protocol CollegeSelectionProtocol <NSObject>

- (void)submitSelectionWithCollegeOrNil:(College *)college;

@end

@interface SelectCollegeViewController : UIViewController<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<CollegeSelectionProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSMutableArray *fullCollegeList;
@property (weak, nonatomic) NSMutableArray *nearbyCollegeList;


- (IBAction)dismiss;

@end
