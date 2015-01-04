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

- (id)initWithType:(FeedSelectorType)type WithDataController:(DataController *)controller WithFeedDelegate:(id<FeedSelectionProtocol>) delegate
{
    self = [self initWithDataController:controller];
    if (self)
    {
        [self setType:type];
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
    
    // Search bar
    self.mySearchBar.hidden = YES;
    self.mySearchBar.layer.borderWidth = 2;
    self.mySearchBar.layer.cornerRadius = 5;
    
    // Search Display
    if (self.type == ALL_COLLEGES_WITH_SEARCH)
    {
        self.searchResult = [NSMutableArray arrayWithCapacity:[self.dataController.collegeList count]];
        [self.mySearchBar setHidden:NO];
        [self.mySearchBar setPlaceholder:@"Type a college's name"];
        [self.mySearchBar setKeyboardType:UIKeyboardTypeAlphabet];
        [self.mySearchBar setDelegate:self];
        
        self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.mySearchBar contentsController:self];
        
        self.searchDisplay.searchResultsTableView.frame = self.tableView.frame;
        self.searchDisplay.delegate = self;
        self.searchDisplay.searchResultsDataSource = self;
        self.searchDisplay.searchResultsDelegate = self;
    }
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
    if (self.type == ALL_COLLEGES_WITH_SEARCH)
    {
        return;
    }
    
    NSUInteger numNearbyColleges = self.dataController.nearbyColleges.count;
    float tableViewHeight = 0;
    BOOL collegesNearby = [self.dataController isNearCollege];
    
    if (self.type == ALL_NEARBY_OTHER)
    {
        // Handle two default cells that are always present
        tableViewHeight += 3 * TABLE_HEADER_HEIGHT;
        tableViewHeight += 2 * TABLE_CELL_HEIGHT;
    }
    
    if (collegesNearby)
    {
        for (int i = 0; i < numNearbyColleges; i++)
        {
//            float collegeCellHeight = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//            tableViewHeight += collegeCellHeight;
            tableViewHeight += TABLE_CELL_HEIGHT;
        }
    }
    else
    {
        tableViewHeight += TABLE_CELL_HEIGHT;
    }
    
    self.tableHeightConstraint.constant = tableViewHeight;
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
    if (self.type == ALL_NEARBY_OTHER)
    {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numNearby = self.dataController.nearbyColleges.count;
    BOOL isNearColleges = numNearby > 0;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            if (isNearColleges && section == 0)
            {
                return numNearby;
            }
            break;
        case ALL_COLLEGES_WITH_SEARCH:
            if (tableView == self.searchDisplay.searchResultsTableView)
            {
                return [self.searchResult count];
            }
            else
            {
                return self.dataController.collegeList.count;
            }
            break;
        default:
            break;
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

    LocationStatus status = self.dataController.locStatus;
    [cell hideLoadingIndicator];
    
    NSInteger numCollegesNearby = self.dataController.nearbyColleges.count;
    
    NSString *cellLabel = @"";
    if (self.type == ALL_NEARBY_OTHER)
    {
        NSInteger section = indexPath.section;
        
        if (status == LOCATION_SEARCHING || status == LOCATION_NOT_FOUND)
        {
            switch (section)
            {
                case 0:
                    if (status == LOCATION_SEARCHING)
                    {
                        [cell showLoadingIndicator];
                        cellLabel = @"Loading";
                    }
                    else
                    {
                        cellLabel = @"(None)";
                    }
                    break;
                case 1:
                    cellLabel = @"All Colleges";
                    break;
                case 2:
                    cellLabel = @"Choose a College";
                    break;
                default:
                    break;
            }
        }
        else // if (status == LOCATION_FOUND)
        {
            switch (section)
            {
                case 0:
                    if (numCollegesNearby > 0)
                    {
                        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
                        if (college != nil)
                        {
                            [cell assignCollege:college withRankNumberOrNil:nil];
                            return cell;
                        }
                    }
                    else
                    {
                        cellLabel = @"(None)";
                    }
                    break;
                case 1:
                    cellLabel = @"All Colleges";
                    break;
                case 2:
                    cellLabel = @"Choose a College";
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
        if (college != nil)
        {
            [cell assignCollege:college withRankNumberOrNil:nil];
            return cell;
        }
    }
    
    [cell assignSimpleText:cellLabel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {
            LocationStatus status = self.dataController.locStatus;
            NSInteger section = indexPath.section;
            
            if (section == 0 && status == LOCATION_FOUND)
            {   // Selected a nearby college
                College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
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
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
            [self.feedDelegate switchToFeedForCollegeOrNil:college];
            
            break;
        }
        default: break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.type == ALL_NEARBY_OTHER)
    {
        const int headerWidth = tableView.frame.size.width;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        UILabel *headerLabel;
        
        
        if (section == 0)
        {   // section of colleges 'near you'
            
            NSString *headerText = @"Near You";
            float gpsIconWidth = 20;
            float labelWidth = [headerText sizeWithAttributes:@{NSFontAttributeName:CF_FONT_LIGHT(14)}].width;
                                                                
            UIImageView *gpsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps.png"]];
            [gpsIcon setFrame:CGRectMake(0, 0, gpsIconWidth, gpsIconWidth)];
            [gpsIcon setCenter:CGPointMake((headerWidth / 2) + (labelWidth / 2), TABLE_HEADER_HEIGHT / 2)];
                    
            [headerView addSubview:gpsIcon];
            
            headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 0, headerWidth, TABLE_HEADER_HEIGHT)];
            [headerLabel setText:headerText];
        }
        else if (section == 1)
        {
            headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
            [headerLabel setText:@"Combines All Colleges into 1 Feed"];
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
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.type == ALL_COLLEGES_WITH_SEARCH)
    {
        return 0;
    }
    
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

#pragma mark - Private Helpers

- (College *)getCollegeForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{   // Given the indexPath, and knowing own FeedSelectorType,
    // Call the appropriate delegate's method to alert about the
    // college selection and in what context
    
    NSInteger numNearbyColleges = self.dataController.nearbyColleges.count;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {   // Initial prompt given to user to select which feed to view
            if (section == 0 && numNearbyColleges > row)
            {
                return [self.dataController.nearbyColleges objectAtIndex:row];
            }
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            if (tableView == self.searchDisplay.searchResultsTableView)
            {
                return [self.searchResult objectAtIndex:row];
            }
            else
            {
                return [self.dataController.collegeList objectAtIndex:row];
            }
            break;
        }
        default: break;
    }

    return nil;
}

#pragma mark - Search Bar

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"end editing");
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"begin editing");
    // Adjust views when search starts
    float windowHeight = self.view.frame.size.height;
    float dialogHeight = self.alertView.frame.size.height;
    
    self.dialogVerticalAlignment.constant = (windowHeight / 2) - (dialogHeight / 2) - 55;
    [self.view setNeedsUpdateConstraints];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    CGRect frame = self.tableView.frame;
    frame.origin.x += self.alertView.frame.origin.x;
    frame.origin.y -= 18;
    [tableView setFrame:frame];
}

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
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.dialogVerticalAlignment.constant = 0;
    [self.view setNeedsUpdateConstraints];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

@end
