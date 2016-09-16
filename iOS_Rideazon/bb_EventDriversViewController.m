#import "bb_EventDriversViewController.h"
#import "bb_ServiceManager.h"
#import "bb_UserConfigSingleton.h"
#import "bb_EventTableViewCell.h"
#import "bb_DriverForEventEntity.h"

static NSString* const kEventTableViewCellIdentifier = @"eventTableViewCell";

@implementation bb_EventDriversViewController {
    bb_ServiceManager* _serviceManager;
    bb_DriverForEventEntity* _selectedDriver;
    bb_UserConfigSingleton* _userConfigSingleton;
    NSArray* _driversForEvent;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _serviceManager = [bb_ServiceManager new];
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _driversForEvent = [_serviceManager queryForDriversForEvent:_userConfigSingleton.currentlySelectedEvent];

    if (_driversForEvent.count == 0) {
        _tableView.hidden = YES;
        _lbl_NoDrivers.hidden = NO;
    }
    else {
        _tableView.hidden = NO;
        _lbl_NoDrivers.hidden = YES;
    }

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Drivers for event";
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _driversForEvent.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    bb_EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kEventTableViewCellIdentifier];

    if (cell == nil) {
        cell = [[bb_EventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kEventTableViewCellIdentifier];
    }

    bb_DriverForEventEntity* entity = [_driversForEvent objectAtIndex:indexPath.row];

    cell.textLabel.text = entity.driverForEventDriver.userName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d seats available", [entity.driverForEventAvailableSpace intValue]];

    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    _selectedDriver = [_driversForEvent objectAtIndex:indexPath.row];
    _userConfigSingleton.currentlySelectedDriver = _selectedDriver;

    if (_selectedDriver) {
        NSString* passengerMessage = [NSString stringWithFormat:@"Are you sure you want a ride to \"%@\" from this driver?", _userConfigSingleton.currentlySelectedEvent.eventTitle];

        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Ride" message:passengerMessage delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [_serviceManager registerUser:_userConfigSingleton.currentLoggedInUser AsPassengerForEvent:_userConfigSingleton.currentlySelectedEvent withDriver:_userConfigSingleton.currentlySelectedDriver];

        // Refresh table view data, to update seat counts
        _driversForEvent = [_serviceManager queryForDriversForEvent:_userConfigSingleton.currentlySelectedEvent];
        [_tableView reloadData];
    }
}

@end
