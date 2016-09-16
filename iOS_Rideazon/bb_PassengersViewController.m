#import "bb_PassengersViewController.h"
#import "bb_EventTableViewCell.h"
#import "bb_ServiceManager.h"
#import "bb_UserConfigSingleton.h"

@implementation bb_PassengersViewController {
    bb_UserConfigSingleton* _userConfigSingleton;
    bb_ServiceManager* _serviceManager;
    NSArray* _passengers;
}

#pragma mark - View Lifecycle
-(void)viewDidLoad {
    _tableview.delegate = self;
    _tableview.dataSource = self;

    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _passengers = [_serviceManager queryPassengersForEvent:_userConfigSingleton.currentlySelectedEvent withDriver:_userConfigSingleton.currentLoggedInUser];

    if (_passengers.count == 0) {
        _tableview.hidden = YES;
        _lbl_NoPassengers.hidden = NO;
    }
    else {
        _tableview.hidden = NO;
        _lbl_NoPassengers.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //Re-enable the back button for this viewcontroller
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_passengers count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* CellIdentifier = @"eventTableViewCell";
    bb_EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[bb_EventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    bb_UserEntity* entity = [_passengers objectAtIndex:indexPath.row];
    cell.textLabel.text = entity.userName;

    return cell;
}

@end
