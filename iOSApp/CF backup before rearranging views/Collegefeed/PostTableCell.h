//
//  PostTableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//
// a subclass of UITableViewCell to enable custom properties

#import <UIKit/UIKit.h>

@interface PostTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UIButton *upVoteButton;
@property (strong, nonatomic) IBOutlet UIButton *downVoteButton;

@end

