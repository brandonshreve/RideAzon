#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "bb_EventEntity.h"

typedef NS_ENUM(NSInteger, CreateEventDateType) {
    CreateEventDateTypeStart,
    CreateEventDateTypeEnd
};

@interface bb_CreateEventViewController : UIViewController <HSDatePickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField* txtField_EventName;
@property (weak, nonatomic) IBOutlet UITextField* txtField_EventDescription;

@property (weak, nonatomic) IBOutlet UITextField *textField_StartDate;
@property (weak, nonatomic) IBOutlet UITextField *textField_EndDate;
@property (weak, nonatomic) IBOutlet UITextField *textField_Location;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIButton* btnStartDate;
@property (weak, nonatomic) IBOutlet UIButton* btnEndDate;



-(IBAction)didPressStartDate:(id)sender;
-(IBAction)didPressEndDate:(id)sender;
-(IBAction)didPressSave:(id)sender;
-(IBAction)didPressCancel:(id)sender;

@end
