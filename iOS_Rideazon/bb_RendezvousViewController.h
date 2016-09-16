#import <UIKit/UIKit.h>
#import <HSDatePickerViewController/HSDatePickerViewController.h>

#import "bb_EventEntity.h"

@interface bb_RendezvousViewController : UIViewController <UITextFieldDelegate, HSDatePickerViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* txtField_NumPassengers;
@property (weak, nonatomic) IBOutlet UITextField* txtField_RendezvousLocation;
@property (weak, nonatomic) IBOutlet UITextField* txtField_DepartTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentControl_Outlet;
@property (weak, nonatomic) IBOutlet UITextView* txtView_DriverDescription;

-(IBAction)didPressSave:(id)sender;
-(IBAction)didPressCancel:(id)sender;
-(IBAction)didSelectDepartDate:(id)sender;
@end
