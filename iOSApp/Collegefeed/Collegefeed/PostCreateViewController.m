//
//  PostCreateViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 1/8/15.
//  Copyright (c) 2015 Appuccino. All rights reserved.
//

#import "PostCreateViewController.h"
#import "College.h"
#import "DataController.h"
#import "Post.h"
#import "Shared.h"
#import "ToastController.h"

@interface PostCreateViewController ()

@property (strong, nonatomic) College *college;

@end

@implementation PostCreateViewController

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
    
    if (self.college != nil && self.college.name != nil)
    {
        self.subtitleLabel.text = [NSString stringWithFormat:@"Posting to %@", self.college.name];
    }
    
    [self.titleLabel setText:@"New Post"];
    self.cameraButtonWidth.constant = 40;
    
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

- (BOOL)assign:(College *)newCollege
{
    if (newCollege != nil)
    {
        self.college = newCollege;
        [self.view setNeedsLayout];
        return YES;
    }
    
    return NO;
}

- (IBAction)submit:(id)sender
{
    NSString *message = self.messageTextView.text;
    if ([Post withMessageIsValid:message])
    {
        NSLog(@"Post with message = %@ is valid", message);
        
        if (self.college != nil || self.college.collegeID > 0)
        {
            [self.dataController submitPostToNetworkWithMessage:message
                                                  withCollegeId:self.college.collegeID
                                                      withImage:self.imageView.image];
        }
        else
        {
            NSLog(@"College ID needed but not found for Post submission");
            [Shared queueToastWithSelector:@selector(toastPostFailed)];
        }
        
        [self dismiss:self];
    }
    else
    {
        NSLog(@"Post with message = %@ is NOT valid", message);
        [Shared queueToastWithSelector:@selector(toastInvalidPost)];
    }
}

@end
