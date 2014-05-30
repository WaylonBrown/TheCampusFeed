//
//  TagViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Tag;

@interface TagViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Tag* selectedTag;

@end
