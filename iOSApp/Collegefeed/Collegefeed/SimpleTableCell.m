//
//  TagCell.m
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
    self.enclosingView.layer.masksToBounds = NO;
    self.enclosingView.layer.cornerRadius = 2;
    self.enclosingView.layer.shadowOffset = CGSizeMake(0, 1);
    self.enclosingView.layer.shadowRadius = 2;
    self.enclosingView.layer.shadowOpacity = 0.5;
    
    // Set font styles
    [self.messageLabel setTintColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    [self.countLabel    setFont:CF_FONT_MEDIUM(12)];
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

    if (tag != nil)
    {
        [self.messageLabel setText:tag.name];
        [self.countLabel setText:[NSString stringWithFormat:@"(%ld)", tag.score]];
    }
    else
    {
        [self.messageLabel setText:@""];
        [self.countLabel setText:@""];
    }
}
- (void)assignCollege:(College *)college withRankNumber:(long)rankNo
{
    [self.messageLabel setFont:CF_FONT_LIGHT(18)];

    if (college != nil)
    {
        [self.messageLabel setText:[NSString stringWithFormat:@"#%ld) %@", rankNo, college.name]];
        [self.countLabel setText:@""];
    }
    else
    {
        [self.messageLabel setText:@""];
        [self.countLabel setText:@""];
    }
}

@end
