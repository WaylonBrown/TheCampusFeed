//
//  TagCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tag;
@class College;

@interface SimpleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (void)assignTag:(Tag *)tag;
- (void)assignCollege:(College *)college;

@end