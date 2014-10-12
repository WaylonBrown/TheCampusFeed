//
//  LoadingCell.m
// TheCampusFeed
//
//  Created by Patrick Sheehan on 8/14/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell

- (void)showLoadingIndicator
{
    [self.loadingIndicator startAnimating];
}
- (void)hideLoadingIndicator
{
    [self.loadingIndicator stopAnimating];
}

@end
