#import "bb_EventsViewController.h"
#import "bb_ServiceManager.h"
#import "bb_EventTableViewCell.h"
#import "bb_EventEntity.h"
#import "bb_UserConfigSingleton.h"

@implementation bb_EventsViewController {
    bb_UserConfigSingleton* _userConfigSingleton;
    bb_ServiceManager* _serviceManager;
    UIRefreshControl* _refreshControl;
    NSArray* _events;
}

#pragma mark - View Lifecycle
-(void)viewDidLoad {
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _serviceManager = [bb_ServiceManager new];
    _events = [_serviceManager queryForAllEvents];

    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    _refreshControl = [UIRefreshControl new];
    [_tableview addSubview:_refreshControl];

    [_refreshControl addTarget:self
                            action:@selector(refreshEvents)
                  forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Everytime the view is going to appear, refresh events and refesh table view data.
    _events = [_serviceManager queryForAllEvents];
    [_tableview reloadData];

    //Gets rid of the back button for this view
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_events count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* CellIdentifier = @"eventTableViewCell";
    bb_EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bb_EventTableViewCell" owner:nil options:nil] objectAtIndex: 0];
    }

    bb_EventEntity* entity = [_events objectAtIndex:indexPath.row];

    cell.lbl_EventName.text = entity.eventTitle;
    cell.lbl_EventLocation.text = entity.eventLocation.locationAddress.addressDescription;
    cell.lbl_DateTimeRange.text = [NSString stringWithFormat:@"%@", entity.eventStartDateTime];

    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    bb_EventEntity* selectedEvent = [_events objectAtIndex:indexPath.row];
    if (selectedEvent) {
        _userConfigSingleton.currentlySelectedEvent = selectedEvent;
    }

    [self performSegueWithIdentifier:@"eventDetailsSegue" sender:self];
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
    // Empty Search Bar, Revert to All Events
    if ([searchText isEqualToString:@""]) {
        _events = [_serviceManager queryForAllEvents];
    }
    else {
        _events = [_serviceManager queryForSearchTerm:searchText];
    }
    [_tableview reloadData];
}

//Dismiss the keyboard after "search" is clicked on the keyboard
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
}

-(void)refreshEvents {
    _events = [_serviceManager queryForAllEvents];
    [_tableview reloadData];
    [_refreshControl endRefreshing];
}

@end
