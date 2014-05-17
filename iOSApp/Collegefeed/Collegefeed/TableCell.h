//
//  TableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class Post;
@class Comment;

@protocol SubViewDelegate;

@interface TableCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) Post* cellPost;
@property (nonatomic, strong) Comment* cellComment;

@property (nonatomic, weak) IBOutlet TTTAttributedLabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UILabel *collegeLabel;
@property (nonatomic, weak) IBOutlet UIButton *upVoteButton;
@property (nonatomic, weak) IBOutlet UIButton *downVoteButton;

- (void)setAsPostCell:(Post *)post;
- (void)setAsCommentCell:(Comment*)newComment;
- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;

@end
