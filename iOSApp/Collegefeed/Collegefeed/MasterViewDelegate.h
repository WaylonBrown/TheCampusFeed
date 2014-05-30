//
//  MasterViewDelegate.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/29/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MasterViewDelegate <NSObject>

- (void)switchedToSpecificCollegeOrNil:(College *)college;
- (College*)getCurrentCollege;
- (BOOL)getIsAllColleges;
- (BOOL)getIsSpecificCollege;

@end