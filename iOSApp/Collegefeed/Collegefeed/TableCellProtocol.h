//
//  TableCellProtocol.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/12/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableCellProtocol <NSObject>

- (BOOL)assignmentSuccessWith:(NSObject *)obj;

- (CGFloat)getMessageHeight;
- (CGFloat)getCellHeight;

+ (CGFloat)getCellHeight:(NSObject *)obj;
+ (CGFloat)getMessageHeight:(NSString *)text;

@end