//
//  CommentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentDataController;

@interface CommentViewController : UITableViewController

@property (strong, nonatomic) CommentDataController *dataController;
@property (weak, nonatomic) IBOutlet UILabel *postMessage;

@end
