//
//  TableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "TableCellProtocol.h"
#import "ChildCellDelegate.h"

@class Model;
@class Post;
@class Vote;

@protocol SubViewDelegate;
@protocol ChildCellDelegate;
@protocol PostAndCommentProtocol;
@protocol CFModelProtocol;

@interface TableCell : UITableViewCell <TableCellProtocol, TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSObject<PostAndCommentProtocol, CFModelProtocol> *object;
@property (nonatomic, strong) id<ChildCellDelegate> delegate;
@property (nonatomic) BOOL isNearCollege;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downVoteButton;
@property (weak, nonatomic) IBOutlet UIImageView *gpsIconImageView;
@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pictureHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collegeLabelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dividerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collegeLabelViewHeight;

//- (BOOL)assignmentSuccessWith:(NSObject *)obj;
- (NSString *)getCommentLabelString;
- (NSString *)getAgeLabelString:(NSDate *)creationDate;
- (void)findHashTags;
- (void)updateVoteButtons;
- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;



- (void)assignWith:(NSObject<PostAndCommentProtocol, CFModelProtocol> *)obj IsNearCollege:(BOOL)isNearby WithMessageHeight:(float)height;


@end