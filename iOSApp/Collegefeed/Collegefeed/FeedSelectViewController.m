//
//  FeedSelectViewController.m
//  TheCampusFeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 TheCampusFeed. All rights reserved.
//

#import "FeedSelectViewController.h"
#import "Shared.h"
#import "College.h"
#import "SimpleTableCell.h"
#import "DataController.h"
#import "Constants.h"

@implementation FeedSelectViewController

- (id)initWithDataController:(DataController *)controller
{
    self = [super initWithNibName:@"FeedSelectViewController" bundle:nil];
    if (self)
    {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        [self setDataController:controller];
    }
    return self;
}

- (id)initWithDataController:(DataController *)controller WithFeedDelegate:(id<FeedSelectionProtocol>) delegate
{
    self = [self initWithDataController:controller];
    if (self)
    {
        [self setFeedDelegate:delegate];
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Dim the background view
    [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.75]];
    
    // Main alert view
    self.alertView.layer.borderWidth = 2;
    self.alertView.layer.cornerRadius = 5;
    
    // Table View
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.estimatedRowHeight = TABLE_CELL_HEIGHT;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Set fonts
    [self.titleLabel setFont:CF_FONT_LIGHT(30)];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self fixHeights];
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
- (void)fixHeights
{
    CGFloat tableViewHeight = 0;
    NSUInteger numNearbyColleges = self.dataController.nearbyColleges.count;
    
    // Handle two default cells that are always present
    tableViewHeight += 2 * TABLE_CELL_HEIGHT;
    
    // Three headers
    tableViewHeight += 3 * TABLE_HEADER_HEIGHT;
    
    // Each nearby college
    for (int i = 0; i < MAX(1, numNearbyColleges); i++)
    {
        tableViewHeight += self.tableView.estimatedRowHeight;
    }
    
    self.tableHeightConstraint.constant = tableViewHeight - 5;
    [self.view setNeedsUpdateConstraints];
}
- (void)updateLocation
{
    [self.tableView reloadData];
    [self fixHeights];
}

#pragma mark - Table View Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numNearby = self.dataController.nearbyColleges.count;
    BOOL isNearColleges = numNearby > 0;
    
    if (isNearColleges && section == 0)
    {
        return numNearby;
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleTableCell";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [cell hideLoadingIndicator];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 1)
    {
        [cell assignSimpleText:@"All Colleges"];
    }
    else if (section == 2)
    {
        [cell assignSimpleText:@"Search for a College"];
    }
    else if (section == 0)
    {
        [cell assignSimpleText:@"(None)"];

        LocationStatus status = self.dataController.locStatus;
        if (status == LOCATION_FOUND)
        {
            NSInteger numCollegesNearby = self.dataController.nearbyColleges.count;
            
            if (numCollegesNearby > 0)
            {
                College *college = [self.dataController.nearbyColleges objectAtIndex:row];
                if (college != nil);
                {
                    [cell assignCollege:college withRankNumberOrNil:nil];
                    return cell;
                }
            }
        }
        else if (status == LOCATION_SEARCHING)
        {
            [cell assignSimpleText:@"Loading"];
            [cell showLoadingIndicator];
        }
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationStatus status = self.dataController.locStatus;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0 && status == LOCATION_FOUND)
    {   // Selected a nearby college
        College *college = [self.dataController.nearbyColleges objectAtIndex:row];
        [self.feedDelegate switchToFeedForCollegeOrNil:college];
    }
    else if (section == 1)
    {   // Selected all colleges
        [self.feedDelegate switchToFeedForCollegeOrNil:nil];
    }
    else if (section == 2)
    {   // Search for a college
        [self.feedDelegate showDialogForAllColleges];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    const int headerWidth = tableView.frame.size.width;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel;
    
    if (section == 0)
    {   // section of colleges 'near you'
        
        [self.nearYouHeaderView setFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [self.nearYouHeaderView setBackgroundColor:[Shared getCustomUIColor:CF_LIGHTGRAY]];
        
        [self.nearYouLabel setFont:CF_FONT_LIGHT(14)];
        
        return self.nearYouHeaderView;

    }
    else if (section == 1)
    {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Combines All Into One Feed"];
    }
    else if (section == 2)
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
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

#pragma mark - Search Bar

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"START: filter content for search text");
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.dataController.collegeList filteredArrayUsingPredicate:resultPredicate]];

    NSLog(@"END: filter content for search text");
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"START: should reload table for search string");
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    NSLog(@"END: should reload table for search string");
    
    return YES;
}


@end
