//
//  ChildCellDelegate.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/29/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class College;
@class Vote;
@class CollegePickerViewController;

@protocol ChildCellDelegate <NSObject>

- (void)displayCannotVote;
- (BOOL)castVote:(Vote *)vote;
- (BOOL)cancelVote:(Vote *)vote;
- (void)didSelectTag:(NSString *)tagMessage;

@end
