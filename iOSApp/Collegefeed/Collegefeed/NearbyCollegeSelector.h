//
//  NearbyCollegeSelector.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/7/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CustomIOS7AlertView.h"

@class AppData;
@class College;

@interface NearbyCollegeSelector : UIView<CustomIOS7AlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AppData* appData;

- (id)initWithAppData:(AppData *)appData;
- (void)displaySelectorForNearbyColleges:(NSArray *)colleges;
- (void)displayPostToCollege:(College *)college;

@end
