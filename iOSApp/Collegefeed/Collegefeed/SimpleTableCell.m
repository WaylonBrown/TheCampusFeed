//
//  TagCell.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/11/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "SimpleTableCell.h"
#import "Models/Models/Tag.h"
#import "Models/Models/College.h"
#import "Shared.h"

@implementation SimpleTableCell

- (void)awakeFromNib
{
    // Initialization code
    
    // Set font styles
    [self.messageLabel  setFont:CF_FONT_LIGHT(16)];
    [self.countLabel    setFont:CF_FONT_MEDIUM(12)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)assignTag:(Tag *)tag
{
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
- (void)assignCollege:(College *)college
{
    if (college != nil)
    {
        [self.messageLabel setText:college.name];
        [self.countLabel setText:@""];
    }
    else
    {
        [self.messageLabel setText:@""];
        [self.countLabel setText:@""];
    }
}

@end
