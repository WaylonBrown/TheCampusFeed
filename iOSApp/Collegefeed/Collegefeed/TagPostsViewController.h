//
//  TagPostsViewController.h
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 12/1/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "PostsViewController.h"

@interface TagPostsViewController : PostsViewController

@property (strong, nonatomic) NSString* tagMessage;
@property (nonatomic, strong) UIBarButtonItem *backButton;

- (id)initWithDataController:(DataController *)controller WithTagMessage:(NSString *)text;

@end
