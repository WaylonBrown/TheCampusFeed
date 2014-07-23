//
//  TableCell.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class Model;
@class Vote;

@protocol SubViewDelegate;
@protocol ChildCellDelegate;
@protocol PostAndCommentProtocol;
@protocol CFModelProtocol;

@interface TableCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSObject<PostAndCommentProtocol, CFModelProtocol> *object;

@property (weak, nonatomic) id<ChildCellDelegate> delegate;
@property (nonatomic) BOOL userIsNearCollege;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downVoteButton;
@property (weak, nonatomic) IBOutlet UIView *enclosingView;
@property (weak, nonatomic) IBOutlet UIImageView *gpsIconImageView;
@property (strong, nonatomic) IBOutlet UIView *dividerView;

- (void)assign:(NSObject<PostAndCommentProtocol> *)obj;
- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;

@end