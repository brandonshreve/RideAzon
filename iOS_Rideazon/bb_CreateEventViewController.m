#import "HSDatePickerViewController.h"
#import "bb_CreateEventViewController.h"
#import "bb_UserConfigSingleton.h"
#import "bb_ServiceManager.h"
#import "bb_SelectLocationViewController.h"
#import "bb_EventEntity.h"

@implementation bb_CreateEventViewController {
    UIAlertView* _alertView;
    UIDatePicker* _picker;
    NSInteger _textFieldTag;
    NSDateFormatter* _dateFormatter;
    CreateEventDateType _dateType;

    bb_UserConfigSingleton* _userConfigSingleton;
    bb_ServiceManager* _serviceManager;

    bb_EventEntity* _newEvent;
}

-(void)viewWillAppear:(BOOL)animated {
    //Re-enable the back button for this viewcontroller
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    _textField_Location.text = _userConfigSingleton.locationToSave.locationAddress.addressDescription;

    _dateFormatter = [bb_EventEntity getLocalDateFormatterForModel];
}

-(void)viewDidLoad {
    _serviceManager = [bb_ServiceManager new];
    _dateFormatter = [NSDateFormatter new];
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _newEvent = [bb_EventEntity new];
    _newEvent.eventCreatedOn = [NSDate date];

    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    _userConfigSingleton.locationToSave = [bb_LocationEntity new];
}


#pragma mark - Private Methods
-(IBAction)didPressStartDate:(UITextField*)sender {
    _dateType = CreateEventDateTypeStart;

    HSDatePickerViewController* hsdpvc = [HSDatePickerViewController new];
    [hsdpvc setDelegate:self];
    hsdpvc.minDate = [NSDate date];
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

-(IBAction)didPressEndDate:(UITextField*)sender {
    _dateType = CreateEventDateTypeEnd;

    HSDatePickerViewController* hsdpvc = [HSDatePickerViewController new];
    [hsdpvc setDelegate:self];
    hsdpvc.minDate = [NSDate date];
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

-(IBAction)didPressSave:(id)sender {
    _newEvent.eventTitle = _txtField_EventName.text;
    _newEvent.eventDescription = _txtField_EventDescription.text;
    _newEvent.eventLocation = _userConfigSingleton.locationToSave;

    NSLog(@"Saving event : %@", _newEvent.description);

    [_serviceManager saveEvent:_newEvent];

    // Dismiss View, so events are displayed. On a delay to allow for the back end to do any processing
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(IBAction)didPressCancel:(id)sender {
    // User canceled create event, just dismiss.
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HSDatePickerViewControllerDelegate
-(void)hsDatePickerPickedDate:(NSDate*)date {
    switch (_dateType) {
        case CreateEventDateTypeStart:
            _newEvent.eventStartDateTime = date;
            _textField_StartDate.text = [_dateFormatter stringFromDate:_newEvent.eventStartDateTime];
            break;

        case CreateEventDateTypeEnd:
            _newEvent.eventEndDateTime = date;
            _textField_EndDate.text = [_dateFormatter stringFromDate:_newEvent.eventEndDateTime];
            break;

        default:
            break;
    }
}

@end
