//
//  PostTableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//
// a subclass of UITableViewCell to enable custom properties

#import <UIKit/UIKit.h>
//#import "PostsViewController.h"

@class Post;
@protocol PostSubViewDelegate;


@interface PostTableCell : UITableViewCell

@property (nonatomic) Post* post;
@property (nonatomic) int dummyVoteValue;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UIButton *upVoteButton;
@property (strong, nonatomic) IBOutlet UIButton *downVoteButton;
@property (nonatomic, weak) IBOutlet UILabel *collegeLabel;

- (NSString *)getAgeAsString:(NSDate *)creationDate;
- (void) assignPropertiesWithPost:(Post *)post;
- (void) assignProperties;
- (void) updateVoteButtonsWithVoteValue:(int)vote;
- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;

@end

@interface PostTableCellWithCollege : PostTableCell

@end
