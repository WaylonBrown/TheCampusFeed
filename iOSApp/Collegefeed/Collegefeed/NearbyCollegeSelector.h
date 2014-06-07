//
//  NearbyCollegeSelector.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/7/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@class AppData;

@interface NearbyCollegeSelector : UIView<CustomIOS7AlertViewDelegate>

@property (strong, nonatomic) AppData* appData;

- (id)initWithAppData:(AppData *)appData;
- (void)displaySelectorForNearbyColleges:(NSArray *)colleges;
- (void)displayPostToCollege:(UIButton*)sender;

@end
