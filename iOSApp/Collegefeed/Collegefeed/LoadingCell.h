//
//  LoadingCell.h
// TheCampusFeed
//
//  Created by Patrick Sheehan on 8/14/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end
