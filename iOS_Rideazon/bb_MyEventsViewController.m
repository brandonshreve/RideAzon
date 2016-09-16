#import <Foundation/Foundation.h>
#import "bb_MyEventsViewController.h"
#import "bb_ServiceManager.h"
#import "bb_EventTableViewCell.h"
#import "bb_EventEntity.h"
#import "bb_UserConfigSingleton.h"


@implementation bb_MyEventsViewController  {
    bb_UserConfigSingleton* _userConfigSingleton;
    bb_ServiceManager* _serviceManager;
    UIRefreshControl* _refreshControl;

    NSMutableArray* _eventsUserIsDriverFor;
    NSMutableArray* _passengersForUser;
}

#pragma mark - View Lifecycle
-(void)viewDidLoad {
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _serviceManager = [bb_ServiceManager new];

    [self refreshEvents];

    _refreshControl = [UIRefreshControl new];
    [_tableview addSubview:_refreshControl];

    [_refreshControl addTarget:self
                        action:@selector(refreshEvents)
              forControlEvents:UIControlEventValueChanged];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Everytime the view is going to appear, refresh events and refesh table view data.
    [self refreshEvents];

    //Gets rid of the back button for this view
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _passengersForUser.count;
            break;
        case 1:
            return _eventsUserIsDriverFor.count;
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"My Passengers" : @"Driver For Event";
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* CellIdentifier = @"eventTableViewCell";
    bb_EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bb_EventTableViewCell" owner:nil options:nil] objectAtIndex: 0];
    }

    if (indexPath.section == 0) {
        bb_UserEntity* entity = [_passengersForUser objectAtIndex:indexPath.row];

        cell.lbl_EventName.text = entity.userEmail;
        cell.lbl_DateTimeRange.hidden = YES;
        cell.lbl_EventLocation.hidden = YES;
    }
    else {
        bb_EventEntity* entity = [_eventsUserIsDriverFor objectAtIndex:indexPath.row];

        cell.lbl_EventName.text = entity.eventTitle;
        cell.lbl_DateTimeRange.hidden = YES;
        cell.lbl_EventLocation.hidden = YES;
    }

    return cell;
}

-(void)refreshEvents {
    NSArray* allEvents = [_serviceManager queryForAllEvents];
    _eventsUserIsDriverFor = [NSMutableArray new];
    _passengersForUser = [NSMutableArray new];

    for (bb_EventEntity* event in allEvents) {
        for (bb_UserEntity* driver in event.eventDrivers) {
            if (driver.userID == _userConfigSingleton.currentLoggedInUser.userID) {
                [_eventsUserIsDriverFor addObject:event];
            }
        }
    }

    for (bb_EventEntity* event in _eventsUserIsDriverFor) {
        [_passengersForUser addObjectsFromArray:[_serviceManager queryPassengersForEvent:event withDriver:_userConfigSingleton.currentLoggedInUser]];
    }

    [_tableview reloadData];
    [_refreshControl endRefreshing];
}

@end

