//
//  SelectCollegeViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "SelectCollegeViewController.h"
#import "Shared.h"
#import "Models/Models/College.h"

@interface SelectCollegeViewController ()

@end

@implementation SelectCollegeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alertView.layer.borderWidth = 2;
    self.alertView.layer.cornerRadius = 5;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    // Set fonts
    [self.titleLabel setFont:CF_FONT_LIGHT(30)];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    bool isNearColleges = self.nearbyCollegeList.count > 0;
    return isNearColleges ? 3 : 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }

    NSInteger numNearbyColleges = self.nearbyCollegeList.count;
    NSInteger numAllColleges = self.fullCollegeList.count;
    if (section == 1)
    {
        return (numNearbyColleges > 0)
            ? numNearbyColleges
            : numAllColleges;
    }
    else if (section == 2 && numNearbyColleges > 0)
    {
        return numAllColleges;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellLabel = @"";
    if (indexPath.section == 0)
    {
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:CF_FONT_LIGHT(18)];
        cellLabel = @"All Colleges";
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath];
        if (college != nil)
        {
            cellLabel = college.name;
            [cell.textLabel setFont:CF_FONT_LIGHT(14)];
        }
    }
    
    [cell.textLabel setText:cellLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    College *college = nil;
    if (indexPath.section != 0)
    {
        college = [self getCollegeForIndexPath:indexPath];
    }
    
    [self.delegate submitSelectionWithCollegeOrNil:college];
    [self dismiss];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    const int headerWidth = self.view.frame.size.width;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel;
    
    //**************
    // Keep messing with the view set up here for the choose feed dialog
    //**************
    
    if (section == 1 && self.nearbyCollegeList.count > 0)
    {   // section of colleges 'near you'
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Near You"];
        UIImageView *gpsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps.png"]];
        [gpsIcon setFrame:CGRectMake((headerWidth / 2) + 50, 5, 20, 20)];
        
        [headerView addSubview:gpsIcon];
        
    }
    else
    {   // section of all colleges
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Other Colleges"];
    }

    [headerView addSubview:headerLabel];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:CF_FONT_LIGHT(14)];
    [headerLabel setTintColor:[Shared getCustomUIColor:CF_WHITE]];
    [headerView setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
    
    return headerView;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0 : TABLE_HEADER_HEIGHT;
}

#pragma mark - Transitioning Protocol Methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController: (UIViewController *)presenting sourceController: (UIViewController *)source
{
    return self;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    if (vc2 == self)
    { // presenting
        [con addSubview:v2];
        v2.frame = v1.frame;
        self.alertView.transform = CGAffineTransformMakeScale(1.6,1.6);
        v2.alpha = 0;
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:0.25 animations:^{
            v2.alpha = 1;
            self.alertView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else
    { // dismissing
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.5,0.5);
            v1.alpha = 0;
        } completion:^(BOOL finished) {
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - Private Helpers

- (College *)getCollegeForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numNearbyColleges = self.nearbyCollegeList.count;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    College *college = nil;
    
    if (section == 1)
    {
        college = (numNearbyColleges > row)
        ? [self.nearbyCollegeList objectAtIndex:row]
        : [self.fullCollegeList objectAtIndex:row];
    }
    else if (section == 2 && numNearbyColleges > 0)
    {
        college = [self.fullCollegeList objectAtIndex:row];
    }
    
    return college;
}

@end
