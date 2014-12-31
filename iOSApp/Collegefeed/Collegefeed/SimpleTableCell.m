//
//  SimpleTableCell.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "SimpleTableCell.h"
#import "Tag.h"
#import "College.h"
#import "Shared.h"
#import "TheCampusFeed-Swift.h"

@implementation SimpleTableCell

- (void)awakeFromNib
{
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"card_without_9patch.png"];
//    top = 1, left = 3, bottom = 6, right = 4
    UIImage *stretchableBackground = [image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 5, 8, 6)resizingMode:UIImageResizingModeStretch];
    self.myImageView.image = stretchableBackground;
    
    
    // Set font styles
    [self.messageLabel setTintColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    [self.activityIndicator setHidesWhenStopped:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)assignSimpleText:(NSString *)text
{
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];
    [self.messageLabel setText:text];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)assignTag:(Tag *)tag
{
    self.labelHeight.constant = TABLE_CELL_HEIGHT;

    [self.messageLabel setFont:CF_FONT_LIGHT(22)];
    [self.messageLabel setNumberOfLines:1];
    [self.messageLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    if (tag != nil)
    {
        [self.messageLabel setText:tag.name];
    }
    else
    {
        [self.messageLabel setText:@""];
    }
    
    [self setNeedsUpdateConstraints];

}
- (void)assignCollege:(College *)college withRankNumberOrNil:(NSNumber *)rankNo
{
    self.labelHeight.constant = [SimpleTableCell getMessageHeight:college.name];
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];

    if (college != nil)
    {
        if (rankNo != nil)
        {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@. %@", rankNo, college.name]];
            [self.messageLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            [self.messageLabel setText:college.name];
            [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
    else
    {
        [self.messageLabel setText:@""];
    }
    
    [self setNeedsUpdateConstraints];

}
- (void)assignAchievement:(Achievement *)achievement
{
//    self.labelHeight.constant = [SimpleTableCell getMessageHeight:[achievement toString]];
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    if (achievement != nil)
    {
        [self.messageLabel setText:[achievement toString]];
    }
    else
    {
        [self.messageLabel setText:@""];
    }
    
//    [self setNeedsUpdateConstraints];

}
- (void)showLoadingIndicator
{
    [self.activityIndicator startAnimating];
}
- (void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
}

#pragma mark - Protocol Methods

- (CGFloat)getMessageHeight
{
    return SMALL_CELL_MIN_LABEL_HEIGHT;
}
- (CGFloat)getCellHeight
{
    return DEFAULT_CELL_HEIGHT;
}
+ (CGFloat)getMessageHeight:(NSString *)text
{
    float height = SMALL_CELL_MIN_LABEL_HEIGHT;
    if (text != nil && ![text isEqualToString:@""])
    {
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:text];
        UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SMALL_CELL_LABEL_WIDTH, 2000.0f)];
        [calculationView setAttributedText:aString];
        
        
        CGRect textRect = [calculationView.text
                           boundingRectWithSize:calculationView.frame.size
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:CF_FONT_LIGHT(18)}
                           context:ctx];
        
        height = textRect.size.height + MESSAGE_HEIGHT_TOP_CUSHION;
    }
    
    return MAX(height, SMALL_CELL_MIN_LABEL_HEIGHT);
}
+ (CGFloat)getCellHeight:(NSObject *)obj
{
    return DEFAULT_CELL_HEIGHT;
}

@end
