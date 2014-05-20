//
//  CommentViewController.h
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/3/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentDataController;
@class Post;

@interface CommentViewController : UIViewController

@property (strong, nonatomic) CommentDataController *dataController;
@property (strong, nonatomic) Post *originalPost;

@property (weak, nonatomic) IBOutlet UITableView *originalPostTable;
@property (weak, nonatomic) IBOutlet UITableView *commentTable;

- (id)initWithOriginalPost:(Post*)post;// withDelegate:(id)postSubViewDelegate;

- (IBAction)done;
- (IBAction)createComment;

@end
