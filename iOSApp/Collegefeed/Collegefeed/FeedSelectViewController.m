//
//  FeedSelectViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "FeedSelectViewController.h"
#import "Shared.h"
#import "Models/Models/College.h"

@implementation FeedSelectViewController

- (id)initWithType:(FeedSelectorType)type
{
    self = [super init];
    if (self)
    {
        [self setType:type];
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
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

    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            return isNearColleges ? 3 : 2;
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    bool isNearColleges = self.nearbyCollegeList.count > 0;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            if (isNearColleges && section == 1)
            {
                return self.nearbyCollegeList.count;
            }
            else
            {
                return 1;
            }
            break;
        case ALL_COLLEGES_WITH_SEARCH:
            // TODO: this needs to account for the search filtration
            return self.fullCollegeList.count;
            break;
        case ONLY_NEARBY_COLLEGES:
            return self.nearbyCollegeList.count;
            break;
        default:
            break;
    }
    return 1;
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
    
    if (self.type == ALL_NEARBY_OTHER && indexPath.section == 0)
    {
        cellLabel = @"All Colleges";
    }
    else if (self.type == ALL_NEARBY_OTHER && indexPath.section == 2)
    {
        cellLabel = @"Choose a College";
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath];
        if (college != nil)
        {
            cellLabel = college.name;
        }
    }
    [cell.textLabel setFont:CF_FONT_LIGHT(18)];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:cellLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    College *college = [self getCollegeForIndexPath:indexPath];
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {   // Initial prompt given to user to select which feed to view
            if (indexPath.section == 2)
            {   // Show new dialog of: all colleges to let user choose one they are not close to
                
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [self.feedDelegate showDialogForAllColleges];
                }];

                
//                [self dismiss];

//                FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_COLLEGES_WITH_SEARCH];
//                [controller setFullCollegeList:self.fullCollegeList];
//                [controller setFeedDelegate:self.feedDelegate];
                
                // TODO: not working yet
//                [self.navigationController presentViewController:controller animated:YES completion:nil];
            }
            else
            {   // When user chooses all colleges (nil selection) or one of the nearby ones
                [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            }
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            break;
        }
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            [self.postingDelegate submitSelectionForPostWithCollege:college];
            break;
        }
        default: break;
    }
    
    [self dismiss];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    const int headerWidth = tableView.frame.size.width;

    if (section == 0)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, 1)];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel;
    
    if (section == 1 && self.nearbyCollegeList.count > 0)
    {   // section of colleges 'near you'
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Near You"];
        
        UIImageView *gpsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps.png"]];
        [gpsIcon setFrame:CGRectMake((headerWidth / 2) + 35, 5, 20, 20)];
        
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
{   // Given the indexPath, and knowing own FeedSelectorType,
    // Call the appropriate delegate's method to alert about the
    // college selection and in what context
    
    NSInteger numNearbyColleges = self.nearbyCollegeList.count;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {   // Initial prompt given to user to select which feed to view
//            if (section == 0)
//            {
//                return nil;
////                college = nil;
//            }
            /*else*/if (section == 1 && numNearbyColleges > row)
            {
//                college =
                return self.nearbyCollegeList[row];
                
                //****
//                [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            }
            else // if (section == 2 || (section == 1 && numNearbyColleges is too small))
            {
                // Show all colleges to let user choose one they are not close to
                
                
//                //****
//                FeedSelectViewController *controller = [[FeedSelectViewController alloc] initWithType:ALL_COLLEGES_WITH_SEARCH];
//                [controller setFullCollegeList:self.fullCollegeList];
//                [controller setFeedDelegate:self.feedDelegate];
//                [self dismiss];
//                [self.navigationController presentViewController:controller animated:YES completion:nil];
            }
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            
//            college =
            return self.fullCollegeList[row];
            
            //*****
//            [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            
            // TODO: also need to account for if it has been filtered by a search
            //          (see CollegePickerViewController.m)
            
            break;
        }
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            
//            college =
            return self.nearbyCollegeList[row];
//            [self.postingDelegate submitSelectionForPostWithCollege:college];
            break;
        }
        default: break;
    }

    return nil;
}

@end
