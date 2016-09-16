#import <UIKit/UIKit.h>

@interface bb_EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* lbl_EventName;
@property (weak, nonatomic) IBOutlet UILabel* lbl_DateTimeRange;
@property (weak, nonatomic) IBOutlet UILabel* lbl_EventLocation;
@property (weak, nonatomic) IBOutlet UILabel* lbl_Reminder;

-(IBAction)didSelectRemindMe:(id)sender;

@end
