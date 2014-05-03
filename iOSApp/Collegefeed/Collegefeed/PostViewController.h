//
//  PostViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/2/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward declaration that the data controller exists
@class PostDataController;

@interface PostViewController : UITableViewController

@property (strong, nonatomic) PostDataController *dataController;
@property (strong, nonatomic) NSIndexPath* selectedPostIndexPath;
@property (strong, nonatomic) NSString* selectedPostMessage;

@end
