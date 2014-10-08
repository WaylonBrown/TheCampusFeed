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
    [self.mySearchBar setHidden:YES];
    
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
    NSUInteger numNearbyColleges = self.dataController.nearbyColleges.count;
    
    int collegeSection = 0;
    float tableViewHeight = 0;
    
//    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool showLoadingIndicator = self.dataController.locStatus == LOCATION_SEARCHING;
    bool collegesNearby = [self.dataController isNearCollege];


    switch (self.type)
    {
        case ALL_COLLEGES_WITH_SEARCH:
            return;
        case ALL_NEARBY_OTHER:
            collegeSection = 0;
            int numHeaders = (showLoadingIndicator || collegesNearby) ? 3 : 2;
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
- (void)foundLocation
{
    [self.tableView reloadData];
    [self fixHeights];
}
- (void)didNotFindLocation
{
    
}

#pragma mark - Table View Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    bool showLoadingIndicator = !self.dataController.foundLocation;
//    bool collegesNearby = [self.dataController isNearCollege];
    
    if (self.type == ALL_NEARBY_OTHER)
    {
        switch (self.dataController.locStatus)
        {
            case LOCATION_FOUND:
                return ([self.dataController isNearCollege]) ? 3 : 2;
                break;
            case LOCATION_SEARCHING:
                return 3;
                break;
            case LOCATION_NOT_FOUND:
                return 2;
                break;
            default:
                break;
        }
    }
//    switch (self.type)
//    {
//        case ALL_NEARBY_OTHER:
//            if (self.dataController.locStatus)
//            return (showLoadingIndicator || collegesNearby) ? 3 : 2;
//            break;
//        default:
//            break;
//    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numNearby = self.dataController.nearbyColleges.count;
    bool isNearColleges = numNearby > 0;
    
    switch (self.type)
    {
        case ALL_NEARBY_OTHER:
            if (!isNearColleges)
            {
                return 1;
            }
            else if (section == 0) // && isNearColleges
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

//    bool showLoadingIndicator = !self.dataController.foundLocation;
//    bool stillFindingLocation = self.dataController.locStatus == LOCATION_SEARCHING;
    LocationStatus status = self.dataController.locStatus;
//    bool noCollegesNearby = self.dataController.foundLocation && ![self.dataController isNearCollege];
    
    
//    bool collegesNearby = [self.dataController isNearCollege];
    [cell hideLoadingIndicator];
    
    NSInteger numCollegesNearby = self.dataController.nearbyColleges.count;
    
    NSString *cellLabel = @"";
    if (self.type == ALL_NEARBY_OTHER)
    {
        NSInteger section = indexPath.section;
        
        if (status == LOCATION_SEARCHING)
        {
            switch (section)
            {
                case 0:
                    [cell showLoadingIndicator];
                    cellLabel = @"Loading...";
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
        else if (LOCATION_FOUND && numCollegesNearby > 1)
        {
            switch (section)
            {
                case 0:
                {
                    College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
                    if (college != nil)
                    {
                        float labelHeight = [Shared getSmallCellMessageHeight:college.name WithFont:CF_FONT_LIGHT(18) withWidth:265];
                        [cell assignCollege:college withRankNumber:-1 withMessageHeight:labelHeight];
                        return cell;
                    }
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
        else // (LOCATION_FOUND && numCollegesNearby == 0) || (LOCATION_NOT_FOUND)
        {
            switch (section)
            {
                case 0:
                    cellLabel = @"All Colleges";
                    break;
                case 1:
                    cellLabel = @"Choose a College";
                    break;
                default:
                    break;
            }
            
        }
        
        
//        else if ((section == 0 && !showLoadingIndicator) || (section == 1) && showLoadingIndicator)
//        {
//            cellLabel = @"All Colleges";
//        }
//        else if (section == 1 &&)
        
//        if (indexPath.section == 1)
//        {
//            cellLabel = @"All Colleges";
//        }
//        else if (showLoadingIndicator && indexPath.section == 0)
//        {
//            [cell showLoadingIndicator];
//            cellLabel = @"Loading...";
//        }
//        else if (indexPath.section == 2 || (noCollegesNearby && indexPath.section == 0))
//        {
//            cellLabel = @"Choose a College";
//        }
//        else if (collegesNearby && indexPath.section == 0)
//        {
//            College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
//            if (college != nil)
//            {
//                float labelHeight = [Shared getSmallCellMessageHeight:college.name WithFont:CF_FONT_LIGHT(18) withWidth:265];
//                [cell assignCollege:college withRankNumber:-1 withMessageHeight:labelHeight];
//                return cell;
//            }
//        }
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
        if (college != nil)
        {
            float labelHeight = [Shared getSmallCellMessageHeight:college.name WithFont:CF_FONT_LIGHT(18) withWidth:265];
            [cell assignCollege:college withRankNumber:-1 withMessageHeight:labelHeight];
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
        {   // Initial prompt given to user to select which feed to view
            
//            bool showLoadingIndicator = !self.dataController.foundLocation;
            bool showLoadingIndicator = self.dataController.locStatus == LOCATION_SEARCHING;
            
            if (showLoadingIndicator && indexPath.section == 0)
            {
                return;
            }
            if (indexPath.section == 2)
            {   // Show new dialog of: all colleges to let user choose one they are not close to
                
                [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
                    [self.feedDelegate showDialogForAllColleges];
                }];
            }
            else
            {   // When user chooses all colleges (nil selection) or one of the nearby ones
                [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
                    College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
                    [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
                }];
            }
            break;
        }
        case ALL_COLLEGES_WITH_SEARCH:
        {   // When user wants to see all colleges and be able to search through them
            [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
                College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
                [self.feedDelegate submitSelectionForFeedWithCollegeOrNil:college];
            }];
            break;
        }
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
                College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
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

//    bool showLoadingIndicator = !self.dataController.foundLocation;
    bool showLoadingIndicator = self.dataController.locStatus == LOCATION_SEARCHING;

    bool collegesNearby = [self.dataController isNearCollege];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
    UILabel *headerLabel;
    
    if (section == 0 && (collegesNearby || showLoadingIndicator))
    {   // section of colleges 'near you'
        
        NSString *headerText = @"Near You";
        float gpsIconWidth = 20;
        float labelWidth = [headerText sizeWithAttributes:@{NSFontAttributeName:CF_FONT_LIGHT(14)}].width;
                                                            
        UIImageView *gpsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gps.png"]];
//        [gpsIcon setFrame:CGRectMake((headerWidth / 2) + 35, 0, gpsIconWidth, gpsIconWidth)];
//        [gpsIcon setCenter:CGPointMake((headerWidth / 2) + 40, TABLE_HEADER_HEIGHT / 2)];
        [gpsIcon setFrame:CGRectMake(0, 0, gpsIconWidth, gpsIconWidth)];
        [gpsIcon setCenter:CGPointMake((headerWidth / 2) + (labelWidth / 2) + (gpsIconWidth / 2), TABLE_HEADER_HEIGHT / 2)];
        
        [headerView addSubview:gpsIcon];
        
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:headerText];
    }
    else if ((!collegesNearby && section == 0) || (collegesNearby && section == 1))
    {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, TABLE_HEADER_HEIGHT)];
        [headerLabel setText:@"Combines All Colleges into 1 Feed"];
    }
    else if ((!collegesNearby && section == 1) || (collegesNearby && section == 2))
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
    if (self.type == ONLY_NEARBY_COLLEGES)
    {
        return 0;
    }
    
    return TABLE_HEADER_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == ALL_NEARBY_OTHER
        && (indexPath.section == 1 || indexPath.section == 2))
    {
        return TABLE_CELL_HEIGHT;
    }
    else
    {
        College *college = [self getCollegeForIndexPath:indexPath inTableView:tableView];
        if (college != nil)
        {
            NSString *text = college.name;
            return [Shared getSmallCellHeightEstimateWithText:text WithFont:CF_FONT_LIGHT(18) withWidth:265];
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
        case ONLY_NEARBY_COLLEGES:
        {   // When user is selecting which of nearby colleges to post to
            return [self.dataController.nearbyColleges objectAtIndex:row];
            break;
        }
        default: break;
    }

    return nil;
}

#pragma mark - Search Bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
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
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.dataController.collegeList filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
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
