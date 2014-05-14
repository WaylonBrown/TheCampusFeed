//
//  CommentTableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTableCell.h"

@class Comment;

//@protocol PostSubViewDelegate;

@interface CommentTableCell : PostTableCell

//@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
//@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
//@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
//
//@property (strong, nonatomic) IBOutlet UIButton *upVoteButton;
//@property (strong, nonatomic) IBOutlet UIButton *downVoteButton;


@property (nonatomic) Comment* comment;

- (void) setComment:(Comment*)newComment;

- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;

@end
