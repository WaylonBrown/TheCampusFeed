//
//  TagViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Tag;

@interface TagViewController : MasterViewController<UITableViewDataSource, UITableViewDelegate>     //, TTTAttributedLabel>


@property (weak, nonatomic) Tag* selectedTag;


//@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tagsLabel;

//- (IBAction)something;
//- (void)showTagsList:(NSString *)tag;
//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

@end
