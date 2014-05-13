//
//  CreateViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/5/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CreateViewController.h"
#import "CommentViewController.h"
#import "Post.h"
#import "PostsViewController.h"
#import "Comment.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Actions

// cancel post/comment creation; dismiss screen
- (IBAction)cancel
{
    self.pDelegate = nil;
    self.cDelegate = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// create a new post using current user's credentials (somehow)
//- (IBAction)createPost
//{
//    Post *post = [[Post alloc] initDummy];
//    [post setMessage:self.textField.text];
//    
//    id<PostSubViewDelegate> strongDelegate = self.pDelegate;
//    [strongDelegate createdNewPost:post];
//}
//
//- (IBAction)createComment
//{
//    Comment *comment = [[Comment alloc] initDummy];
//    [comment setMessage:self.textField.text];
//    
//    id<CommentSubViewDelegate> strongDelegate = self.cDelegate;
//    [strongDelegate createdNewComment:comment];
//    //TODO: this comment needs its post ID somewhere; controller or here?
//}

- (IBAction)create
{
    if (self.pDelegate)
    {   // if post
        Post *post = [[Post alloc] initDummy];
        [post setMessage:self.textField.text];
    
        id<PostSubViewDelegate> strongDelegate = self.pDelegate;
        [strongDelegate createdNewPost:post];
    }
    else if (self.cDelegate)
    {   // if comment
        Comment *comment = [[Comment alloc] initDummy];
        [comment setMessage:self.textField.text];
    
        id<CommentSubViewDelegate> strongDelegate = self.cDelegate;
        [strongDelegate createdNewComment:comment];
        //TODO: this comment needs its post ID somewhere; controller or here?
    }
    else
    {
        [self cancel];
    }
}

@end

