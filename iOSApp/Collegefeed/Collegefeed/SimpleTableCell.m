//
//  SimpleTableCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "SimpleTableCell.h"
#import "Tag.h"
#import "College.h"
#import "Shared.h"

@implementation SimpleTableCell

- (void)awakeFromNib
{
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"card_without_9patch.png"];
    UIImage *stretchableBackground = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,15,15) resizingMode:UIImageResizingModeStretch];
    self.imageView.image = stretchableBackground;
    
    
    // Set font styles
    [self.messageLabel setTintColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    [self.activityIndicator setHidesWhenStopped:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

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
- (void)assignCollege:(College *)college withRankNumber:(long)rankNo
{
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];
    [self.messageLabel setNumberOfLines:6];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];

    if (college != nil)
    {
        [self.messageLabel setText:[NSString stringWithFormat:@"#%ld) %@", rankNo, college.name]];
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
