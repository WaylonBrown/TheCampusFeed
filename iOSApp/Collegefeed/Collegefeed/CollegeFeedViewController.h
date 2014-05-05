//
//  CollegeFeedViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/4/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostDataController;
@class Post;

@interface CollegeFeedViewController : UIViewController

@property (strong, nonatomic) PostDataController *dataController;
@property (strong, nonatomic) Post* selectedPost;

@end
