//
//  FeedSelectionProtocol.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/3/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

@class College;

@protocol FeedSelectionProtocol <NSObject>

- (void)switchToFeedForCollegeOrNil:(College *)college;
- (void)showDialogForAllColleges;

@end
