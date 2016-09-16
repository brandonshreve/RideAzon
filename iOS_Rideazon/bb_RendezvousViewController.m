#import "bb_RendezvousViewController.h"
#import "bb_UserConfigSingleton.h"
#import "bb_RendezvousEntity.h"

@interface bb_RendezvousViewController ()

@end

@implementation bb_RendezvousViewController {
    bb_UserConfigSingleton* _userConfigSingleton;
    NSDate* _dateToSave;
    NSDateFormatter* _localDateFormatter;
}

-(void)viewWillAppear:(BOOL)animated {
    self.txtField_RendezvousLocation.text = _userConfigSingleton.locationToSave.locationAddress.addressDescription;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _dateToSave = [NSDate new];
    _localDateFormatter = [bb_EventEntity getLocalDateFormatterForModel];

    //Give the textview a background color and round the edges
    self.txtView_DriverDescription.backgroundColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1.0f];
    self.txtView_DriverDescription.layer.cornerRadius=8.0f;
    self.txtView_DriverDescription.layer.masksToBounds=YES;

    //When Location Textfield is Selected Segue
    [self.txtField_RendezvousLocation setDelegate:self];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField*) textField {
    [self performSegueWithIdentifier:@"RendezvousToSelectLocationSegue" sender:self];
}

-(IBAction)didPressSave:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)didPressCancel:(id)sender {
    // User canceled "Be a Driver", just dismiss.
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)didSelectDepartDate:(id)sender {
    HSDatePickerViewController* hsdpvc = [HSDatePickerViewController new];
    [hsdpvc setDelegate:self];
    hsdpvc.minDate = [NSDate date];
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

#pragma mark - HSDatePickerViewControllerDelegate
-(void)hsDatePickerPickedDate:(NSDate*)date {
    if (date) {
        _dateToSave = date;

        _txtField_DepartTime.text = [_localDateFormatter stringFromDate:_dateToSave];
    }
}

@end