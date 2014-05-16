//
//  CollegeViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/16/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "MasterViewController.h"

@class College;

@interface CollegeViewController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) College *selectedCollege;

@end
