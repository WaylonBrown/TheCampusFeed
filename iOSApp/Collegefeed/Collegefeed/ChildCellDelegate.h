//
//  ChildCellDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/29/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class College;
@class Vote;
@class CollegePickerViewController;

@protocol ChildCellDelegate <NSObject>

- (void)selectedCollege:(College *)college from:(CollegePickerViewController *)sender;
- (void)castVote:(Vote *)vote;

@end
