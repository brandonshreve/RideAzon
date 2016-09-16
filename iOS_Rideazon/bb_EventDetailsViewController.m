#import "bb_EventDetailsViewController.h"
#import "bb_ServiceManager.h"
#import "bb_UserConfigSingleton.h"
#import "bb_PassengersViewController.h"

@implementation bb_EventDetailsViewController {
    bb_ServiceManager* _serviceManager;
    bb_EventEntity* _currentlySelectedEvent;
    bb_UserConfigSingleton* _userConfigSingleton;
}

-(void)viewWillAppear:(BOOL)animated {
    //Re-enable the back button for this viewcontroller
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidLoad {
    _serviceManager = [bb_ServiceManager new];
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _currentlySelectedEvent = _userConfigSingleton.currentlySelectedEvent;

    _txtView_EventDetail.text = _currentlySelectedEvent.eventDescription;
    _lbl_EventName.text = _currentlySelectedEvent.eventTitle;
    _lbl_EventLocation.text = _currentlySelectedEvent.eventLocation.locationAddress.addressDescription;

    _lbl_DateTimeRange.text = [NSString stringWithFormat:@"%@ - %@", _currentlySelectedEvent.eventStartDateTime, _currentlySelectedEvent.eventEndDateTime];

    float spanX = 0.00725;
    float spanY = 0.00725;

    MKCoordinateRegion region;
    region.center.latitude = [_currentlySelectedEvent.eventLocation.locationCoordinates.coordinatesLatitude doubleValue];
    region.center.longitude = [_currentlySelectedEvent.eventLocation.locationCoordinates.coordinatesLongitude doubleValue];
    region.span = MKCoordinateSpanMake(spanX, spanY);

    [self.mapView setRegion:region animated:YES];

    // Placing a pin
    MKPointAnnotation* annotation = [MKPointAnnotation new];
    [annotation setCoordinate:region.center];
    [self.mapView addAnnotation:annotation];
}

-(IBAction)didSetReminder:(id)sender {
    if ([_lbl_Reminder.text isEqualToString:kReminderRemindMe]) {
        _lbl_Reminder.text = kReminderCancelReminder;
    }
    else if (([_lbl_Reminder.text isEqualToString:kReminderCancelReminder])) {
        _lbl_Reminder.text = kReminderRemindMe;
    }
    NSLog(@"suck ");
}

-(IBAction)didPressBeDriver:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Seat Availability" message:@"How many seats are available for passengers?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Be a Driver", nil];

    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField* textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;

    [alertView textFieldAtIndex:0].placeholder = @"Seats";

    [alertView show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField* textField = [alertView textFieldAtIndex:0];
        NSInteger seatsAvailable = [textField.text integerValue];
        NSInteger tripType = 0;

        [_serviceManager registerUser:_userConfigSingleton.currentLoggedInUser AsDriverForEvent:_userConfigSingleton.currentlySelectedEvent withNumberOfSeats:seatsAvailable andTripType:tripType];
    }
}

@end
