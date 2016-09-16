#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface bb_EventDetailsViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic,retain) UIPopoverController* popover;

@property (weak, nonatomic) IBOutlet UITextView* txtView_EventDetail;
@property (weak, nonatomic) IBOutlet UILabel* lbl_EventName;
@property (weak, nonatomic) IBOutlet UILabel* lbl_EventLocation;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (weak, nonatomic) IBOutlet UILabel* lbl_Reminder;
@property (weak, nonatomic) IBOutlet UILabel* lbl_DateTimeRange;

-(IBAction)didSetReminder:(id)sender;
-(IBAction)didPressBeDriver:(id)sender;



@end
