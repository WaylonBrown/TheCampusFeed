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
}
- (void)assignCollege:(College *)college withRankNumberOrNil:(NSNumber *)rankNo
{
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
}
- (void)assignAchievement:(Achievement *)achievement
{
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    if (achievement != nil)
    {
        [self.messageLabel setText:[achievement toString]];
        if (achievement.hasAchieved)
        {
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[achievement toString]];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@2
                                    range:NSMakeRange(0, [attributeString length])];
            
            [self.messageLabel setAttributedText:attributeString];
        }
    }
    else
    {
        [self.messageLabel setText:@""];
    }

}
- (void)showLoadingIndicator
{
    [self.activityIndicator startAnimating];
}
- (void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
}

@end
