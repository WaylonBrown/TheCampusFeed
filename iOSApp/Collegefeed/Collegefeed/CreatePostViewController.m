//
//  CreatePostViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/4/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "CreatePostViewController.h"
#import "Post.h"
#import "PostsViewController.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

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

- (IBAction)cancel
{
//    [self.postTextField setText: nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// create a new post using current user's credentials (somehow)
- (IBAction)createPost
{
    Post *post = [[Post alloc] initDummy];
//    [post setMessage:@"Post: I was created in CPVController!"];
    [post setMessage:self.postTextField.text];
    
    id<PostSubViewDelegate> strongDelegate = self.delegate;
    [strongDelegate createdNewPost:post];
}
@end
