//
//  CommentCreateViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/9/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "CommentCreateViewController.h"
#import "Comment.h"
#import "DataController.h"
#import "ToastController.h"
#import "Shared.h"

@interface CommentCreateViewController ()

@property long postId;

@end

@implementation CommentCreateViewController

#pragma mark - View life cycle

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"CreateViewController" bundle:nil];
    if (self)
    {
        self.dataController = controller;
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        return self;
    }
    return nil;
}
- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.titleLabel setText:@"New Comment"];
    [self.subtitleLabel setText:@""];
    self.cameraButtonWidth.constant = 0;
    self.cameraButton.hidden = YES;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)assignWithPostId:(long)postId
{
    self.postId = postId;
    return YES;
}

- (IBAction)submit:(id)sender
{
    NSString *message = self.messageTextView.text;
    if ([Comment withMessageIsValid:message])
    {
        NSLog(@"Comment with message = %@ is valid", message);
        
        if (self.postId > 0)
        {
            [self.dataController submitCommentToNetworkWithMessage:message
                                                        withPostId:self.postId];
        }
        else
        {
            NSLog(@"Post ID needed but not found for Comment submission");
            [Shared queueToastWithSelector:@selector(toastCommentFailed)];
        }
        
        [self dismiss:self];
    }
    else
    {
        NSLog(@"Comment with message = %@ is NOT valid", message);
        [Shared queueToastWithSelector:@selector(toastInvalidComment)];
    }
}

@end
