//
//  TableCell.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "ChildCellDelegate.h"

#define DEFAULT_COLLEGE_LABEL_HEIGHT 33

@class Model;
@class Post;
@class Comment;
@class Vote;

@protocol SubViewDelegate;
@protocol ChildCellDelegate;
@protocol PostAndCommentProtocol;
@protocol CFModelProtocol;

@interface TableCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSObject<PostAndCommentProtocol, CFModelProtocol> *object;
@property (nonatomic, strong) id<ChildCellDelegate> delegate;
@property (nonatomic) BOOL isNearCollege;

@property (nonatomic, strong) Post* post;
@property (nonatomic, strong) Comment* comment;

// UI properties
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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pictureActivityIndicator;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pictureHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collegeLabelViewHeight;

- (NSString *)getCommentLabelString;
- (NSString *)getAgeLabelString:(NSDate *)creationDate;
- (void)findHashTags;
- (void)updateVoteButtons;
- (IBAction) upVotePressed:(id)sender;
- (IBAction) downVotePresed:(id)sender;
- (BOOL)assignWithComment:(Comment *)comment;

- (BOOL)assignWithPost:(Post *)post withCollegeLabel:(BOOL)showLabel;
- (void)setNearCollege;
- (void)setWillDisplayCollege:(BOOL)showLabel;

@end