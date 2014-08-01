//
//  FeedSelectViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 6/18/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "FeedSelectViewController.h"
#import "Shared.h"
#import "College.h"
#import "SimpleTableCell.h"
#import "DataController.h"

@implementation FeedSelectViewController

- (id)initWithType:(FeedSelectorType)type WithDataController:(DataController *)controller WithFeedDelegate:(id<FeedSelectionProtocol>) delegate
{
    self = [super init];
    if (self)
    {
        [self setType:type];
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        [self setDataController:controller];
        [self setNearbyCollegeList:self.dataController.nearbyColleges];
        [self setFullCollegeList:self.dataController.collegeList];
        [self setFeedDelegate:delegate];
    }
    return self;
    
}
- (id)initWithType:(FeedSelectorType)type WithDataController:(DataController *)controller WithPostingDelegate:(id<CollegeForPostingSelectionProtocol>) delegate
{
    self = [super init];
    if (self)
    {
        [self setType:type];
        [self setModalPresentationStyle:UIModalPresentationCustom];
        [self setTransitioningDelegate:self];
        [self setDataController:controller];
        [self setNearbyCollegeList:self.dataController.nearbyColleges];
        [self setFullCollegeList:self.dataController.collegeList];
        [self setPostingDelegate:delegate];
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
    
    if (self.type == ALL_COLLEGES_WITH_SEARCH)
    {
        self.searchResult = [NSMutableArray arrayWithCapacity:[self.fullCollegeList count]];
        
        // Search bar
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 44)];
        self.tableView.tableHeaderView = searchBar;

        [searchBar setKeyboardType:UIKeyboardTypeAlphabet];
        [searchBar setDelegate:self];
        self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        
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
    int numNearbyColleges = self.dataController.nearbyColleges.count;
    
    int collegeSection = 0;
    float tableViewHeight = 0;
    
    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool noCollegesNearby = self.dataController.foundLocation && ![self.dataController isNearCollege];
    bool collegesNearby = [self.dataController isNearCollege];


    switch (self.type)
    {
        case ALL_COLLEGES_WITH_SEARCH:
            return;
        case ALL_NEARBY_OTHER:
            collegeSection = 1;
            int numHeaders = (showLoadingIndicator || collegesNearby) ? 2 : 1;
            tableViewHeight += (TABLE_HEADER_HEIGHT * numHeaders);
            tableViewHeight += (TABLE_CELL_HEIGHT * 2); // 'All' and 'Other' options
            break;
        case ONLY_NEARBY_COLLEGES:
            break;
        default:
            break;
    }
    if (collegesNearby)
    {
        for (int i = 0; i < numNearbyColleges; i++)
        {
            float collegeCellHeight = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:collegeSection]];
            tableViewHeight += collegeCellHeight;
        }
    }
    else if (showLoadingIndicator)
    {
        tableViewHeight += TABLE_CELL_HEIGHT;
    }
    
    self.tableHeightConstraint.constant = tableViewHeight;
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Table View Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool collegesNearby = [self.dataController isNearCollege];
    
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            return (showLoadingIndicator || collegesNearby) ? 3 : 2;
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numNearby = self.nearbyCollegeList.count;
    bool isNearColleges = numNearby > 0;
    
    bool collegesNearby = [self.dataController isNearCollege];

    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            if (isNearColleges && section == 1)
            {
                return numNearby;
            }
            else
            {
                return 1;
            }
            break;
        case ALL_COLLEGES_WITH_SEARCH:
            if (tableView == self.searchDisplay.searchResultsTableView)
            {
                return [self.searchResult count];
            }
            else
            {
                return self.fullCollegeList.count;
            }
            break;
        case ONLY_NEARBY_COLLEGES:
            return numNearby;
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

    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool noCollegesNearby = self.dataController.foundLocation && ![self.dataController isNearCollege];
    bool collegesNearby = [self.dataController isNearCollege];
    
    NSString *cellLabel = @"";
    if (self.type == ALL_NEARBY_OTHER)
    {
        if (indexPath.section == 0)
        {
            cellLabel = @"All Colleges";
        }
        else if (showLoadingIndicator && indexPath.section == 1)
        {
            // TODO: DRAW LOADING INDICATOR ON THIS CELL
            cellLabel = @"Loading...";
        }
        else if (indexPath.section == 2 || (noCollegesNearby && indexPath.section == 1))
        {
            cellLabel = @"Choose a College";
        }
        else if (collegesNearby && indexPath.section == 1)
        {
            College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
            if (college != nil)
            {
                cellLabel = college.name;
            }
        }
    }
    
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
        if (college != nil)
        {
            cellLabel = college.name;
        }
    }
    [cell assignSimpleText:cellLabel];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {   // Initial prompt given to user to select which feed to view
            
            bool showLoadingIndicator = !self.dataController.foundLocation;
            bool noCollegesNearby = self.dataController.foundLocation && ![self.dataController isNearCollege];
            bool collegesNearby = [self.dataController isNearCollege];

            if (showLoadingIndicator && indexPath.section == 1)
            {
                return;
            }
            if (indexPath.section == 2)
            {   // Show new dialog of: all colleges to let user choose one they are not close to
                
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [self.feedDelegate showDialogForAllColleges];
                }];
            }
            else
            {   // When user chooses all colleges (nil selection) or one of the nearby ones
                [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
                }];
            }
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            }];
            break;
        }
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [self.postingDelegate submitSelectionForPostWithCollege:college];
            }];
            break;
        }
        default: break;
    }
    
    [self dismiss];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    const int headerWidth = tableView.frame.size.width;

    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool noCollegesNearby = self.dataController.foundLocation && ![self.dataController isNearCollege];
    bool collegesNearby = [self.dataController isNearCollege];
    
    if (section == 0)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, 1)];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel;
    
    if (section == 1 && (collegesNearby || showLoadingIndicator))
    {   // section of colleges 'near you'
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Near You"];
        
        UIImageView *gpsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps.png"]];
        [gpsIcon setFrame:CGRectMake((headerWidth / 2) + 35, 0, 20, 20)];
        
        [headerView addSubview:gpsIcon];
        
    }
    else// if ((noCollegesNearby && section == 1) || (collegesNearby && section == 2))
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
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == ALL_NEARBY_OTHER
        && (indexPath.section == 0 || indexPath.section == 2))
    {
        return TABLE_CELL_HEIGHT;
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
        if (college != nil)
        {
            NSString *text = college.name;
            return [Shared getSmallCellHeightEstimateWithText:text WithFont:CF_FONT_LIGHT(18)];
        }
    }
    
    return TABLE_CELL_HEIGHT;
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
    
    NSInteger numNearbyColleges = self.nearbyCollegeList.count;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
        {   // Initial prompt given to user to select which feed to view
            if (section == 1 && numNearbyColleges > row)
            {
                return [self.nearbyCollegeList objectAtIndex:row];
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
                return [self.fullCollegeList objectAtIndex:row];
            }
            break;
        }
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            return [self.nearbyCollegeList objectAtIndex:row];
            break;
        }
        default: break;
    }

    return nil;
}


#pragma mark - Search Bar

-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setFrame:self.tableView.frame];
    [self.alertView addSubview:tableView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.fullCollegeList filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

@end
